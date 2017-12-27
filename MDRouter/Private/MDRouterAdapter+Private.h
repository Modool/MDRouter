//
//  MDRouterAdapter+Private.h
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterAdapter.h"

@class MDRouterSolutionContainer;
@interface MDRouterAdapter ()

@property (nonatomic, copy) NSURL *baseURL;

@property (nonatomic, strong) NSMutableArray<MDRouterAdapter> *mutableAdapters;

@property (nonatomic, strong) MDRouterSolutionContainer *solutionContainer;

@end
@interface MDRouterAdapter (Private)

- (BOOL)_validateURL:(NSURL *)URL;

- (BOOL)_handleSolutionWithURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;
- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;

- (NSDictionary *)_argumentsWithURL:(NSURL *)URL baseArguments:(NSDictionary *)baseArguments;

@end
