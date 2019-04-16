//
//  MDRouterImp.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <objc/runtime.h>

#import "MDRouterImp.h"
#import "MDRouterAdapter+Private.h"

#import "MDRouterConstants.h"
#import "NSSet+MDRouter.h"
#import "NSError+MDRouter.h"

#import "MDRouterBinder+Private.h"

#define MDSYNC(__VA_ARGS__) [self _sync:^{\
__VA_ARGS__\
}];

NSString * const MDRouterErrorDomain = @"com.modool.router.error.domain";
NSString * const MDRouterMethodPathPrefix = @"__MD_ROUTER_PATH_AS__";
NSString * const MDRouterMethodHostPrefix = @"__MD_ROUTER_HOST_AS__";

id MDRouterBoxValue(NSInvocation *invocation, NSUInteger index);

@interface MDRouter () {
    NSMutableSet<Protocol *> *_protocols;

    dispatch_queue_t _queue;
    void *_queueTag;

}

@end

@implementation MDRouter
@dynamic baseURL;

+ (instancetype)router {
    return [self routerWithBaseURL:nil];
}

+ (instancetype)routerWithBaseURL:(NSURL *)baseURL {
    return [[self alloc] initWithBaseURL:baseURL queue:nil];
}

+ (instancetype)routerWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue {
    return [[self alloc] initWithBaseURL:baseURL queue:queue];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue{
    if (self = [super initWithBaseURL:baseURL]) {
        if ([baseURL scheme]) {
            _validSchemes = [NSSet setWithObject:[baseURL scheme]];
        }
        if ([baseURL host]) {
            _validHosts = [NSSet setWithObject:[baseURL host]];
        }
        if ([baseURL port]) {
            _validPorts = [NSSet setWithObject:[baseURL port]];
        }
        if (queue) _queue = queue;
        else _queue = dispatch_queue_create("com.modool.router.serial.queue", DISPATCH_QUEUE_SERIAL);

        _protocols = [NSMutableSet set];

        _queueTag = &_queueTag;
        dispatch_queue_set_specific(_queue, _queueTag, _queueTag, NULL);

        [MDRouterBinder loadWithRouter:self];
    }
    return self;
}

#pragma mark - accessor

- (void)setValidSchemes:(NSSet<NSString *> *)validSchemes{
    MDSYNC(
        if (_validSchemes != validSchemes) {
            _validSchemes = [self invalidSchemes] ? [validSchemes setByMinusSet:[self invalidSchemes]] : validSchemes;
        }
    )
}

- (void)setInvalidSchemes:(NSSet<NSString *> *)invalidSchemes{
    MDSYNC(
        if (_invalidSchemes != invalidSchemes) {
            _invalidSchemes = [self validSchemes] ? [invalidSchemes setByMinusSet:[self validSchemes]]: invalidSchemes;
        }
    )
}

- (void)setValidHosts:(NSSet<NSString *> *)validHosts{
    MDSYNC(
        if (_validHosts != validHosts) {
            _validHosts = [self invalidHosts] ? [validHosts setByMinusSet:[self invalidHosts]]: validHosts;
        }
    )
}

- (void)setInvalidHosts:(NSSet<NSString *> *)invalidHosts{
    MDSYNC(
        if (_invalidHosts != invalidHosts) {
            _invalidHosts = [self validHosts] ? [invalidHosts setByMinusSet:[self validHosts]]: invalidHosts;
        }
    )
}

- (void)setValidPorts:(NSSet<NSNumber *> *)validPorts{
    MDSYNC(
        if (_validPorts != validPorts) {
            _validPorts = [self invalidPorts] ? [validPorts setByMinusSet:[self invalidPorts]]: validPorts;
        }
    )
}

- (void)setInvalidPorts:(NSSet<NSNumber *> *)invalidPorts{
    MDSYNC(
        if (_invalidPorts != invalidPorts) {
            _invalidPorts = [self validPorts] ? [invalidPorts setByMinusSet:[self validPorts]]: invalidPorts;
        }
    )
}

#pragma mark - private

- (BOOL)_validateURL:(NSURL *)URL{
    if ([self invalidSchemes] && [[self invalidSchemes] containsObject:[URL scheme]]) return NO;
    if ([self invalidHosts] && [[self invalidHosts] containsObject:[URL host]]) return NO;
    if ([self invalidPorts] && [[self invalidPorts] containsObject:[URL port]]) return NO;
    
    if ([self validSchemes] && ![[self validSchemes] containsObject:[URL scheme]]) return NO;
    if ([self validHosts] && ![[self validHosts] containsObject:[URL host]]) return NO;
    if ([self validPorts] && ![[self validPorts] containsObject:[URL port]]) return NO;
    
    return YES;
}

- (void)_async:(dispatch_block_t)block {
    if (dispatch_get_specific(_queueTag)) block();
    else dispatch_async(_queue, block);
}

- (void)_sync:(dispatch_block_t)block {
    if (dispatch_get_specific(_queueTag)) block();
    else dispatch_sync(_queue, block);
}

- (BOOL)_openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel {
    NSParameterAssert(URL);

    __block BOOL success = NO;
    [self _sync:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wblock-capture-autoreleasing"
        success = [super _openURL:URL arguments:arguments output:output error:error queueLabel:queueLabel];
#pragma clang diagnostic pop
        if (!success && error && *error == nil) {
            *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeInvalidURL userInfo:@{NSLocalizedDescriptionKey: @"Failed to redirect invalid URL."} underlyingError:*error];
        }
    }];

    return success;
}

