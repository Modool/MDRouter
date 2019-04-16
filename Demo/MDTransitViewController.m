//
//  MDTransitViewController.m
//  Demo
//
//  Created by Jave on 2017/12/29.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDTransitViewController.h"

#import "MDAppDelegate.h"

MDRouterTargetBindViewController(MDTransitViewController, @"router://www.github.com/modool/transition")

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

//    MDRouterBinder MDRouterBinder_bind_MDTransitViewController_invokeWithArguments_error:<#(MDRouter *)#>
}

@end
