//
//  MDRouterUndirectionalAdapter.m
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterUndirectionalAdapter.h"
#import "MDRouterAdapter+Private.h"
#import "MDRouterConstants.h"

#import "NSError+MDRouter.h"

@implementation MDRouterUndirectionalAdapter

#pragma mark - private

- (BOOL)_validateURL:(NSURL *)URL{
    return YES;
}

- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(__autoreleasing id *)output error:(NSError *__autoreleasing *)error{
    if (error) {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeUnredirectURL userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to redirect URL: %@", URL]} underlyingError:*error];
    }
    return NO;
}

@end
