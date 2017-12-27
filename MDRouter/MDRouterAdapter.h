//
//  MDRouterAdapter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MDRouterSolution;

@protocol MDRouterAdapter

@property (nonatomic, copy, readonly) NSURL *baseURL;

- (void)addAdapter:(id<MDRouterAdapter>)adapter;
- (void)removeAdapter:(id<MDRouterAdapter>)adapter;

- (void)addSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL;
- (void)removeSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL;

- (BOOL)canOpenURL:(NSURL *)URL;

- (BOOL)openURL:(NSURL *)URL;
- (BOOL)openURL:(NSURL *)URL error:(NSError **)error;
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error;
- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;

- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error arguments:(NSString *)key, ...;
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error key:(NSString *)key arguments:(va_list)arguments;
@end

@interface MDRouterAdapter : NSObject<MDRouterAdapter>

@property (nonatomic, copy, readonly) NSString *version;

@property (nonatomic, copy, readonly) NSURL *baseURL;

@property (nonatomic, copy, readonly) NSArray<MDRouterAdapter> *adapters;

+ (instancetype)adapter;
+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL;

- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;

@end
