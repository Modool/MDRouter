//
//  MDRouter.m
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouter.h"
#import "MDRouterAdapter+Private.h"
#import "MDRouterConstants.h"

NSString * const MDRouterErrorDomain    = @"com.bilibili.link.router.error.domain";

@interface MDRouter ()

@property (nonatomic, copy) NSString *scheme;

@property (nonatomic, copy) NSString *host;

@property (nonatomic, copy) NSString *port;

@end

@implementation MDRouter

#pragma mark - private

- (BOOL)_validateURL:(NSURL *)URL{
    return YES;
}

#pragma mark - public

- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;{
    NSParameterAssert(URL);

    arguments = [self _argumentsWithURL:URL baseArguments:arguments];
    
    BOOL state = [super openURL:URL arguments:arguments output:output error:error];
    if (!state && error) {
        NSMutableDictionary *userInfo = [*error ? @{NSUnderlyingErrorKey: *error} : @{} mutableCopy];
        userInfo[NSLocalizedDescriptionKey] = @"无效的跳转链接";
        
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeInvalidURL userInfo:userInfo];
    }
    return state;
}

@end
