//
//  MDRouterSolutionItem.h
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolution.h"

@interface MDRouterSolutionItem : NSObject

@property (nonatomic, copy, readonly) NSURL *URL;

@property (nonatomic, strong, readonly) id<MDRouterSolution> solution;

+ (instancetype)solutionItemWithURL:(NSURL *)URL solution:(id<MDRouterSolution>)solution;
- (instancetype)initWithURL:(NSURL *)URL solution:(id<MDRouterSolution>)solution;

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error;

- (BOOL)validatURL:(NSURL *)URL;

@end
