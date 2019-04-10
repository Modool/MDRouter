//
//  UIViewController+MDRouterInvocation.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "UIViewController+MDRouterInvocation.h"
#import "MDRouterConstants.h"

NSString * MDRouterInvocationPushKey = @"pushing";
NSString * MDRouterInvocationAnimatedKey = @"animated";

@implementation UIViewController (MDRouterInvocation)

+ (NSDictionary<NSString *,NSNumber *> *)argumentConditions{
    return @{MDRouterInvocationPushKey: @NO,
             MDRouterInvocationAnimatedKey: @NO};
}

+ (UIViewController *)viewControllerWithArguments:(NSDictionary *)arguments outputArguments:(NSDictionary **)outputArguments error:(NSError **)error {
    return [[self alloc] init];
}

+ (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)errorPtr {
    NSDictionary *outputArguments = arguments ? [arguments copy] : nil;
    UIViewController *viewController = [self viewControllerWithArguments:arguments outputArguments:&outputArguments error:errorPtr];
    
    if (!viewController) return nil;
    if (outputArguments) arguments = outputArguments;
    
    BOOL push = arguments[MDRouterInvocationPushKey] ? [arguments[MDRouterInvocationPushKey] boolValue] : YES;
    BOOL animated = arguments[MDRouterInvocationAnimatedKey] ? [arguments[MDRouterInvocationAnimatedKey] boolValue] : YES;
    if (push) {
        [self pushViewController:viewController animated:animated error:errorPtr];
    } else {
        [self presentViewController:viewController animated:animated error:errorPtr];
    }
    return nil;
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UINavigationController *navigationController = [rootViewController isKindOfClass:[UINavigationController class]] ? (id)rootViewController : [viewController navigationController];
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        [navigationController pushViewController:viewController animated:animated];
    } else {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeNoVisibleNavigationController userInfo:@{NSLocalizedDescriptionKey: @"root view controller isn't sub class of UINavigationController"}];
    }
}

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (rootViewController && ![rootViewController presentedViewController]) {
        [rootViewController presentViewController:viewController animated:animated completion:nil];
    } else if (rootViewController && [rootViewController presentedViewController]) {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodePresentedViewControllerExsit userInfo:@{NSLocalizedDescriptionKey: @"root view controller has presented a controller."}];
    } else {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeNoVisibleViewController userInfo:@{NSLocalizedDescriptionKey: @"root view controller has presented a controller."}];
    }
}

@end


