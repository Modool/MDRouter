//
//  NSError+MDRouter.h
//  MDRouter
//
//  Created by Jave on 2017/12/16.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MDRouter)

+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey, id> *)userInfo underlyingError:(NSError *)underlyingError;

@end
