//
//  MDRouterSolutionItem.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <objc/runtime.h>
#import "MDRouterSolutionItem.h"
#import "MDRouterAsynchronizeSolution.h"

@interface MDRouterSolutionItem ()

@property (nonatomic, copy) NSURL *baseURL;

@property (nonatomic, strong) id<MDRouterSolution> solution;

@end

@implementation MDRouterSolutionItem

+ (instancetype)solutionItemWithBaseURL:(NSURL *)baseURL solution:(id<MDRouterSolution>)solution;{
    NSParameterAssert(solution && baseURL);
    
    return [[self alloc] initWithBaseURL:baseURL solution:solution];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL solution:(id<MDRouterSolution>)solution;{
    NSParameterAssert(solution && baseURL);
    
    if (self = [super init]) {
        self.baseURL = baseURL;
        self.solution = solution;
    }
    return self;
}

- (BOOL)validatBaseURL:(NSURL *)baseURL;{
    if (![[baseURL scheme] isEqualToString:[[self baseURL] scheme]]) return NO;
    if (![[baseURL host] isEqualToString:[[self baseURL] host]]) return NO;
    
    return [[baseURL path] hasPrefix:[[self baseURL] path]];
}

- (id)invokeWithArguments:(NSDictionary *)arguments error:(NSError **)error{
    id (^completion)(NSError **error) = ^id(NSError **error){
        return [self handlerSolution:[self solution] arguments:arguments error:error];
    };
    
    if ([[self solution] conformsToProtocol:@protocol(MDRouterAccessableSolution)]) {
        id<MDRouterAccessableSolution> accessableSolution = (id)[self solution];
        if ([[accessableSolution class] respondsToSelector:@selector(verifyValidWithRouterArguments:)]) {
            id<MDRouterSolution> solution = [[accessableSolution class] verifyValidWithRouterArguments:arguments];
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

- (id)handlerSolution:(id<MDRouterSolution>)solution arguments:(NSDictionary *)arguments error:(NSError **)error{
    return [self handlerSolution:solution arguments:arguments error:error completion:nil];
}

- (id)handlerSolution:(id<MDRouterSolution>)solution arguments:(NSDictionary *)arguments error:(NSError **)error completion:(void (^)(void))completion{
    if (!solution) return nil;
    
    if (![solution conformsToProtocol:@protocol(MDRouterAsynchronizeSolution)]) {
        return [solution invokeWithRouterArguments:arguments error:error];
    } else {
        [(id<MDRouterAsynchronizeSolution>)solution asynchronizeInvokeWithCompletion:^(id<MDRouterSolution> completeSolution) {
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
