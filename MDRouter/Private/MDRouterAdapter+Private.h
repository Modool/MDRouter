//
//  MDRouterAdapter+Private.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAdapter.h"

@class MDRouterInvocation;
@interface MDRouterAdapter () {
    @protected
    NSMutableArray<MDRouterAdapter *> *_adapters;
    NSMutableArray<MDRouterInvocation *> *_invocations;

    NSMutableDictionary<NSURL *, NSURL *> *_forwardURLs;

    NSRecursiveLock *_lock;
}

- (MDRouterAdapter *)_adapterWithBaseURL:(NSURL *)baseURL;

- (BOOL)_handleInvocationWithURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel;
- (BOOL)_handleURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;

- (NSDictionary *)_argumentsWithURL:(NSURL *)URL baseArguments:(NSDictionary *)baseArguments;

- (void)_addAdapter:(MDRouterAdapter *)adapter;
- (void)_removeAdapter:(MDRouterAdapter *)adapter;

- (BOOL)_containedURL:(NSURL *)URL;
- (BOOL)_validateURL:(NSURL *)URL;
- (BOOL)_canOpenURL:(NSURL *)URL;
- (BOOL)_openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel;

- (NSArray<MDRouterInvocation *> *)_invocationsWithURL:(NSURL *)URL;
- (MDRouterInvocation *)_invocationWithTarget:(id)target action:(SEL)action baseURL:(NSURL *)baseURL;

- (BOOL)_addInvocation:(MDRouterInvocation *)invocation;
- (BOOL)_removeInvocation:(MDRouterInvocation *)invocation;

@end
