//
//  MDRouterWebsiteAdapter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAdapter.h"

@interface MDRouterWebsiteAdapter : MDRouterAdapter

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL NS_UNAVAILABLE;
- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_UNAVAILABLE;

/**
 Instance of MDRouterWebsiteAdapter with block handler.
 
 @param block a block to route if scheme of any adapter or solution is http or https.
 @return instance of MDRouterWebsiteAdapter
 */
+ (instancetype)adapterWithBlock:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))block;

/**
 Initialization of MDRouterWebsiteAdapter with block handler.
 
 @param block a block to route if scheme of any adapter or solution is http or https.
 @return instance of MDRouterWebsiteAdapter
 */
- (instancetype)initWithBlock:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))block;

@end
