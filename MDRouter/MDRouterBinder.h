//
//  MDRouterBinder.h
//  MDRouter
//
//  Created by 张征鸿 on 2019/2/15.
//  Copyright © 2019 markejave. All rights reserved.
//

#import "MDRouterSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDRouterBinder : NSObject {
    MDRouterSet *_router;
}

+ (instancetype)instanceWithRouter:(MDRouterSet *)router;

- (void)bindSolution:(id)solution baseURLString:(NSString *)baseURLString;
- (void)bindSolution:(id)solution baseURLString:(NSString *)baseURLString targetQueue:(dispatch_queue_t)targetQueue;

- (void)bind;

@end

#define MDRouterSolutionClassBindPrefix @"MDRouterBinder_bind_"

#define MDRouterSolutionClassBind(CLASS, BASE_URL_STRING)   \
@implementation MDRouterBinder (CLASS)                            \
- (void)MDRouterBind_bind_##CLASS {                              \
    static dispatch_once_t onceToken;                   \
    dispatch_once(&onceToken, ^{                        \
        dispatch_async(dispatch_get_main_queue(), ^{    \
            [self bindSolution:(id)[CLASS class] baseURLString:BASE_URL_STRING]; \
        });                                             \
    });                                                 \
}                                                       \
@end


#define MDRouterSolutionClassBindQueue(CLASS, BASE_URL_STRING, TARGET_QUEUE)   \
@implementation MDRouterBinder (CLASS)                            \
- (void)MDRouterBind_bind_##CLASS {                              \
    static dispatch_once_t onceToken;                   \
    dispatch_once(&onceToken, ^{                        \
        dispatch_async(dispatch_get_main_queue(), ^{    \
            [self bindSolution:(id)[CLASS class] baseURLString:BASE_URL_STRING targetQueue:TARGET_QUEUE]; \
        });                                             \
    });                                                 \
}                                                       \
@end

NS_ASSUME_NONNULL_END
