//
//  MDRouterBlockInvocation.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterInvocation.h"

typedef id (^MDRouterBlockInvocationBlock)(NSDictionary *arguments, NSError **error);
typedef id (^MDRouterAsynchronizeBlockInvocationBlock)(NSDictionary *arguments, NSError **error, void (^completion)(MDRouterInvocation *invocation));

@interface MDRouterBlockInvocation : MDRouterInvocation {
    id _block;
}

/**
 Instance of MDRouterBlockInvocation with block handler.
 
 @param block a block to be route.
 @return instance of MDRouterBlockInvocation
 */
+ (instancetype)invocationWithBaseURL:(NSURL *)baseURL block:(id)block;
+ (instancetype)invocationWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue block:(id)block;

/**
 Initialization of MDRouterBlockInvocation with block handler.
 
 @param block a block to be route.
 @return instance of MDRouterBlockInvocation
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL block:(id)block;
- (instancetype)initWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue block:(id)block;

@end

@interface MDRouterAsynchronizeBlockInvocation : MDRouterBlockInvocation <MDRouterAsynchronizedInvocation>
@end
