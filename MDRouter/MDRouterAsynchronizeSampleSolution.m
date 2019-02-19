//
//  MDRouterAsynchronizeSampleSolution.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAsynchronizeSampleSolution.h"
#import "MDRouterAsynchronizeSolution.h"

#import "NSError+MDRouter.h"
#import "MDRouterConstants.h"

@interface MDRouterAsynchronizeSampleSolution ()<MDRouterAsynchronizeSolution>

@property (nonatomic, copy) void (^block)(void (^)(id<MDRouterSolution> solution));

@end

@implementation MDRouterAsynchronizeSampleSolution

- (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError *__autoreleasing *)error {
    return nil;
}

+ (instancetype)solutionWithBlock:(void (^)(void (^)(id<MDRouterSolution> solution)))block {
    NSParameterAssert(block);
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(void (^)(void (^)(id<MDRouterSolution> solution)))block {
    NSParameterAssert(block);
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (BOOL)invokeAsynchronizedArguments:(NSDictionary *)arguments error:(NSError **)error completion:(void (^)(id<MDRouterSolution> solution))completion {
    if ([self block]) self.block(completion);
    else {
        if (error) *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeAsynchronizedHandleFailed userInfo:@{NSLocalizedDescriptionKey: @"Failed to invoke asynchronized solution because of non block handler"} underlyingError:*error];
        return NO;
    }
    return YES;
}

@end
