//
//  MDRouterSimpleAdapter.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSimpleAdapter.h"
#import "MDRouterAdapter+Private.h"

#import "MDRouterConstants.h"
#import "NSError+MDRouter.h"

@interface MDRouterSimpleAdapter ()

@property (nonatomic, copy) id (^block)(NSURL *URL, NSDictionary *arguments, NSError **error);

@end

@implementation MDRouterSimpleAdapter

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL block:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))block;{
    return [[self alloc] initWithBaseURL:baseURL block:block];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL block:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))block;{
    if (self = [super initWithBaseURL:baseURL]) {
        self.block = block;
    }
    return self;
}

+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL return:(id)value;{
    return [self adapterWithBaseURL:baseURL block:^id(NSURL *URL, NSDictionary *arguments, NSError **error) {
        return value;
    }];
}

#pragma mark - private

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(__autoreleasing id *)output error:(NSError *__autoreleasing *)error{
    if (![self block]) {
        if (error) {
            *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeNoHandler userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to redirect invalid URL: %@", URL]} underlyingError:*error];
        }
    } else {
        id result = self.block(URL, arguments, error);
        if (output) {
            *output = result;
        }
        return YES;
    }
    return NO;
}

@end
