//
//  MDRouterWebsiteAdapter.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterWebsiteAdapter.h"
#import "MDRouterAdapter+Private.h"

@interface MDRouterWebsiteAdapter ()

@property (nonatomic, copy) id (^block)(NSURL *URL, NSDictionary *arguments, NSError **error);

@end

@implementation MDRouterWebsiteAdapter

+ (instancetype)adapterWithBlock:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))block {
    NSParameterAssert(block);
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))block {
    NSParameterAssert(block);
    if (self = [super initWithBaseURL:nil]) {
        self.block = block;
    }
    return self;
}

#pragma mark - private

- (BOOL)_validateURL:(NSURL *)URL {
    return [@[@"http", @"https"] containsObject:[URL scheme]];
}

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(__autoreleasing id *)output error:(NSError *__autoreleasing *)error {
    if ([self block]) {
        id result = self.block(URL, arguments, error);
        if (output) *output = result;
        
        return YES;
    }
    return NO;
}

@end
