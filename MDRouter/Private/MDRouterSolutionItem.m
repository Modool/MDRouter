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

#import "NSError+MDRouter.h"
#import "MDRouterConstants.h"

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
        if ([accessableSolution respondsToSelector:@selector(verifyValidWithRouterArguments:)]) {
            id<MDRouterSolution> solution = [accessableSolution verifyValidWithRouterArguments:arguments];
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
    NSParameterAssert(solution);
    
    BOOL valid = [self shouldHandleSolution:solution arguments:arguments];
    if (!valid) {
        if (error) *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeLackOfNecessaryParameters userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to handle solution: %@ because Lack of necessary arguments: %@", solution, arguments]} underlyingError:*error];
        return nil;
    }
    
    if (![solution conformsToProtocol:@protocol(MDRouterAsynchronizeSolution)]) {
        return [solution invokeWithRouterArguments:arguments error:error];
    } else {
        [(id<MDRouterAsynchronizeSolution>)solution invokeAsynchronizedArguments:arguments error:error completion:^(id<MDRouterSolution> completeSolution) {
            if (completeSolution) {
                [self handlerSolution:completeSolution arguments:arguments error:NULL completion:completion];
            } else if (completion) {
                completion();
            }
        }];
    }
    return nil;
}

- (BOOL)shouldHandleSolution:(id<MDRouterSolution>)solution arguments:(NSDictionary *)arguments{
    if ([solution respondsToSelector:@selector(argumentConditions)]) {
        NSDictionary<NSString *, NSNumber *> *conditions = [solution argumentConditions];
        NSArray<NSString *> *argumentNames = [arguments allKeys];
        
        for (NSString *key in [conditions allKeys]) {
            if ([argumentNames containsObject:key]) continue;
            if ([conditions[key] boolValue]) return NO;
        }
    }
    
    return YES;
}

@end
