//
//  MDRouterSimpleAdapter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAdapter.h"

@interface MDRouterSimpleAdapter : MDRouterAdapter

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL handler:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))handler;
- (instancetype)initWithBaseURL:(NSURL *)baseURL handler:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))handler;

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL return:(id)value;

@end
