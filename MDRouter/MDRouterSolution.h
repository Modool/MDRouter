//
//  MDRouterViewSolution.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <UIKit/UIKit.h>

// Solution protocol to support outside routing if adapters aren't enough.
@protocol MDRouterSolution <NSObject>

/**
 Be called with arguments and output error point if solution is matched.

 @param arguments input arguments which maybe decoded by query string of URL.
 @param error output error.
 @return a result returned if solution invoked, maybe nil.
 */
- (id)invokeWithRouterArguments:(NSDictionary *)arguments error:(NSError **)error;

@optional

// The conditions for arguments
// Defined: {name: necessary}
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *argumentConditions;

@end

@protocol MDRouterAccessableSolution <NSObject>

@optional
/**
 Be called with arguments if solution matched needs to verify before invoking.
 
 @param arguments input arguments which maybe decoded by query string of URL.
 @return a solution returned if solution needs to transmit other temporary solution.
 */
- (id<MDRouterSolution>)verifyValidWithRouterArguments:(NSDictionary *)arguments;

@end

