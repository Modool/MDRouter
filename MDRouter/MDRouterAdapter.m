//
//  MDRouterAdapter.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAdapter.h"
#import "MDRouterAdapter+Private.h"
#import "MDRouterSolutionContainer.h"

#import "MDRouterConstants.h"
#import <pthread.h>

@implementation MDRouterAdapter
@synthesize baseURL = _baseURL;

+ (instancetype)adapter {
    return [self adapterWithBaseURL:nil];
}

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL {
    return [[self alloc] initWithBaseURL:baseURL];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    if (self = [super init]) {
        _baseURL = baseURL;
        _mutableAdapters = [NSMutableArray<MDRouterAdapter> new];
        _solutionContainer = [MDRouterSolutionContainer new];
    }
    return self;
}

- (instancetype)init{
    return [self initWithBaseURL:nil];
}

#pragma mark - accessor

- (NSArray<MDRouterAdapter> *)adapters{
    return [_mutableAdapters copy];
}

- (id<MDRouterAdapter>)adapterWithBaseURL:(NSURL *)baseURL{
    if (![[self adapters] ?: @[] count]) return nil;
    
    for (MDRouterAdapter *adapter in [self adapters]) {
        if ([adapter _validateURL:baseURL]) return adapter;
    }
    return nil;
}

#pragma mark - private

- (BOOL)_validateURL:(NSURL *)URL {
    if (![[URL scheme] isEqualToString:[[self baseURL] scheme]]) return NO;
    if (![[URL host] isEqualToString:[[self baseURL] host]]) return NO;
    
    NSArray<NSString *> *basePathComponents = [[[self baseURL] path] componentsSeparatedByString:@"/"];
    NSArray<NSString *> *pathComponents = [[URL path] componentsSeparatedByString:@"/"];
    
    if ([pathComponents count] > [basePathComponents count]) return NO;
    
    for (NSUInteger index = 0; index < [pathComponents count]; index++) {
        NSString *component = pathComponents[index];
        
        if (![basePathComponents[index] isEqualToString:component]) return NO;
    }
    
    return YES;
}

- (BOOL)_handleSolutionWithURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel {
    NSArray<MDRouterSolutionItem *> *solutionItems = [_solutionContainer solutionItemsWithURL:URL];
    if (!solutionItems || ![solutionItems count]) return NO;
    
    if ([solutionItems count] == 1) {
        MDRouterSolutionItem *item = solutionItems.firstObject;
        __block NSError *innerError = nil;
        dispatch_block_t block = dispatch_block_create(0, ^{
            id result = [item invokeWithArguments:arguments error:&innerError];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wblock-capture-autoreleasing"
            if (output) *output = result;
            if (innerError && error) *error = innerError;
#pragma clang diagnostic pop
        });
        if (strcmp(queueLabel, dispatch_queue_get_label(item.queue)) == 0) {
            block();
        } else {
            dispatch_sync(item.queue, block);
        }

        return innerError == nil;
    }
    
    for (MDRouterSolutionItem *solutionItem in solutionItems) {
        __block NSError *innerError = nil;
        dispatch_block_t block = ^{
            [solutionItem invokeWithArguments:arguments error:&innerError];
        };
        
        dispatch_async(solutionItem.queue, block);
    }
    return YES;
}

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error {
    return NO;
}

- (NSDictionary *)_argumentsWithURL:(NSURL *)URL baseArguments:(NSDictionary *)baseArguments{
    NSParameterAssert(URL);
    
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

#pragma mark - public

- (void)addAdapter:(id<MDRouterAdapter>)adapter {
    NSParameterAssert(adapter);
    NSParameterAssert(![_mutableAdapters containsObject:adapter]);
    
    [_mutableAdapters addObject:adapter];
}

- (void)removeAdapter:(id<MDRouterAdapter>)adapter {
    [_mutableAdapters removeObject:adapter];
}

- (void)addSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL {
    [self addSolution:solution baseURL:baseURL queue:dispatch_get_main_queue()];
}

- (void)addSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue {
    NSParameterAssert(baseURL && solution && [solution conformsToProtocol:@protocol(MDRouterSolution)]);
    
    id<MDRouterAdapter> adapter = [self adapterWithBaseURL:baseURL];
    if (adapter) {
        [adapter addSolution:solution baseURL:baseURL queue:queue];
    } else {
        [_solutionContainer addSolution:solution forBaseURL:baseURL queue:queue];
    }
}

- (BOOL)removeSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL {
    NSParameterAssert(baseURL && solution && [solution conformsToProtocol:@protocol(MDRouterSolution)]);
    
    id<MDRouterAdapter> adapter = [self adapterWithBaseURL:baseURL];
    BOOL state = NO;
    if (adapter) state = [adapter removeSolution:solution baseURL:baseURL];
    if (state) return state;

    return [_solutionContainer removeSolution:solution forBaseURL:baseURL];
}

- (BOOL)canOpenURL:(NSURL *)URL {
    for (id<MDRouterAdapter> adapter in [self adapters]) {
        if ([adapter canOpenURL:URL]) return YES;
    }
    
    if ([self _validateURL:URL]) return YES;
    
    return NO;
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
    return [self openURL:URL arguments:arguments output:output error:error queueLabel:NULL];
}

- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel {
    NSParameterAssert(URL);
    
    if (![self _validateURL:URL]) return NO;
    
    BOOL state = [self _handleSolutionWithURL:URL arguments:arguments output:output error:error queueLabel:queueLabel];
    if (state) return YES;
    
    for (id<MDRouterAdapter> adapter in [self adapters]) {
        BOOL state = [adapter openURL:URL arguments:arguments output:output error:error queueLabel:queueLabel];
        
        if (state) return YES;
    }
    
    return [self _handleURL:URL arguments:arguments output:output error:error];
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
