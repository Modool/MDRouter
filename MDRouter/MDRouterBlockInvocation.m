//
//  MDRouterBlockInvocation.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterBlockInvocation.h"
#import "NSError+MDRouter.h"
#import "MDRouterConstants.h"

extern NSString * const MDRouterErrorDomain;

@implementation MDRouterBlockInvocation

+ (instancetype)invocationWithBaseURL:(NSURL *)baseURL block:(id)block {
    return [self invocationWithBaseURL:baseURL queue:dispatch_get_main_queue() block:block];
}
+ (instancetype)invocationWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue block:(id)block {
    NSParameterAssert(baseURL && queue && block);
    return [[self alloc] initWithBaseURL:baseURL queue:queue block:block];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL block:(id)block {
    return [self initWithBaseURL:baseURL queue:dispatch_get_main_queue() block:block];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue block:(id)block {
    NSParameterAssert(baseURL && queue && block);
    if (self = [super initWithBaseURL:baseURL target:self action:@selector(invokeWithArguments:error:) queue:queue]) {
        _block = [block copy];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action queue:(dispatch_queue_t)queue {
    return nil;
}

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error {
    MDRouterBlockInvocationBlock block = _block;

    return block ? block(arguments, error) : nil;
}

@end

@implementation MDRouterAsynchronizeBlockInvocation

- (instancetype)initWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue block:(id)block {
    NSParameterAssert(block);
    if (self = [super initWithBaseURL:baseURL target:self action:@selector(invokeWithArguments:error:completion:) queue:queue]) {
        _block = block;
    }
    return self;
}

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error completion:(void (^)(MDRouterInvocation *invocation))completion {
    MDRouterAsynchronizeBlockInvocationBlock block = _block;

    if (block) return block(arguments, error, completion);
    else {
        if (error) *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeAsynchronizedHandleFailed userInfo:@{NSLocalizedDescriptionKey: @"Failed to invoke asynchronized invocation because of non block handler"} underlyingError:*error];
    }
    return nil;
}

@end
