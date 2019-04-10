//
//  MDRouterInvocation.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <objc/runtime.h>
#import "MDRouterInvocation.h"

#import "NSError+MDRouter.h"
#import "MDRouterConstants.h"
#import "MDRouterAccessableInvocation.h"

@implementation MDRouterInvocation

+ (instancetype)invocationWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action {
    NSParameterAssert(baseURL && target && action);

    return [self invocationWithBaseURL:baseURL target:target action:action queue:dispatch_get_main_queue()];
}

+ (instancetype)invocationWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action queue:(dispatch_queue_t)queue {
    NSParameterAssert(baseURL && target && action && queue);

    return [[self alloc] initWithBaseURL:baseURL target:target action:action queue:queue];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action {
    return [self initWithBaseURL:baseURL target:target action:action queue:dispatch_get_main_queue()];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action queue:(dispatch_queue_t)queue {
    NSParameterAssert(baseURL && target && action && queue);

    if (self = [super init]) {
        _baseURL = baseURL;
        _target = target;
        _action = action;
        _queue = queue;
    }
    return self;
}

- (BOOL)validatBaseURL:(NSURL *)baseURL;{
    if ([baseURL scheme] && ![[baseURL scheme] isEqualToString:[[self baseURL] scheme]]) return NO;
    if ([baseURL host] && ![[baseURL host] isEqualToString:[[self baseURL] host]]) return NO;
    if ([baseURL port] && ![[baseURL port] isEqual:[[self baseURL] port]]) return NO;

    return [[baseURL path] isEqual:[[self baseURL] path]];
}

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)errorPtr {
    id (^completion)(NSError **error) = ^id(NSError **error){
        return [self _continueInvokeWithArguments:arguments error:error];
    };
    
    if ([_target conformsToProtocol:@protocol(MDRouterAccessableInvocation)]) {
        id<MDRouterAccessableInvocation> accessableInvocation = (id)_target;
        if ([accessableInvocation respondsToSelector:@selector(verifyValidWithRouterArguments:)]) {
            MDRouterInvocation *invocation = [accessableInvocation verifyValidWithRouterArguments:arguments];
            if (invocation) {
                [invocation invokeWithArguments:arguments error:errorPtr completion:^{
                    completion(NULL);
                }];
                return nil;
            }
        }
    }
    return completion(errorPtr);
}

- (id)_continueInvokeWithArguments:(NSDictionary *)arguments error:(NSError **)errorPtr {
    return [self invokeWithArguments:arguments error:errorPtr completion:nil];
}

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)errorPtr completion:(void (^)(void))completion {
    BOOL valid = [self _shouldInvokeWithArguments:arguments];
    if (!valid) {
        if (errorPtr) *errorPtr = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeLackOfNecessaryParameters userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to handle invocation: %@ because Lack of necessary arguments: %@", self, arguments]} underlyingError:*errorPtr];
        return nil;
    }
    
    if ([self conformsToProtocol:@protocol(MDRouterAsynchronizedInvocation)]) {
        id<MDRouterAsynchronizedInvocation> asynchronizedInvocation = (id)self;
        if (![asynchronizedInvocation respondsToSelector:@selector(invokeWithArguments:error:completion:)]) return nil;

        [asynchronizedInvocation invokeWithArguments:arguments error:errorPtr completion:^(MDRouterInvocation *completeInvocation) {
            if (completeInvocation) {
                [completeInvocation invokeWithArguments:arguments error:NULL completion:completion];
            } else if (completion) {
                completion();
            }
        }];
    } else {
        return [self _performWithArguments:arguments error:errorPtr];
    }
    return nil;
}

- (id)_performWithArguments:(NSDictionary *)arguments error:(NSError **)error {
    if (![_target respondsToSelector:_action]) return nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [_target performSelector:_action withObject:arguments withObject:(__bridge id)((void *)error)];
#pragma clang diagnostic pop
}

- (BOOL)_shouldInvokeWithArguments:(NSDictionary *)arguments {
    if (![self conformsToProtocol:@protocol(MDRouterAccessableInvocation)]) return YES;
    if (![self respondsToSelector:@selector(argumentConditions)]) return NO;

    id<MDRouterAccessableInvocation> accessableInvocation = (id)self;
    NSDictionary<NSString *, NSNumber *> *conditions = accessableInvocation.argumentConditions;
    NSArray<NSString *> *argumentNames = [arguments allKeys];

    for (NSString *key in [conditions allKeys]) {
        if ([argumentNames containsObject:key]) continue;
        if ([conditions[key] boolValue]) return NO;
    }

    return YES;
}

@end
