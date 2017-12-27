//
//  MDRouterSampleSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolution.h"

@interface MDRouterSampleSolution : NSObject<MDRouterSolution>

+ (instancetype)solutionWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;
- (instancetype)initWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;

+ (instancetype)solutionWithTarget:(id)target action:(SEL)action;
- (instancetype)initWithTarget:(id)target action:(SEL)action;

@end
