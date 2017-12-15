//
//  MDRouterWebsiteAdapter.m
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterWebsiteAdapter.h"
#import "MDRouterAdapter+Private.h"

NSString * const MDRouterWebsiteAdapterPredicateString = @"^(http|https)://*$";

@implementation MDRouterWebsiteAdapter

+ (instancetype)adapter;{
    return [self adapterWithBaseURL:nil];
}

#pragma mark - private

- (BOOL)_validateURL:(NSURL *)URL{
    return [@[@"http", @"https"] containsObject:[URL scheme]];
}

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(__autoreleasing id *)output error:(NSError *__autoreleasing *)error{
    return NO;
}

@end
