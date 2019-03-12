//
//  MDRouterSolutionContainer.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSolutionItem.h"

@interface MDRouterSolutionContainer : NSObject

- (NSArray<MDRouterSolutionItem *> *)solutionItemsWithURL:(NSURL *)URL;
- (MDRouterSolutionItem *)solutionItemWithSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL;

- (BOOL)addSolution:(id<MDRouterSolution>)solution forBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue;
- (BOOL)removeSolution:(id<MDRouterSolution>)solution forBaseURL:(NSURL *)baseURL;

@end
