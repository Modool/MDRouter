//
//  MDRouterAdapter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDRouterInvocation;
@interface MDRouterAdapter : NSObject

// The base URL of whole URL.
@property (nonatomic, copy, readonly) NSURL *baseURL;

// Sub adapters with the same base URL.
@property (nonatomic, copy, readonly) NSArray<MDRouterAdapter *> *adapters;

/**
 Add sub adapter.

 @param adapter instance of MDRouterAdapter protocol.
 */
- (void)addAdapter:(MDRouterAdapter *)adapter;

/**
 Remove sub adapter.

 @param adapter instance of MDRouterAdapter protocol.
 */
- (void)removeAdapter:(MDRouterAdapter *)adapter;

/**
 Add invocation.

 @param invocation invocation to invoke.
 */
- (BOOL)addInvocation:(MDRouterInvocation *)invocation;

/**
 Remove invocation.

 @param invocation invocation to invoke.
 */
- (BOOL)removeInvocation:(MDRouterInvocation *)invocation;

/**
 Remove invocation.

 @param target target of invocation to invoke.
 @param action action of invocation to invoke.
 @param baseURL base url of  invocation to invoke.
 */
- (BOOL)removeInvocationWithTarget:(id)target action:(SEL)action baseURL:(NSURL *)baseURL;

/**
 Forward base url to another base url.

 @param URL the source url to forward.
 @param toURL the destinational url to forward.
 */
- (BOOL)forwardURL:(NSURL *)URL toURL:(NSURL *)toURL;

/**
 Forward base url to another base url.

 @param URLString the source url to forward.
 @param toURLString the destinational url to forward.
 */
- (BOOL)forwardURLString:(NSString *)URLString toURLString:(NSString *)toURLString;

/**
 To verify URL whether any adapter or invocation is matched.

 @param URL URL to be verified.
 @return YES if any adapter of invocation is matched, or NO.
 */
- (BOOL)canOpenURL:(NSURL *)URL;

/**
 Open URL to route an result if any adapter or invocation is matched.

 @param URL whole URL with prameters to route
 @return YES if any adapter or invocation is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL;

/**
 Open URL to route an result if any adapter or invocation is matched.

 @param URL whole URL with prameters to route.
 @param error output error if open URL failed.
 @return YES if any adapter or invocation is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL error:(NSError **)error;

/**
 Open URL to route an result if any adapter or invocation is matched.

 @param URL whole URL with prameters to route.
 @param output output userinfo if open URL successfully.
 @param error output error if open URL failed.
 @return YES if any adapter or invocation is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error;

/**
 Open URL to route an result if any adapter or invocation is matched.

 @param URL whole URL with prameters to route.
 @param arguments input arguments for adapter or invocation.
 @param output output userinfo if open URL successfully.
 @param error output error if open URL failed.
 @return YES if any adapter or invocation is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;

/**
 Open URL with omit arguments to route an result if any adapter or invocation is matched.

 @param URL whole URL with prameters to route.
 @param output output userinfo if open URL successfully.
 @param error output error if open URL failed.
 @param key first argument for adapter or invocation.
 @return YES if any adapter or invocation is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error arguments:(NSString *)key, ...;

/**
 Open URL with arguments list to route an result if any adapter or invocation is matched.

 @param URL whole URL with prameters to route.
 @param output output userinfo if open URL successfully.
 @param error output error if open URL failed.
 @param key first item for argument list.
 @param arguments arguments list for adapter or invocation.
 @return YES if any adapter or invocation is matched without any error.
 */
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error key:(NSString *)key arguments:(va_list)arguments;

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
