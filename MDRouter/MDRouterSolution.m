//
//  MDRouterSolution.m
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolution.h"
#import "MDRouterConstants.h"

@interface MDRouterInstanceSolution ()

@property (nonatomic, copy) void (^block)(NSDictionary *arguments, NSError **error);

@property (nonatomic, assign) id target;

@property (nonatomic, assign) SEL action;

@end

@implementation MDRouterInstanceSolution

+ (id)solutionWithRouterArguments:(NSDictionary *)arguments outputArguments:(NSDictionary **)outputArguments error:(NSError **)error;{
    return nil;
}

- (NSURL *)URL{
    return nil;
}

- (NSDictionary<NSString *,NSNumber *> *)parameters {
    return nil;
}

- (BOOL)synchronize{
    return YES;
}

+ (instancetype)solutionWithBlock:(void (^)(NSDictionary *arguments, NSError **error))block;{
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(void (^)(NSDictionary *arguments, NSError **error))block;{
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

+ (instancetype)solutionWithTarget:(id)target action:(SEL)action;{
    return [[self alloc] initWithTarget:target action:action];
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
        self.block(arguments, error);
    }
    return nil;
}

@end

@interface MDRouterInstanceAsynchronizeSolution ()

@property (nonatomic, copy) void (^block)(void (^)(id<MDRouterInstanceSolution> solution));

@end

@implementation MDRouterInstanceAsynchronizeSolution

+ (id)solutionWithRouterArguments:(NSDictionary *)arguments outputArguments:(NSDictionary **)outputArguments error:(NSError **)error;{
    return nil;
}

- (NSURL *)URL{
    return nil;
}

- (NSDictionary<NSString *,NSNumber *> *)parameters {
    return nil;
}

- (BOOL)synchronize{
    return NO;
}

+ (instancetype)solutionWithBlock:(void (^)(void (^)(id<MDRouterInstanceSolution> solution)))block;{
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(void (^)(void (^)(id<MDRouterInstanceSolution> solution)))block;{
    if (self = [super init]) {
        self.block = block;
    }
    return self;
}

- (void)asynchronizeInvokeWithCompletion:(void (^)(id<MDRouterInstanceSolution> solution))completion;{
    if ([self block]) {
        self.block(completion);
    }
}

@end

NSString * MDRouterSolutionItemPushKey = @"push";
NSString * MDRouterSolutionItemAnimatedKey = @"animated";
NSString * MDRouterSolutionItemViewControllerKey = @"vc";

@implementation UIViewController (MDRouterSolution)

+ (NSURL *)URL{
    return nil;
}

+ (NSDictionary<NSString *,NSNumber *> *)parameters{
    return nil;
}

+ (id)solutionWithRouterArguments:(NSDictionary *)arguments outputArguments:(NSDictionary **)outputArguments error:(NSError **)error;{
    return nil;
}

+ (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error;{
    NSDictionary *replacedArguments = nil;
    UIViewController *viewController = [self solutionWithRouterArguments:arguments outputArguments:&replacedArguments error:error];
    
    if (!viewController) return nil;
    if (replacedArguments) arguments = replacedArguments;
    
    BOOL push = arguments[MDRouterSolutionItemPushKey] ? [arguments[MDRouterSolutionItemPushKey] boolValue] : YES;
    BOOL animated = arguments[MDRouterSolutionItemAnimatedKey] ? [arguments[MDRouterSolutionItemAnimatedKey] boolValue] : YES;
    if (push) {
        [self pushViewController:viewController animated:animated error:error];
    } else {
        [self presentViewController:viewController animated:animated error:error];
    }
    return nil;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error;{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UINavigationController *navigationController = [rootViewController isKindOfClass:[UINavigationController class]] ? (id)rootViewController : [viewController navigationController];
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        [navigationController pushViewController:viewController animated:animated];
    } else {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeHandleFailed userInfo:@{NSLocalizedDescriptionKey: @"root view controller isn't sub class of UINavigationController"}];
    }
}

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error;{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (![rootViewController presentedViewController]) {
        [rootViewController presentViewController:viewController animated:animated completion:nil];
    } else {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeHandleFailed userInfo:@{NSLocalizedDescriptionKey: @"root view controller has presented a controller."}];
    }
}

@end

