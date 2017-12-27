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

@interface MDRouterUndirectionalAdapter ()

@property (nonatomic, copy) id (^block)(NSDictionary *arguments, NSError **error);

@end

@implementation MDRouterUndirectionalAdapter

+ (instancetype)adapterWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;{
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;{
    if (self = [super initWithBaseURL:nil]) {
        self.block = block;
    }
    return self;
}

#pragma mark - private

- (BOOL)_validateURL:(NSURL *)URL{
    return YES;
}

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(__autoreleasing id *)output error:(NSError *__autoreleasing *)error{
    if ([self block]) {
        id result = self.block(arguments, error);
        if (output) *output = result;
        return YES;
    }
    
    if (error) {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeUnredirectURL userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to redirect URL: %@", URL]} underlyingError:*error];
    }
    return NO;
}

@end
