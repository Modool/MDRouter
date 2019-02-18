//
//  MDRouterSet.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDRouterAdapter.h"

extern NSString * const MDRouterErrorDomain;

@class MDRouterSolution;
@interface MDRouterSet : MDRouterAdapter

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

- (void)async:(void (^)(id<MDRouterAdapter> router))block;

@end
