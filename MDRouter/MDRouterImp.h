//
//  MDRouterImp.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDRouterAdapter.h"

extern NSString * const MDRouterErrorDomain;

static NSString * const MDRouterMethodScheme = @"invocation";

@class MDRouterInvocation;
@interface MDRouter : MDRouterAdapter

@property (nonatomic, copy, readonly) NSURL *baseURL NS_UNAVAILABLE;

// Default is nil
@property (nonatomic, copy) NSSet<NSString *> *validSchemes;
@property (nonatomic, copy) NSSet<NSString *> *invalidSchemes;

// Default is nil
@property (nonatomic, copy) NSSet<NSString *> *validHosts;
@property (nonatomic, copy) NSSet<NSString *> *invalidHosts;

// Default is nil
@property (nonatomic, copy) NSSet<NSNumber *> *validPorts;
@property (nonatomic, copy) NSSet<NSNumber *> *invalidPorts;

+ (instancetype)adapter NS_UNAVAILABLE;
+ (instancetype)adapterWithBaseURL:(NSURL *)baseURL NS_UNAVAILABLE;

+ (instancetype)router;
+ (instancetype)routerWithBaseURL:(NSURL *)baseURL;
+ (instancetype)routerWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue;

- (void)addProtocol:(Protocol *)protocol;
- (void)removeProtocol:(Protocol *)protocol;

- (void)async:(void (^)(MDRouterAdapter *router))block;

@end

#define MDRouterMethodHostAs(HOST_NAME, PATH_NAME, FIRST_ITEM, SELECTOR) \
@optional SELECTOR __MD_ROUTER_HOST_AS__##HOST_NAME:(id)argument1 __MD_ROUTER_PATH_AS__##PATH_NAME:(id)argument2 FIRST_ITEM:(id)FIRST_ITEM; @required SELECTOR

#define MDRouterMethodAs(PATH_NAME, FIRST_ITEM, SELECTOR) \
@optional SELECTOR __MD_ROUTER_PATH_AS__##PATH_NAME:(id)argument FIRST_ITEM:(id)FIRST_ITEM; @required SELECTOR

#define MDRouterNonArgumentMethodHostAs(HOST_NAME, PATH_NAME, SELECTOR) \
@optional SELECTOR##__MD_ROUTER_HOST_AS__##HOST_NAME:(id)argument1 __MD_ROUTER_PATH_AS__##PATH_NAME:(id)argument; @required SELECTOR

#define MDRouterNonArgumentMethodAs(PATH_NAME, SELECTOR) \
@optional SELECTOR##__MD_ROUTER_PATH_AS__##PATH_NAME:(id)argument; @required SELECTOR
