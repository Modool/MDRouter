//
//  MDRouterSimpleAdapter.m
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSimpleAdapter.h"
#import "MDRouterAdapter+Private.h"

#import "MDRouterConstants.h"
#import "NSError+MDRouter.h"

@interface MDRouterSimpleAdapter ()

@property (nonatomic, copy) id (^handler)(NSURL *URL, NSDictionary *arguments, NSError **error);

@end

@implementation MDRouterSimpleAdapter

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL handler:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))handler;{
    return [[self alloc] initWithBaseURL:baseURL handler:handler];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL handler:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))handler;{
    if (self = [super initWithBaseURL:baseURL]) {
        self.handler = handler;
    }
    return self;
}

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL return:(id)value;{
    return [self adapterWithBaseURL:baseURL handler:^id(NSURL *URL, NSDictionary *arguments, NSError **error) {
        return value;
    }];
}

#pragma mark - private

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(__autoreleasing id *)output error:(NSError *__autoreleasing *)error{
    if (![self handler]) {
        if (error) {
            *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeNoHandler userInfo:@{NSLocalizedDescriptionKey: @"无效的跳转链接"} underlyingError:*error];
        }
    } else {
        id result = self.handler(URL, arguments, error);
        if (output) {
            *output = result;
        }
        return YES;
    }
    return NO;
}

@end
