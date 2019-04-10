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

@property (strong, nonatomic, readonly) MDRouter *router;

@end

@protocol MDRouterViewControllerMethods <NSObject>

MDRouterNonArgumentMethodAs(transit, - (id)transitViewController);
//MDRouterMethodAs(transit, pushing, - (id)transitWithPushing:(BOOL)pushing animated:(BOOL)animated);
MDRouterMethodHostAs(live, transit, pushing, - (id)transitWithPushing:(BOOL)pushing animated:(BOOL)animated);

@end

#define MDSharedAppDelegate                   (MDAppDelegate *)[[UIApplication sharedApplication] delegate]
