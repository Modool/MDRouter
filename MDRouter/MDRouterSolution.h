//
//  MDRouterViewSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDRouterSolution <NSObject>

+ (id)solutionWithRouterArguments:(NSDictionary *)arguments outputArguments:(NSDictionary **)outputArguments error:(NSError **)error;

@end

@protocol MDRouterClassSolution <MDRouterSolution>

@property (nonatomic, copy, readonly, class) NSURL *URL;

// name: necessary
@property (nonatomic, strong, readonly, class) NSDictionary<NSString *, NSNumber *> *parameters;

+ (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error;

@end

@protocol MDRouterInstanceSolution <MDRouterSolution>

@property (nonatomic, copy, readonly) NSURL *URL;

// name: necessary
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *parameters;

@optional
@property (nonatomic, assign, readonly) BOOL synchronize;

- (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error;

- (void)asynchronizeInvokeWithCompletion:(void (^)(id<MDRouterInstanceSolution> solution))completion;

@end

@protocol MDRouterViewControllerDisplaySolution <NSObject>

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error;
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated error:(NSError **)error;

@end

/**
 Solution of view controller route.
 
 * push        1 or 0
 * animated    1 or 0
 */
@protocol MDRouterViewControllerSolution <MDRouterClassSolution, MDRouterViewControllerDisplaySolution>

@end

@protocol MDRouterAccessableSolution <NSObject>

@optional

+ (id<MDRouterInstanceSolution>)verifyValidWithRouterArguments:(NSDictionary *)arguments;

@end

@interface MDRouterInstanceSolution : NSObject <MDRouterInstanceSolution>

+ (instancetype)solutionWithBlock:(void (^)(NSDictionary *arguments, NSError **error))block;
- (instancetype)initWithBlock:(void (^)(NSDictionary *arguments, NSError **error))block;

+ (instancetype)solutionWithTarget:(id)target action:(SEL)action;
- (instancetype)initWithTarget:(id)target action:(SEL)action;

@end

@interface MDRouterInstanceAsynchronizeSolution : NSObject <MDRouterInstanceSolution>

+ (instancetype)solutionWithBlock:(void (^)(void (^completion)(id<MDRouterInstanceSolution> solution)))block;
- (instancetype)initWithBlock:(void (^)(void (^completion)(id<MDRouterInstanceSolution> solution)))block;

@end

extern NSString * MDRouterSolutionItemPushKey;
extern NSString * MDRouterSolutionItemAnimatedKey;
extern NSString * MDRouterSolutionItemViewControllerKey;

@interface UIViewController (MDRouterSolution)<MDRouterViewControllerSolution>

@end


