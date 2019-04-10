//
//  MDRouterBinder.h
//  MDRouter
//
//  Created by 张征鸿 on 2019/2/15.
//  Copyright © 2019 markejave. All rights reserved.
//

#import "MDRouterImp.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDRouterBinder : NSObject

- (void)invokeTarget:(id)target action:(SEL)action baseURLString:(NSString *)baseURLString;
- (void)invokeTarget:(id)target action:(SEL)action targetQueue:(dispatch_queue_t)targetQueue baseURLString:(NSString *)baseURLString, ...;

@end


#define MDRouterBinderClassMethodPrefix             MDRouterBinder_bind_
#define MDRouterBinderClassMethodPrefixString       @"MDRouterBinder_bind_"

#define MDRouterTargetBind(CLASS, SELECTOR_FLAG, SELECTOR, TARGET_QUEUE, BASE_URL_STRING, ...)                                          \
@implementation MDRouterBinder (CLASS##SELECTOR_FLAG)                                                                                   \
- (void)MDRouterBinder_bind_##CLASS##SELECTOR_FLAG {                                                                                    \
    static dispatch_once_t onceToken;                                                                                                   \
    dispatch_once(&onceToken, ^{                                                                                                        \
        dispatch_async(dispatch_get_main_queue(), ^{                                                                                    \
            [self invokeTarget:(id)[CLASS class] action:SELECTOR targetQueue:TARGET_QUEUE baseURLString:BASE_URL_STRING, ##__VA_ARGS__];\
        });                                                                                                                             \
    });                                                                                                                                 \
}                                                                                                                                       \
@end

#define MDRouterTargetBindDefaultQueue(CLASS, SELECTOR_FLAG, SELECTOR, BASE_URL_STRING, ...)      MDRouterTargetBind(CLASS, SELECTOR_FLAG, SELECTOR, dispatch_get_main_queue(), BASE_URL_STRING, ##__VA_ARGS__, nil)
#define MDRouterTargetBindDefaultSelector(CLASS, BASE_URL_STRING, ...)                            MDRouterTargetBindDefaultQueue(CLASS, invokeWithArguments_error, @selector(invokeWithArguments:error:), BASE_URL_STRING, ##__VA_ARGS__, nil)
#define MDRouterTargetBindViewController(CLASS, BASE_URL_STRING, ...)                             MDRouterTargetBindDefaultSelector(CLASS, BASE_URL_STRING, ##__VA_ARGS__, nil)

NS_ASSUME_NONNULL_END
