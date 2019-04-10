//
//  MDRouterAdapter.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAdapter.h"
#import "MDRouterAdapter+Private.h"

#import "MDRouterConstants.h"
#import "MDRouterInvocation.h"

@implementation MDRouterAdapter

+ (instancetype)adapter {
    return [self adapterWithBaseURL:nil];
}

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL {
    return [[self alloc] initWithBaseURL:baseURL];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    if (self = [super init]) {
        _lock = [[NSRecursiveLock alloc] init];
        _baseURL = baseURL;
        _adapters = [NSMutableArray<MDRouterAdapter *> array];
        _invocations = [NSMutableArray<MDRouterInvocation *> array];
        _forwardURLs = [NSMutableDictionary<NSURL *, NSURL *> dictionary];
    }
    return self;
}

- (instancetype)init{
    return [self initWithBaseURL:nil];
}

#pragma mark - accessor

- (NSArray<MDRouterAdapter *> *)adapters {
    NSArray<MDRouterAdapter *> *adapters = nil;
    [_lock lock];
    adapters = [_adapters copy];
    [_lock unlock];
    return adapters;
}

- (MDRouterAdapter *)adapterWithBaseURL:(NSURL *)baseURL {
    MDRouterAdapter *adapter = nil;
    [_lock lock];
    adapter = [self _adapterWithBaseURL:baseURL];
    [_lock unlock];
    return adapter;
}

#pragma mark - private

- (MDRouterAdapter *)_adapterWithBaseURL:(NSURL *)baseURL {
    NSArray<MDRouterAdapter *> *adapters = [_adapters copy];
    if (![adapters count]) return nil;

    for (MDRouterAdapter *adapter in adapters) {
        if ([adapter _containedURL:baseURL]) return adapter;
    }
    return nil;
}

- (BOOL)_handleInvocationWithURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel {
    NSArray<MDRouterInvocation *> *invocationItems = [self _invocationsWithURL:URL];
    if (!invocationItems || ![invocationItems count]) return NO;
    
    if ([invocationItems count] == 1) {
        MDRouterInvocation *invocation = invocationItems.firstObject;
        __block NSError *innerError = nil;
        dispatch_block_t block = dispatch_block_create(0, ^{
            id result = [invocation invokeWithArguments:arguments error:&innerError];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wblock-capture-autoreleasing"
            if (output) *output = result;
            if (innerError && error) *error = innerError;
#pragma clang diagnostic pop
        });
        if (strcmp(queueLabel, dispatch_queue_get_label(invocation.queue)) == 0) {
            block();
        } else {
            dispatch_sync(invocation.queue, block);
        }

        return innerError == nil;
    }
    
    for (MDRouterInvocation *invocation in invocationItems) {
        __block NSError *innerError = nil;
        dispatch_block_t block = ^{
            [invocation invokeWithArguments:arguments error:&innerError];
        };
        
        dispatch_async(invocation.queue, block);
    }
    return YES;
}

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error {
    return NO;
}

- (NSDictionary *)_argumentsWithURL:(NSURL *)URL baseArguments:(NSDictionary *)baseArguments {
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:YES];
    NSArray<NSURLQueryItem *> *queryItems = [URLComponents queryItems];

    NSMutableDictionary *resultArguments = [baseArguments ?: @{} mutableCopy];
    for (NSURLQueryItem *queryItem in queryItems) {
        id value = [queryItem value];
        if ([value isKindOfClass:[NSString class]]) {
            value = [value stringByRemovingPercentEncoding] ?: value;
            if (value) {
                NSError *error = nil;
                id JSON = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                value = JSON ?: value;
            }
        }
        if (!value) continue;

        resultArguments[[queryItem name]] = value;
    }
    
    return resultArguments;
}

- (void)_addAdapter:(MDRouterAdapter *)adapter {
    [_adapters addObject:adapter];
}

- (void)_removeAdapter:(MDRouterAdapter *)adapter {
    [_adapters removeObject:adapter];
}

- (BOOL)_containedURL:(NSURL *)URL {
    return [self _validateURL:URL];
}

