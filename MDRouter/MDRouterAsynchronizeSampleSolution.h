//
//  MDRouterAsynchronizeSampleSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolution.h"

@interface MDRouterAsynchronizeSampleSolution : NSObject<MDRouterSolution>

+ (instancetype)solutionWithBlock:(void (^)(void (^completion)(id<MDRouterSolution> solution)))block;
- (instancetype)initWithBlock:(void (^)(void (^completion)(id<MDRouterSolution> solution)))block;

@end
