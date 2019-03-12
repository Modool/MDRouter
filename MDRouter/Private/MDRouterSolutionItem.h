//
//  MDRouterSolutionItem.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSolution.h"

@interface MDRouterSolutionItem : NSObject

@property (nonatomic, copy, readonly) NSURL *baseURL;

@property (nonatomic, readonly) dispatch_queue_t queue;

@property (nonatomic, strong, readonly) id<MDRouterSolution> solution;

+ (instancetype)solutionItemWithBaseURL:(NSURL *)baseURL solution:(id<MDRouterSolution>)solution;
+ (instancetype)solutionItemWithBaseURL:(NSURL *)baseURL solution:(id<MDRouterSolution>)solution queue:(dispatch_queue_t)queue;

- (instancetype)initWithBaseURL:(NSURL *)baseURL solution:(id<MDRouterSolution>)solution;
- (instancetype)initWithBaseURL:(NSURL *)baseURL solution:(id<MDRouterSolution>)solution queue:(dispatch_queue_t)queue;

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error;

- (BOOL)validatBaseURL:(NSURL *)baseURL;

@end
