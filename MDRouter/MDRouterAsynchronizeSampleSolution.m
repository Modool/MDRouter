//
//  MDRouterAsynchronizeSampleSolution.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterAsynchronizeSampleSolution.h"
#import "MDRouterAsynchronizeSolution.h"

@interface MDRouterAsynchronizeSampleSolution ()<MDRouterAsynchronizeSolution>

@property (nonatomic, copy) void (^block)(void (^)(id<MDRouterSolution> solution));

@end

@implementation MDRouterAsynchronizeSampleSolution

- (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError *__autoreleasing *)error {
    return nil;
}

+ (instancetype)solutionWithBlock:(void (^)(void (^)(id<MDRouterSolution> solution)))block;{
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(void (^)(void (^)(id<MDRouterSolution> solution)))block;{
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)asynchronizeInvokeWithCompletion:(void (^)(id<MDRouterSolution> solution))completion;{
    if ([self block]) {
        self.block(completion);
    }
}

@end
