//
//  MDTransitViewController.m
//  Demo
//
//  Created by Jave on 2017/12/29.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDTransitViewController.h"

#import "MDAppDelegate.h"


@interface MDTransitViewController ()

@end

@implementation MDTransitViewController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"transition";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

MDRouterSolutionClassBind(MDTransitViewController, @"router://www.github.com/modool/transition")

