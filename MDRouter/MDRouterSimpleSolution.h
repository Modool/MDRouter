//
//  MDRouterSimpleSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSolution.h"

@interface MDRouterSimpleSolution : NSObject<MDRouterSolution>

/**
 Instance of MDRouterSimpleSolution with block handler.
 
 @param block a block to be route.
 @return instance of MDRouterSimpleSolution
 */
+ (instancetype)solutionWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;

/**
 Initialization of MDRouterSimpleSolution with block handler.
 
 @param block a block to be route.
 @return instance of MDRouterSimpleSolution
 */
- (instancetype)initWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;

/**
 Instance of MDRouterSimpleSolution with target and action.
 
 @param target target instance to call.
 @param action action invoked of target instance.
 @return instance of MDRouterSimpleSolution
 */
+ (instancetype)solutionWithTarget:(id)target action:(SEL)action;

/**
 Initialization of MDRouterSimpleSolution with target and action.
 
 @param target target instance to call.
 @param action action invoked of target instance.
 @return instance of MDRouterSimpleSolution
 */
- (instancetype)initWithTarget:(id)target action:(SEL)action;

@end
