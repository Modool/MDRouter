//
//  MDRouterSolutionContainer.m
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
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
        if ([item validatURL:URL]) {
            [solutions addObject:item];
        }
    }
    return solutions;
}

- (MDRouterSolutionItem *)solutionItemWithSolution:(id<MDRouterSolution>)solution URL:(NSURL *)URL;{
    for (MDRouterSolutionItem *item in [[self solutionItems] copy]) {
        if ([item solution] == solution && [item validatURL:URL]) {
            return item;
        }
    }
    return nil;
}

- (BOOL)addSolution:(id<MDRouterSolution>)solution forURL:(NSURL *)URL;{
    NSParameterAssert(solution && URL);
    NSParameterAssert(![self solutionItemWithSolution:solution URL:URL]);
    
    [[self solutionItems] addObject:[MDRouterSolutionItem solutionItemWithURL:URL solution:solution]];
    
    return YES;
}

- (BOOL)removeSolution:(id<MDRouterSolution>)solution forURL:(NSURL *)URL;{
    NSParameterAssert(solution && URL);
    
    MDRouterSolutionItem *item = [self solutionItemWithSolution:solution URL:URL];
    NSParameterAssert(item);
    
    [[self solutionItems] removeObject:item];
    
    return YES;
}

@end
