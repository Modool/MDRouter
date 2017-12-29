//
//  MDRouterAsynchronizeSampleSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolution.h"

@interface MDRouterAsynchronizeSampleSolution : NSObject<MDRouterSolution>

/**
 Instance of MDRouterAsynchronizeSampleSolution with block handler.
 
 @param block a block to be route.
 @return instance of MDRouterAsynchronizeSampleSolution
 */
+ (instancetype)solutionWithBlock:(void (^)(void (^completion)(id<MDRouterSolution> solution)))block;

/**
 Initialization of MDRouterAsynchronizeSampleSolution with block handler.
 
 @param block a block to be route.
 @return instance of MDRouterSimpleSolution
 */
- (instancetype)initWithBlock:(void (^)(void (^completion)(id<MDRouterSolution> solution)))block;

@end
