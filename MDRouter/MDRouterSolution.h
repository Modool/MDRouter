//
//  MDRouterViewSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDRouterSolution <NSObject>

- (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error;

@optional
// {name: necessary}
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *parameters;

@end

@protocol MDRouterAccessableSolution <NSObject>

@optional
- (id<MDRouterSolution>)verifyValidWithRouterArguments:(NSDictionary *)arguments;

@end

