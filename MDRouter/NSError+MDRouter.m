//
//  NSError+MDRouter.m
//  MDRouter
//
//  Created by Jave on 2017/12/16.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "NSError+MDRouter.h"

@implementation NSError (MDRouter)

+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey, id> *)userInfo underlyingError:(NSError *)underlyingError;{
    NSMutableDictionary *mutableUserInfo = [userInfo ?: @{} mutableCopy];
    if (underlyingError) {
        mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    }
    return [NSError errorWithDomain:domain code:code userInfo:mutableUserInfo];
}

@end

