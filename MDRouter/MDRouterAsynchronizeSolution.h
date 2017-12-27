//
//  MDRouterSolutionPrivate.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolution.h"

@protocol MDRouterAsynchronizeSolution <MDRouterSolution>

- (void)asynchronizeInvokeWithCompletion:(void (^)(id<MDRouterSolution> solution))completion;

@end
