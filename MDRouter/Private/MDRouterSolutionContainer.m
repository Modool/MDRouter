//
//  MDRouterSolutionContainer.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSolutionContainer.h"

@interface MDRouterSolutionContainer ()

@property (nonatomic, strong) NSMutableArray<MDRouterSolutionItem *> *solutionItems;

@end

@implementation MDRouterSolutionContainer

- (instancetype)init{
    if (self = [super init]) {
        self.solutionItems = [NSMutableArray new];
    }
    return self;
}

- (NSArray<MDRouterSolutionItem *> *)solutionItemsWithURL:(NSURL *)URL;{
    NSMutableArray<MDRouterSolutionItem *> *solutions = [NSMutableArray new];
    for (MDRouterSolutionItem *item in [[self solutionItems] copy]) {
        if ([item validatBaseURL:URL]) {
            [solutions addObject:item];
        }
    }
    return solutions;
}

- (MDRouterSolutionItem *)solutionItemWithSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL;{
    for (MDRouterSolutionItem *item in [[self solutionItems] copy]) {
        if ([item solution] == solution && [item validatBaseURL:baseURL]) {
            return item;
        }
    }
    return nil;
}

- (BOOL)addSolution:(id<MDRouterSolution>)solution forBaseURL:(NSURL *)baseURL;{
    NSParameterAssert(solution && baseURL);
    NSParameterAssert(![self solutionItemWithSolution:solution baseURL:baseURL]);
    
    [[self solutionItems] addObject:[MDRouterSolutionItem solutionItemWithBaseURL:baseURL solution:solution]];
    
    return YES;
}

- (BOOL)removeSolution:(id<MDRouterSolution>)solution forBaseURL:(NSURL *)baseURL;{
    NSParameterAssert(solution && baseURL);
    
    MDRouterSolutionItem *item = [self solutionItemWithSolution:solution baseURL:baseURL];

    if (item) [[self solutionItems] removeObject:item];
    
    return item != nil;
}

@end