- (void)_removeProtocol:(Protocol *)protocol {
    [_protocols removeObject:protocol];
}

- (void)_addProtocol:(Protocol *)protocol {
    [_protocols addObject:protocol];
}

- (NSURL *)_URLWithInvocation:(NSInvocation *)invocation {
    NSMethodSignature *signature = invocation.methodSignature;

    NSString *host;
    NSString *path = nil;
    NSArray *queryItemNames = nil;
    BOOL success = [self _searchForSelector:invocation.selector host:&host path:&path queryItemNames:&queryItemNames];
    if (!success || !path) return nil;

    NSString *URLString = [NSString stringWithFormat:@"%@://", MDRouterMethodScheme];
    if (host) URLString = [URLString stringByAppendingString:host];
    if (path) {
        if (host) {
            URLString = [URLString stringByAppendingFormat:@"/%@", path];
        } else {
            URLString = [URLString stringByAppendingString:path];
        }
    }

    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithString:URLString];
    if (queryItemNames.count) {
        NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
        NSUInteger count = signature.numberOfArguments - 2;

        for (int index = 0; index < count; index++) {
            id value = MDRouterBoxValue(invocation, index + 2);
            NSURLQueryItem *item = [self _queryItemWithName:queryItemNames[index] value:value];

            [queryItems addObject:item];
        }
        URLComponents.queryItems = queryItems;
    }
   return [URLComponents URL];
}

- (NSURLQueryItem *)_queryItemWithName:(NSString *)name value:(id)value {
    NSString *string = [self _stringValueFromObject:value];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    return [NSURLQueryItem queryItemWithName:name value:string];
}

- (NSString *)_stringValueFromObject:(id)object {
    if ([object isKindOfClass:NSDictionary.class] || [object isKindOfClass:NSArray.class]) return [self _stringValueFromJSON:object];
    if ([object isKindOfClass:NSNumber.class]) return [object stringValue];
    if (![object isKindOfClass:NSString.class]) return [object description];

    return object;
}

- (NSString *)_stringValueFromJSON:(id)object {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!data || error) return nil;

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSMethodSignature *)_methodSignatureForSelector:(SEL)selector protocol:(Protocol *)protocol {
    struct objc_method_description description = protocol_getMethodDescription(protocol, selector, YES, YES);
    if (description.name && description.types) return [NSMethodSignature signatureWithObjCTypes:description.types];

    description = protocol_getMethodDescription(protocol, selector, NO, YES);
    if (description.name && description.types) return [NSMethodSignature signatureWithObjCTypes:description.types];

    return nil;
}

- (BOOL)_searchForSelector:(SEL)selector host:(NSString **)hostPtr path:(NSString **)pathPtr queryItemNames:(NSArray **)queryItemNamesPtr protocol:(Protocol *)protocol {
    NSString *selectorName = NSStringFromSelector(selector);

    unsigned int count = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &count);

    for (int i = 0; i < count; i++) {
        struct objc_method_description method = methods[i];

        NSString *methodName = NSStringFromSelector(method.name);
        if (![methodName containsString:selectorName]) continue;
        if (![methodName containsString:MDRouterMethodPathPrefix]) continue;
        //    methodName
        //    methodName__MD_ROUTER_HOST_AS__host:__MD_ROUTER_PATH_AS__path:
        //    __MD_ROUTER_HOST_AS__host:__MD_ROUTER_PATH_AS__path:

        //    methodName:arg:
        //    methodName:arg:_MD_ROUTER_HOST_AS__host:__MD_ROUTER_PATH_AS__path:firstName:
        //    _MD_ROUTER_HOST_AS__host:__MD_ROUTER_PATH_AS__path:firstName:
        NSString *string = [methodName stringByReplacingOccurrencesOfString:selectorName withString:@""];

        NSArray<NSString *> *labels = [string componentsSeparatedByString:@":"];
        NSString *first = labels.firstObject;
        if ([first containsString:MDRouterMethodHostPrefix]) {
            NSString *host = [first stringByReplacingOccurrencesOfString:MDRouterMethodHostPrefix withString:@""];

            labels = [labels subarrayWithRange:NSMakeRange(1, labels.count - 1)];
            if (hostPtr) *hostPtr = host;
        }

        first = labels.firstObject;
        if ([first containsString:MDRouterMethodPathPrefix]) {
            NSString *path = [first stringByReplacingOccurrencesOfString:MDRouterMethodPathPrefix withString:@""];

            labels = [labels subarrayWithRange:NSMakeRange(1, labels.count - 1)];
            if (pathPtr) *pathPtr = path;
        }

        first = labels.firstObject;
        if (first) {
            NSArray<NSString *> *argumentNames = [methodName componentsSeparatedByString:@":"];

            NSMutableArray<NSString *> *queryItemNames = [argumentNames mutableCopy];
            [queryItemNames replaceObjectAtIndex:0 withObject:first];

            NSUInteger count = [[selectorName componentsSeparatedByString:@":"] count] - 1;
            if (queryItemNamesPtr) *queryItemNamesPtr = [queryItemNames subarrayWithRange:NSMakeRange(0, count)];
        }
        return YES;
    }
    return NO;
}

