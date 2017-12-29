//
//  UIViewController+MDRouterSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRouterClassSolution.h"

extern NSString * MDRouterSolutionItemPushKey;
extern NSString * MDRouterSolutionItemAnimatedKey;

// To support to route transition for view controller.
@protocol MDRouterViewControllerSolution <MDRouterClassSolution>

/**
 Provide a view controller with arguments when URL matched a solution of view controller.

 @param arguments arguments for view controller.
 @param outputArguments output arguments, maybe replaced, default is arguments.
 @param error output error if failed to transit a view controller.
 @return instance of view controller.
 */
+ (UIViewController *)viewControllerWithArguments:(NSDictionary *)arguments outputArguments:(NSDictionary **)outputArguments error:(NSError **)error;

@end

@protocol MDRouterViewControllerDisplaySolution <NSObject>

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
 Default solution of view controller route.
 
 * push        1 or 0
 * animated    1 or 0
 */
@interface UIViewController (MDRouterSolution)<MDRouterViewControllerSolution, MDRouterViewControllerDisplaySolution>

@end

