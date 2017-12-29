//
//  MDAppDelegate.h
//  Demo
//
//  Created by Jave on 2017/12/29.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MDRouter/MDRouter.h>

@interface MDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) MDRouterSet *router;

@end

#define MDSharedAppDelegate                   (MDAppDelegate *)[[UIApplication sharedApplication] delegate]

#define MDRouterSolutionBind(solution, baseURLString)   [[MDSharedAppDelegate router] addSolution:solution baseURL:[NSURL URLWithString:baseURLString]]

#define MDRouterSolutionClassBind(cls, baseURLString)   @implementation cls (MDRouterSolution)                      \
                                                            + (void)load{                                           \
                                                                static dispatch_once_t onceToken;                   \
                                                                dispatch_once(&onceToken, ^{                        \
                                                                    dispatch_async(dispatch_get_main_queue(), ^{    \
                                                                        MDRouterSolutionBind((id)[cls class], baseURLString); \
                                                                    });                                             \
                                                                });                                                 \
                                                            }                                                       \
                                                        @end

