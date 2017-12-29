//
//  MDRouterSimpleAdapter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAdapter.h"

@interface MDRouterSimpleAdapter : MDRouterAdapter

/**
 Instance of MDRouterSimpleAdapter with base URL and block handler.
 
 @param baseURL base URL.
 @param handler a block to be route.
 @return instance of MDRouterSimpleAdapter
 */
+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL handler:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))handler;

/**
 Initialization of MDRouterSimpleAdapter with base URL and block handler.
 
 @param baseURL base URL.
 @param handler a block to be route.
 @return instance of MDRouterSimpleAdapter
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL handler:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))handler;

/**
 Instance of MDRouterSimpleAdapter with base URL and default returned value.
 
 @param baseURL base URL.
 @param value a returned value to be route.
 @return instance of MDRouterSimpleAdapter
 */
+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL return:(id)value;

@end