- (BOOL)_validateURL:(NSURL *)URL {
    BOOL valid = [self _validateURL:URL baseURL:_baseURL];
    if (valid) return YES;

    NSURL *toURL = _forwardURLs[URL];
    if (!toURL) return NO;

    return [self _validateURL:URL baseURL:toURL];
}

- (NSURL *)_forwardURL:(NSURL *)URL {
    NSDictionary<NSURL *, NSURL *> *forwardURLs= _forwardURLs.copy;
    for (NSURL *sourceURL in forwardURLs.allKeys) {
        if (![self _validateURL:URL baseURL:sourceURL]) continue;

        return forwardURLs[sourceURL];
    }
    return nil;
}

- (BOOL)_validateURL:(NSURL *)URL baseURL:(NSURL *)baseURL {
    if ([URL scheme] && ![[URL scheme] isEqualToString:[baseURL scheme]]) return NO;
    if ([URL host] && ![[URL host] isEqualToString:[baseURL host]]) return NO;
    if ([URL port] && ![[URL port] isEqual:[baseURL port]]) return NO;

    NSArray<NSString *> *basePathComponents = [[baseURL path] componentsSeparatedByString:@"/"];
    NSArray<NSString *> *pathComponents = [[URL path] componentsSeparatedByString:@"/"];

    if ([pathComponents count] > [basePathComponents count]) return NO;

    for (NSUInteger index = 0; index < [pathComponents count]; index++) {
        NSString *component = pathComponents[index];

        if (![basePathComponents[index] isEqualToString:component]) return NO;
    }
    return YES;
}

- (BOOL)_canOpenURL:(NSURL *)URL {
    for (MDRouterAdapter *adapter in [self adapters]) {
        if ([adapter canOpenURL:URL]) return YES;
    }

    if ([self _validateURL:URL]) return YES;

    return NO;
}

- (BOOL)_openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel {
    if (![self _validateURL:URL]) return NO;

    arguments = [self _argumentsWithURL:URL baseArguments:arguments];
    BOOL state = [self _handleInvocationWithURL:URL arguments:arguments output:output error:error queueLabel:queueLabel];
    if (state) return YES;

    for (MDRouterAdapter *adapter in _adapters.copy) {
        BOOL state = [adapter _openURL:URL arguments:arguments output:output error:error queueLabel:queueLabel];

        if (state) return YES;
    }

    return [self _handleURL:URL arguments:arguments output:output error:error];
}

- (NSArray<MDRouterInvocation *> *)_invocationsWithURL:(NSURL *)URL {
    NSURL *forwardURL = [self _forwardURL:URL];

    NSMutableArray<MDRouterInvocation *> *invocations = [NSMutableArray new];
    for (MDRouterInvocation *invocation in [_invocations copy]) {
        if ([invocation validatBaseURL:URL] || (forwardURL && [invocation validatBaseURL:forwardURL])) {
            [invocations addObject:invocation];
        }
    }
    return invocations;
}

- (MDRouterInvocation *)_invocationWithTarget:(id)target action:(SEL)action baseURL:(NSURL *)baseURL {
    for (MDRouterInvocation *invocation in [_invocations copy]) {
        if (invocation.target != target) continue;
        if (invocation.action != action) continue;
        if (![invocation validatBaseURL:baseURL]) continue;

        return invocation;
    }
    return nil;
}

- (BOOL)_addInvocation:(MDRouterInvocation *)invocation {
    MDRouterAdapter *adapter = [self _adapterWithBaseURL:invocation.baseURL];
    if (adapter) {
        return [adapter _addInvocation:invocation];
    }

    MDRouterInvocation *localInvocation = [self _invocationWithTarget:invocation.target action:invocation.action baseURL:invocation.baseURL];
    if (localInvocation) return NO;

    [_invocations addObject:invocation];
    return YES;
}

- (BOOL)_removeInvocation:(MDRouterInvocation *)invocation {
    MDRouterAdapter *adapter = [self _adapterWithBaseURL:invocation.baseURL];
    if (adapter) {
        return [adapter _removeInvocation:invocation];
    }

    MDRouterInvocation *localInvocation = [self _invocationWithTarget:invocation.target action:invocation.action baseURL:invocation.baseURL];
    if (localInvocation) [_invocations removeObject:invocation];

    return invocation != nil;
}

