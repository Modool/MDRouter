//
//  MDRouterConstants.h
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

extern NSString * const MDRouterErrorDomain;

typedef NS_ENUM(NSUInteger, MDRouterErrorCode) {
    MDRouterErrorCodeNone,
    MDRouterErrorCodeUnredirectURL,
    MDRouterErrorCodeInvalidURL,
    MDRouterErrorCodeInvalidParameter,
    MDRouterErrorCodeNotLogin,
    MDRouterErrorCodeAccessPermission,
    MDRouterErrorCodeNoHandler,
    MDRouterErrorCodeHandleFailed,
    MDRouterErrorCodeNoVisibleNavigationController,
    MDRouterErrorCodeNoVisibleViewController,
    MDRouterErrorCodePresentedViewControllerExsit,
};
