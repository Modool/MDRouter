//
//  UIViewController+MDRouterInvocation.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRouterAccessableInvocation.h"

extern NSString * MDRouterInvocationPushKey;
extern NSString * MDRouterInvocationAnimatedKey;

@protocol MDRouterViewControllerDisplayInvocation <NSObject>

/**
 Push a view controller from router.

 @param viewController instance of view controller.
 @param animated optional animation
 @param error output error
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error;

/**
 Present a view controller from router.
 
 @param viewController instance of view controller.
 @param animated optional animation
 @param error output error
 */
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error;

@end

/**
 Default invocation of view controller route.
 
 * pushing     1 or 0
 * animated    1 or 0
 */
@interface UIViewController (MDRouterInvocation)<MDRouterAccessableClassInvocation, MDRouterViewControllerDisplayInvocation>

@end

