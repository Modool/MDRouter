//
//  MDRouterClassSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSolution.h"

@protocol MDRouterClassSolution <MDRouterSolution>

+ (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error;

@optional

@property (nonatomic, strong, class, readonly) NSDictionary<NSString *, NSNumber *> *parameters;

// {name: necessary}
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *parameters NS_UNAVAILABLE;

- (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error NS_UNAVAILABLE;

@end
