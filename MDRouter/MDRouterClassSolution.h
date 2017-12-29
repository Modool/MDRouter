//
//  MDRouterClassSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSolution.h"

// Class solution protocol to support outside class routing if adapters aren't enough.
@protocol MDRouterClassSolution <MDRouterSolution>

/**
 Be called with arguments and output error point if class solution is matched.
 
 @param arguments input arguments which maybe decoded by query string of URL.
 @param error output error.
 @return a result returned if solution invoked, maybe nil.
 */
+ (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error;

@optional

/**
 Be called with arguments if solution matched needs to verify before invoking.
 
 @param arguments input arguments which maybe decoded by query string of URL.
 @return a solution returned if solution needs to transmit other temporary solution.
 */
+ (id<MDRouterSolution>)verifyValidWithRouterArguments:(NSDictionary *)arguments;

// The conditions for arguments
// Defined: {name: necessary}
@property (nonatomic, strong, class, readonly) NSDictionary<NSString *, NSNumber *> *argumentConditions;

// {name: necessary}
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *argumentConditions NS_UNAVAILABLE;

- (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error NS_UNAVAILABLE;
- (id<MDRouterSolution>)verifyValidWithRouterArguments:(NSDictionary *)arguments NS_UNAVAILABLE;

@end