- (BOOL)_forwardURL:(NSURL *)URL toURL:(NSURL *)toURL {
    MDRouterAdapter *adapter = [self _adapterWithBaseURL:URL];
    if (adapter && [adapter _containedURL:URL]) {
        return [adapter _forwardURL:URL toURL:toURL];
    } else if ([self _containedURL:URL]) {
        _forwardURLs[URL] = toURL;
        return YES;
    }
    return NO;
}

#pragma mark - public

- (void)addAdapter:(MDRouterAdapter *)adapter {
    NSParameterAssert(adapter);
    NSParameterAssert(![_adapters containsObject:adapter]);
    [_lock lock];
    [self _addAdapter:adapter];
    [_lock unlock];
}

- (void)removeAdapter:(MDRouterAdapter *)adapter {
    NSParameterAssert(adapter);
    [_lock lock];
    [self _removeAdapter:adapter];
    [_lock unlock];
}

- (BOOL)addInvocation:(MDRouterInvocation *)invocation {
    NSParameterAssert(invocation);
    BOOL success = NO;
    [_lock lock];
    success = [self _addInvocation:invocation];
    [_lock unlock];
    return success;
}

- (BOOL)removeInvocation:(MDRouterInvocation *)invocation {
    NSParameterAssert(invocation);
    BOOL success = NO;
    [_lock lock];
    success = [self _removeInvocation:invocation];
    [_lock unlock];
    return success;
}

- (BOOL)removeInvocationWithTarget:(id)target action:(SEL)action baseURL:(NSURL *)baseURL {
    NSParameterAssert(target && action && baseURL);
    BOOL success = NO;
    [_lock lock];
    MDRouterInvocation *invocation = [self _invocationWithTarget:target action:action baseURL:baseURL];
    if (!invocation) return NO;

    success = [self _removeInvocation:invocation];
    [_lock unlock];
    return success;
}

- (BOOL)forwardURL:(NSURL *)URL toURL:(NSURL *)toURL {
    NSParameterAssert(URL && toURL);
    BOOL success = NO;
    [_lock lock];
    success = [self _forwardURL:URL toURL:toURL];
    [_lock unlock];
    return success;
}

- (BOOL)forwardURLString:(NSString *)URLString toURLString:(NSString *)toURLString {
    return [self forwardURL:[NSURL URLWithString:URLString] toURL:[NSURL URLWithString:toURLString]];
}

- (BOOL)canOpenURL:(NSURL *)URL {
    NSParameterAssert(URL);
    BOOL can = NO;
    [_lock lock];
    can = [self _canOpenURL:URL];
    [_lock unlock];
    return can;
}

- (BOOL)openURL:(NSURL *)URL {
    NSParameterAssert(URL);
    return [self openURL:URL error:NULL];
}

- (BOOL)openURL:(NSURL *)URL error:(NSError **)error {
    NSParameterAssert(URL);
    return [self openURL:URL arguments:nil output:NULL error:error];
}

- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error {
    NSParameterAssert(URL);
    return [self openURL:URL arguments:nil output:output error:error];
}

- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error {
    NSParameterAssert(URL);
    BOOL success = NO;
    [_lock lock];
    const char *label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
    success = [self _openURL:URL arguments:arguments output:output error:error queueLabel:label];
    [_lock unlock];
    return success;
}

- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error arguments:(id)key, ... {
    NSParameterAssert(URL);
    BOOL result = NO;
    va_list arguments;
    
    va_start(arguments, key);
    result = [self openURL:URL output:output error:error key:key arguments:arguments];
    va_end(arguments);
    
    return result;
}

- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error key:(NSString *)key arguments:(va_list)arguments {
    NSParameterAssert(URL);
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    NSInteger index = 0;
    id value = nil;
    do {
        if (index % 2) {
            key = va_arg(arguments, NSString *);
            if (!key) break;
        } else {
            value = va_arg(arguments, id);
            dictionary[key] = value ?: [NSNull null];
        }
        index++;
    } while (1);
    
    return [self openURL:URL arguments:dictionary output:output error:error];
}

@end
