//
//  MDRootTableViewController.m
//  Demo
//
//  Created by Jave on 2017/12/29.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRootTableViewController.h"
#import "MDTransitViewController.h"
#import "MDAppDelegate.h"

@interface MDRootTableViewController ()

@end

@implementation MDRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MDRouterSimpleSolution *addSolution = [MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        NSNumber *a = arguments[@"a"];
        NSNumber *b = arguments[@"b"];
        
        return @([a doubleValue] + [b doubleValue]);
    }];
    
    [[MDSharedAppDelegate router] addSolution:addSolution baseURL:[NSURL URLWithString:@"router://www.github.com/Modool/add"]];
//    [[MDSharedAppDelegate router] addSolution:addSolution baseURL:[NSURL URLWithString:@"router://www.github.com/Modool/add"] queue:dispatch_queue_create("com.modool.concurrent.queue", DISPATCH_QUEUE_SERIAL)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch ([indexPath row]) {
        case 0:
        {
//            NSError *error = nil;
//            id output = nil;
//            BOOL success = [[MDSharedAppDelegate router] openURL:[NSURL URLWithString:@"router://www.github.com/Modool/add?a=1&b=3"] output:&output error:&error];
//            if (!success) {
//                NSLog(@"Failed to add value.");
//            } else {
//                NSLog(@"a + b = 1 + 3 = %@", output);
//            }

            [[MDSharedAppDelegate router] async:^(id<MDRouterAdapter> router) {
                NSError *error = nil;
                id output = nil;
                [router openURL:[NSURL URLWithString:@"router://www.github.com/Modool/add?a=1&b=3"] output:&output error:&error];
                NSLog(@"a + b = 1 + 3 = %@", output);
            }];
        }
            break;
        case 1:
        {
            NSError *error = nil;
            id output = nil;
            BOOL success = [[MDSharedAppDelegate router] openURL:[NSURL URLWithString:@"router://www.github.com/Modool/transition?push=1&animated=1"] output:&output error:&error];
            if (!success) {
                NSLog(@"Failed to transit view controller.");
            }
        }
            break;
        case 2:
        {
            NSError *error = nil;
            id output = nil;
#warning need check. fail case
            BOOL success = [[MDSharedAppDelegate router] openURL:[NSURL URLWithString:@"router://www.github.com/Modool/test2?push=1&animated=1"] output:&output error:&error];
            if (!success) {
                NSLog(@"Failed to route.");
            }
        }
        break;
            
        default:
            break;
    }
}

@end
