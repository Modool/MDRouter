//
//  MDRouterBinder.m
//  MDRouter
//
//  Created by 张征鸿 on 2019/2/15.
//  Copyright © 2019 markejave. All rights reserved.
//

#import <objc/message.h>

#import "MDRouterBinder.h"
#import "MDRouterBinder+Private.h"

#import "MDRouterInvocation.h"

@implementation MDRouterBinder

- (void)router:(MDRouter *)router invokeTarget:(id)target action:(SEL)action baseURLString:(NSString *)baseURLString {
    [self router:router invokeTarget:target action:action targetQueue:dispatch_get_main_queue() baseURLString:baseURLString, nil];
}

- (void)router:(MDRouter *)router invokeTarget:(id)target action:(SEL)action targetQueue:(dispatch_queue_t)targetQueue baseURLString:(NSString *)baseURLString, ...{
    va_list list;
    va_start(list, baseURLString);
    while (baseURLString) {
        MDRouterInvocation *invocation = [MDRouterInvocation invocationWithBaseURL:[NSURL URLWithString:baseURLString] target:target action:action queue:targetQueue];
        [router addInvocation:invocation];

        baseURLString = va_arg(list, NSString *);
    }
    va_end(list);
}

+ (void)loadWithRouter:(MDRouter *)router {
    MDRouterBinder *binder = [[self alloc] init];

    unsigned int count = 0;
    Method *methods = class_copyMethodList(self.class, &count);

    for (int i = 0; i < count; i++) {
        Method method = methods[i];

        SEL methodSelector = method_getName(method);
        NSString *methodName = NSStringFromSelector(methodSelector);

        NSString *prefxix = MDRouterBinderClassMethodPrefixString;
        if (![methodName hasPrefix:prefxix]) continue;

        void (*invoke)(id, SEL, MDRouter *) = (void (*)(id, SEL, MDRouter *))class_getMethodImplementation(self.class, methodSelector);
        if (invoke) invoke(binder, methodSelector, router);
    }
}

@end
