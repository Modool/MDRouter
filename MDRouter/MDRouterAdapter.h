//
//  MDRouterAdapter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MDRouterSolution;

// Protocol for adapter
@protocol MDRouterAdapter

// The base URL of whole URL.
@property (nonatomic, copy, readonly) NSURL *baseURL;

/**
 Add sub adapter.

 @param adapter instance of MDRouterAdapter protocol.
 */
- (void)addAdapter:(id<MDRouterAdapter>)adapter;

/**
 Remove sub adapter.
 
 @param adapter instance of MDRouterAdapter protocol.
 */
- (void)removeAdapter:(id<MDRouterAdapter>)adapter;

/**
 Add solution.

 @param solution instance of MDRouterSolution protocol.
 @param baseURL base URL matched by adatpers.
 */
- (void)addSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL;

/**
 Remove solution.
 
 @param solution instance of MDRouterSolution protocol.
 @param baseURL base URL matched by adatpers.
 */
- (void)removeSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL;

/**
 To verify URL whether any adapter or solution is matched.

 @param URL URL to be verified.
 @return YES if any adapter of solution is matched, or NO.
 */
- (BOOL)canOpenURL:(NSURL *)URL;

/**
 Open URL to route an result if any adapter or solution is matched.

 @param URL whole URL with prameters to route
 @return YES if any adapter or solution is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL;

/**
 Open URL to route an result if any adapter or solution is matched.
 
 @param URL whole URL with prameters to route.
 @param error output error if open URL failed.
 @return YES if any adapter or solution is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL error:(NSError **)error;

/**
 Open URL to route an result if any adapter or solution is matched.
 
 @param URL whole URL with prameters to route.
 @param output output userinfo if open URL successfully.
 @param error output error if open URL failed.
 @return YES if any adapter or solution is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error;

/**
 Open URL to route an result if any adapter or solution is matched.
 
 @param URL whole URL with prameters to route.
 @param arguments input arguments for adapter or solution.
 @param output output userinfo if open URL successfully.
 @param error output error if open URL failed.
 @return YES if any adapter or solution is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;

/**
 Open URL with omit arguments to route an result if any adapter or solution is matched.
 
 @param URL whole URL with prameters to route.
 @param output output userinfo if open URL successfully.
 @param error output error if open URL failed.
 @param key first argument for adapter or solution.
 @return YES if any adapter or solution is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error arguments:(NSString *)key, ...;

/**
 Open URL with arguments list to route an result if any adapter or solution is matched.
 
 @param URL whole URL with prameters to route.
 @param output output userinfo if open URL successfully.
 @param error output error if open URL failed.
 @param key first item for argument list.
 @param arguments arguments list for adapter or solution.
 @return YES if any adapter or solution is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error key:(NSString *)key arguments:(va_list)arguments;
@end

// Default class for MDRouterAdapter protocol.
@interface MDRouterAdapter : NSObject<MDRouterAdapter>

// Sub adapters with the same base URL.
@property (nonatomic, copy, readonly) NSArray<MDRouterAdapter> *adapters;

/**
 Default instance of MDRouterAdapter.

 @return instance of MDRouterAdapter
 */
+ (instancetype)adapter;

/**
 Instance of MDRouterAdapter with base URL.
 
 @param baseURL base URL.
 @return instance of MDRouterAdapter
 */
+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL;

/**
 Initilization of MDRouterAdapter with base URL.
 
 @param baseURL base URL.
 @return instance of MDRouterAdapter
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;

@end
