//
//  MDRouterConstants.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

extern NSString * const MDRouterErrorDomain;

typedef NS_ENUM(NSUInteger, MDRouterErrorCode) {
    MDRouterErrorCodeNone,
    MDRouterErrorCodeUnredirectURL,
    MDRouterErrorCodeInvalidURL,
    MDRouterErrorCodeLackOfNecessaryParameters,
    MDRouterErrorCodeNotLogin,
    MDRouterErrorCodeAccessPermission,
    MDRouterErrorCodeNoHandler,
    MDRouterErrorCodeHandleFailed,
    MDRouterErrorCodeAsynchronizedHandleFailed,
    MDRouterErrorCodeNoVisibleNavigationController,
    MDRouterErrorCodeNoVisibleViewController,
    MDRouterErrorCodePresentedViewControllerExsit,
};
