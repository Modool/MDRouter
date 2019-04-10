//
//  MDRouterInvocation.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDRouterInvocation : NSObject 

@property (nonatomic, copy, readonly) NSURL *baseURL;

@property (nonatomic, readonly) dispatch_queue_t queue;

@property (nonatomic, weak, readonly) id target;
@property (nonatomic, assign, readonly) SEL action;

+ (instancetype)invocationWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action;
+ (instancetype)invocationWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action queue:(dispatch_queue_t)queue;

- (instancetype)initWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action;
- (instancetype)initWithBaseURL:(NSURL *)baseURL target:(id)target action:(SEL)action queue:(dispatch_queue_t)queue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error;

- (BOOL)validatBaseURL:(NSURL *)baseURL;

@end

@protocol MDRouterAsynchronizedInvocation <NSObject>

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error completion:(void (^)(MDRouterInvocation *invocation))completion;

@end
