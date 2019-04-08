//
//  MDRouterAdapter+Private.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAdapter.h"

@class MDRouterSolutionContainer;
@interface MDRouterAdapter () {
    NSMutableArray<id<MDRouterAdapter>> *_mutableAdapters;

    MDRouterSolutionContainer *_solutionContainer;
}

- (BOOL)_validateURL:(NSURL *)URL;

- (BOOL)_handleSolutionWithURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel;
- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;

- (NSDictionary *)_argumentsWithURL:(NSURL *)URL baseArguments:(NSDictionary *)baseArguments;

@end
