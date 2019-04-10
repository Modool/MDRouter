//
//  MDRouterUndirectionalAdapter.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterUndirectionalAdapter.h"
#import "MDRouterAdapter+Private.h"
#import "MDRouterConstants.h"

#import "NSError+MDRouter.h"

@implementation MDRouterUndirectionalAdapter

+ (instancetype)adapterWithBlock:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))block {
    NSParameterAssert(block);
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id (^)(NSURL *URL, NSDictionary *arguments, NSError **error))block {
    NSParameterAssert(block);
    if (self = [super initWithBaseURL:nil]) {
        _block = [block copy];
    }
    return self;
}

#pragma mark - private

- (BOOL)_containedURL:(NSURL *)URL {
    return NO;
}

- (BOOL)_validateURL:(NSURL *)URL {
    return YES;
}

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(__autoreleasing id *)output error:(NSError *__autoreleasing *)error {
    if (_block) {
        id result = _block(URL, arguments, error);
        if (output) *output = result;
        return YES;
    }
    
    if (error) {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeUnredirectURL userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to redirect URL: %@", URL]} underlyingError:*error];
    }
    return NO;
}

@end
