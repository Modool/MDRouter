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

// Default is nil
@property (nonatomic, copy, readonly) NSString *scheme;

// Default is nil
@property (nonatomic, copy, readonly) NSString *host;

// Default is nil
@property (nonatomic, copy, readonly) NSString *port;

@end

#define MDRouterSolutionBind(solution)    [[MDRouter defaultRouter] addSolution:solution]

#define MDRouterSolutionClassBind(cls)    @implementation cls (MDRouterSolution)            \
                                                + (void)load{                                       \
                                                    static dispatch_once_t onceToken;               \
                                                    dispatch_once(&onceToken, ^{                    \
                                                        MDRouterSolutionBind((id)[cls class]);  \
                                                    });                                             \
                                                }                                                   \
                                              @end

