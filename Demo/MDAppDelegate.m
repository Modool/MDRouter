//
//  MDAppDelegate.m
//  Demo
//
//  Created by Jave on 2017/12/29.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <objc/runtime.h>
#import "MDAppDelegate.h"

@interface MDAppDelegate ()

@property (strong, nonatomic) MDRouter *router;

@end

@implementation MDAppDelegate

- (MDRouter *)router{
    if (!_router) {
        _router = [MDRouter router];
//        _router.validSchemes = [NSSet setWithObjects:@"router", @"http", @"https", @"method", nil];
//        _router.validHosts = [NSSet setWithObjects:@"www.github.com", @"github.com", @"modool", @"invoke", nil];

        MDRouterWebsiteAdapter *websiteAdapter = [MDRouterWebsiteAdapter adapterWithBlock:^id(NSURL *URL, NSDictionary *arguments, NSError *__autoreleasing *error) {
            return nil;
        }];
        [_router addAdapter:websiteAdapter];
        
        MDRouterUndirectionalAdapter *undirectionalAdapter = [MDRouterUndirectionalAdapter adapterWithBlock:^id(NSURL *URL, NSDictionary *arguments, NSError *__autoreleasing *error) {
            NSLog(@"undirectional url: %@", URL);
            return nil;
        }];
        
        [_router addAdapter:undirectionalAdapter];
        [_router redirectURLString:@"modool/test2" toURLString:@"router://www.github.com/modool/transition"];
        [_router redirectURLString:@"router://modool/test2" toURLString:@"router://www.github.com/modool/transition"];
        [_router redirectURLString:@"router://www.github.com/modool/test2" toURLString:@"router://www.github.com/modool/transition"];
//        [_router redirectURLString:@"Method://transit" toURLString:@"router://www.github.com/modool/transition"];
        [_router redirectURLString:@"invocation://live/transit" toURLString:@"router://www.github.com/modool/transition"];

        [_router addProtocol:@protocol(MDRouterViewControllerMethods)];
    }
    return _router;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