- (BOOL)_searchForSelector:(SEL)selector host:(NSString **)hostPtr path:(NSString **)pathPtr queryItemNames:(NSArray **)queryItemNamesPtr {
    for (Protocol *protocol in _protocols.copy) {
        BOOL success = [self _searchForSelector:selector host:hostPtr path:pathPtr queryItemNames:queryItemNamesPtr protocol:protocol];
        if (success) return success;;
    }
    return NO;
}

#pragma mark - invocation

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    for (Protocol *protocol in _protocols.copy) {
        NSMethodSignature *signature = [self _methodSignatureForSelector:aSelector protocol:protocol];
        if (signature) return signature;
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSURL *URL = [self _URLWithInvocation:anInvocation];

    id output = nil;
    NSError *error = nil;
    BOOL success = [self openURL:URL arguments:nil output:&output error:&error];

    if (success) {
        anInvocation.returnValue = &output;
        anInvocation.target = nil;

        [anInvocation retainArguments];
        [anInvocation invoke];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

#pragma mark - public

- (void)addAdapter:(MDRouterAdapter *)adapter {
    MDSYNC([super addAdapter:adapter];)
}

- (void)removeAdapter:(MDRouterAdapter *)adapter {
    MDSYNC([super removeAdapter:adapter];)
}

- (BOOL)addInvocation:(MDRouterInvocation *)invocation {
    __block BOOL success = NO;
    MDSYNC(success = [super addInvocation:invocation];)
    return success;
}

- (BOOL)removeInvocation:(MDRouterInvocation *)invocation {
    __block BOOL success = NO;
    MDSYNC(success = [super removeInvocation:invocation];)
    return success;
}

- (BOOL)removeInvocationWithTarget:(id)target action:(SEL)action baseURL:(NSURL *)baseURL {
    __block BOOL success = NO;
    MDSYNC(success = [super removeInvocationWithTarget:target action:action baseURL:baseURL];)
    return success;
}

- (void)removeProtocol:(Protocol *)protocol {
    MDSYNC([self _removeProtocol:protocol];)
}

- (void)addProtocol:(Protocol *)protocol {
    MDSYNC([self _addProtocol:protocol];)
}

- (void)async:(void (^)(MDRouterAdapter *router))block {
    [self _async:^{
        block(self);
    }];
}

@end

id MDRouterBoxValue(NSInvocation *invocation, NSUInteger index) {
    NSMethodSignature *signature = [invocation methodSignature];
    const char *type = [signature getArgumentTypeAtIndex:index];

    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        [invocation getArgument:&obj atIndex:index];
        if (obj) {
            if (@available(iOS 8, *)) CFRetain((__bridge void *)obj);
        }
    } else if (strcmp(type, @encode(void *)) == 0) {
        void *actual = NULL;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithPointer:actual];
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = CGPointZero;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithCGPoint:actual];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = CGSizeZero;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithCGSize:actual];
    } else if (strcmp(type, @encode(CGRect)) == 0) {
        CGRect actual = CGRectZero;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithCGRect:actual];
    } else if (strcmp(type, @encode(CGVector)) == 0) {
        CGVector actual = CGVectorMake(0, 0);
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithCGVector:actual];
    } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
        CGAffineTransform actual = CGAffineTransformIdentity;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithCGAffineTransform:actual];
    } else if (strcmp(type, @encode(UIOffset)) == 0) {
        UIOffset actual = UIOffsetZero;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithUIOffset:actual];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = UIEdgeInsetsZero;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithUIEdgeInsets:actual];
    } else if (strcmp(type, @encode(NSRange)) == 0) {
        NSRange actual = NSMakeRange(0, 0);
        [invocation getArgument:&actual atIndex:index];
        obj = [NSValue valueWithRange:actual];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithUnsignedShort:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = 0;
        [invocation getArgument:&actual atIndex:index];
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else {
        if (@available(iOS 11, *)) {
            if (strcmp(type, @encode(NSDirectionalEdgeInsets)) == 0) {
                NSDirectionalEdgeInsets actual = NSDirectionalEdgeInsetsZero;
                [invocation getArgument:&actual atIndex:index];
                obj = [NSValue valueWithDirectionalEdgeInsets:actual];
            }
        }
    }
    return obj;
}
