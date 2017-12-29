//
//  MDRouterAsynchronizeClassSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterAsynchronizeSolution.h"

// Asynchronous class solution protocol to support outside class asynchronous routing if adapters aren't enough.
@protocol MDRouterAsynchronizeClassSolution <MDRouterAsynchronizeSolution>

- (BOOL)invokeAsynchronizedArguments:(NSDictionary *)arguments error:(NSError **)error completion:(void (^)(id<MDRouterSolution> solution))completion NS_UNAVAILABLE;

/**
 Be called with arguments and output error point if class solution is matched.
 
 @param arguments input arguments which maybe decoded by query string of URL.
 @param error output error.
 @param completion called asynchronously when solution is completed.
 @return result of solution invoked.
 */
+ (BOOL)invokeAsynchronizedArguments:(NSDictionary *)arguments error:(NSError **)error completion:(void (^)(id<MDRouterSolution> solution))completion;

@end
