//
//  MDRouterUndirectionalAdapter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSimpleAdapter.h"

@interface MDRouterUndirectionalAdapter : MDRouterAdapter

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL NS_UNAVAILABLE;
- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_UNAVAILABLE;

/**
 Instance of MDRouterUndirectionalAdapter with block handler.

 @param block a block to route if none adapter or solution is matched.
 @return instance of MDRouterUndirectionalAdapter
 */
+ (instancetype)adapterWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;

/**
 Initialization of MDRouterUndirectionalAdapter with block handler.
 
 @param block a block to route if none adapter or solution is matched.
 @return instance of MDRouterUndirectionalAdapter
 */
- (instancetype)initWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;

@end
