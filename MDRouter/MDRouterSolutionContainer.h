//
//  MDRouterSolutionContainer.h
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolutionItem.h"

@interface MDRouterSolutionContainer : NSObject

- (NSArray<MDRouterSolutionItem *> *)solutionItemsWithURL:(NSURL *)URL;
- (MDRouterSolutionItem *)solutionItemWithSolution:(id<MDRouterSolution>)solution URL:(NSURL *)URL;

- (BOOL)addSolution:(id<MDRouterSolution>)solution forURL:(NSURL *)URL;
- (BOOL)removeSolution:(id<MDRouterSolution>)solution forURL:(NSURL *)URL;

@end
