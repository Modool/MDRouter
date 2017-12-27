//
//  MDRouterUndirectionalAdapter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAdapter.h"

@interface MDRouterUndirectionalAdapter : MDRouterAdapter

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL NS_UNAVAILABLE;

- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_UNAVAILABLE;

+ (instancetype)adapterWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;
- (instancetype)initWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;

@end
