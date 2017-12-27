//
//  MDRouterSolutionItem.h
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolution.h"

@interface MDRouterSolutionItem : NSObject

@property (nonatomic, copy, readonly) NSURL *baseURL;

@property (nonatomic, strong, readonly) id<MDRouterSolution> solution;

+ (instancetype)solutionItemWithBaseURL:(NSURL *)baseURL solution:(id<MDRouterSolution>)solution;
- (instancetype)initWithBaseURL:(NSURL *)baseURL solution:(id<MDRouterSolution>)solution;

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error;

- (BOOL)validatBaseURL:(NSURL *)baseURL;

@end
