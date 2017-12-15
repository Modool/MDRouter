//
//  MDRouterSolutionItem.m
//  MDRouter
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import "MDRouterSolutionItem.h"
#import <objc/runtime.h>

@interface MDRouterSolutionItem ()

@property (nonatomic, copy) NSURL *URL;

@property (nonatomic, strong) id<MDRouterSolution> solution;

@end

@implementation MDRouterSolutionItem

+ (instancetype)solutionItemWithURL:(NSURL *)URL solution:(id<MDRouterSolution>)solution;{
    NSParameterAssert(solution && URL);
    
    return [[self alloc] initWithURL:URL solution:solution];
}

- (instancetype)initWithURL:(NSURL *)URL solution:(id<MDRouterSolution>)solution;{
    NSParameterAssert(solution && URL);
    
    if (self = [super init]) {
        self.URL = URL;
        self.solution = solution;
    }
    return self;
}

- (BOOL)validatURL:(NSURL *)URL;{
    if (!URL) return YES;
    if (![[URL scheme] isEqualToString:[[self URL] scheme]]) return NO;
    if (![[URL host] isEqualToString:[[self URL] host]]) return NO;
    
    return [[URL path] hasPrefix:[[self URL] path]];
}

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error{
    id (^completion)(NSError **error) = ^id(NSError **error){
        if ([[self solution] conformsToProtocol:@protocol(MDRouterViewControllerSolution)]) {
            id<MDRouterViewControllerSolution> solution = (id)[self solution];
            return [[solution class] invokeWithRouterArguments:arguments error:error];
        } else if ([[self solution] conformsToProtocol:@protocol(MDRouterInstanceSolution)] &&
                   [[self solution] respondsToSelector:@selector(invokeWithRouterArguments:error:)]) {
            id<MDRouterInstanceSolution> solution = (id)[self solution];
            return [self handlerSolution:solution arguments:arguments error:error];
        } else if ([[self solution] conformsToProtocol:@protocol(MDRouterClassSolution)] &&
                   [[self solution] respondsToSelector:@selector(invokeWithRouterArguments:error:)]) {
            id<MDRouterInstanceSolution> solution = (id)[self solution];
            return [self handlerSolution:solution arguments:arguments error:error];
        }
        return nil;
    };
    
    if ([[self solution] conformsToProtocol:@protocol(MDRouterAccessableSolution)]) {
        id<MDRouterAccessableSolution> accessableSolution = (id)[self solution];
        if ([[accessableSolution class] respondsToSelector:@selector(verifyValidWithRouterArguments:)]) {
            MDRouterInstanceSolution *solution = [[accessableSolution class] verifyValidWithRouterArguments:arguments];
            if (solution) {
                [self handlerSolution:solution arguments:arguments error:error completion:^{
                    completion(NULL);
                }];
                return nil;
            }
        }
    }
    return completion(error);
}

- (id)handlerSolution:(id<MDRouterInstanceSolution>)solution arguments:(NSDictionary *)arguments error:(NSError **)error{
    return [self handlerSolution:solution arguments:arguments error:error completion:nil];
}

- (id)handlerSolution:(id<MDRouterInstanceSolution>)solution arguments:(NSDictionary *)arguments error:(NSError **)error completion:(void (^)(void))completion{
    if (!solution) return nil;
    
    if (![solution respondsToSelector:@selector(synchronize)] || [solution synchronize]) {
        return [solution invokeWithRouterArguments:arguments error:error];
    } else {
        [solution asynchronizeInvokeWithCompletion:^(id<MDRouterInstanceSolution> completeSolution) {
            if (completeSolution) {
                [self handlerSolution:completeSolution arguments:arguments error:NULL completion:completion];
            } else if (completion) {
                completion();
            }
        }];
    }
    return nil;
}

@end
