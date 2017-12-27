
//
//  MDRouterSampleSolution.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSampleSolution.h"

@interface MDRouterSampleSolution ()

@property (nonatomic, copy) id (^block)(NSDictionary *arguments, NSError **error);

@property (nonatomic, assign) id target;

@property (nonatomic, assign) SEL action;

@end

@implementation MDRouterSampleSolution

+ (instancetype)solutionWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;{
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(id (^)(NSDictionary *arguments, NSError **error))block;{
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

+ (instancetype)solutionWithTarget:(id)target action:(SEL)action;{
    return [[self alloc] solutionWithTarget:target action:action];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action;{
    if (self = [super init]) {
        self.target = target;
        self.action = action;
    }
    return self;
}

- (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error;{
    if ([self target] && [self action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [[self target] performSelector:[self action] withObject:arguments];
#pragma clang diagnostic pop
    } else if ([self block]) {
        return self.block(arguments, error);
    }
    return nil;
}

@end
