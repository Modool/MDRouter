//
//  MDRouter.h
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for MDRouter.
FOUNDATION_EXPORT double MDRouterVersionNumber;

//! Project version string for MDRouter.
FOUNDATION_EXPORT const unsigned char MDRouterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MDRouter/PublicHeader.h>

#import <Foundation/Foundation.h>
#import "MDRouterAdapter.h"
#import "MDRouterSolution.h"

extern NSString * const MDRouterErrorDomain;

/**
*   Protocol scheme://host:port/path?query
**/

@class BFCBusModel;
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

+ (instancetype)routerWithBaseURL:(NSURL *)baseURL;

@end

#define MDRouterSolutionBind(solution, baseURL)    [[MDRouter defaultRouter] addSolution:solution baseURL:baseURL]

#define MDRouterSolutionClassBind(cls, baseURL)     @implementation cls (MDRouterSolution)                  \
                                                    + (void)load{                                           \
                                                        static dispatch_once_t onceToken;                   \
                                                        dispatch_once(&onceToken, ^{                        \
                                                            MDRouterSolutionBind((id)[cls class], baseURL); \
                                                        });                                                 \
                                                    }                                                       \
                                                    @end

