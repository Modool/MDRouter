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
extern NSString * MDRouterSolutionItemViewControllerKey;

@protocol MDRouterViewControllerSolution <MDRouterClassSolution>

+ (UIViewController *)viewControllerWithArguments:(NSDictionary *)arguments outputArguments:(NSDictionary **)outputArguments error:(NSError **)error;

@end

@protocol MDRouterViewControllerDisplaySolution <NSObject>

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error;
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error;

@end

/**
 Solution of view controller route.
 
 * push        1 or 0
 * animated    1 or 0
 */
@interface UIViewController (MDRouterSolution)<MDRouterViewControllerSolution, MDRouterViewControllerDisplaySolution>

@end

