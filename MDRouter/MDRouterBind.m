//
//  MDRouterBind.m
//  MDRouter
//
//  Created by 张征鸿 on 2019/2/15.
//  Copyright © 2019 markejave. All rights reserved.
//

#import "MDRouterBind.h"
#import <objc/message.h>

@implementation MDRouterBind

+ (instancetype)instanceWithRouter:(MDRouterSet *)router {
    MDRouterBind *object = [[self alloc] init];
    object->_router = router;
    
    return object;
}

- (void)bindSolution:(id)solution baseURLString:(NSString *)baseURLString {
    [self bindSolution:solution baseURLString:baseURLString targetQueue:dispatch_get_main_queue()];
}

- (void)bindSolution:(id)solution baseURLString:(NSString *)baseURLString targetQueue:(dispatch_queue_t)targetQueue {
    [_router addSolution:solution baseURL:[NSURL URLWithString:baseURLString] queue:targetQueue];
}

- (void)bind {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(MDRouterBind.class, &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL methodSelector = method_getName(method);
        NSString *methodName = NSStringFromSelector(methodSelector);
        if (![methodName hasPrefix:MDRouterSolutionClassBindPrefix]) continue;
        
        method = class_getInstanceMethod(MDRouterBind.class, methodSelector);
        if (!method) continue;
        if ([self respondsToSelector:method_getName(method)]) ((void(*)(id, SEL))(void *)objc_msgSend)(self, method_getName(method));
    }
}

@end
