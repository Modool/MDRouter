//
//  MDRouterAccessableInvocation.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRouterInvocation;
// Invocation protocol to support outside routing if adapters aren't enough.
@protocol MDRouterAccessableInvocation <NSObject>

@optional
// The conditions for arguments
// Defined: {name: necessary}
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *argumentConditions;

/**
 Be called with arguments if invocation matched needs to verify before invoking.
 
 @param arguments input arguments which maybe decoded by query string of URL.
 @return a invocation returned if invocation needs to transmit other temporary invocation.
 */
- (MDRouterInvocation *)verifyValidWithRouterArguments:(NSDictionary *)arguments;

@end


@protocol MDRouterAccessableClassInvocation <MDRouterAccessableInvocation>

@optional
// The conditions for arguments
// Defined: {name: necessary}
@property (nonatomic, strong, readonly, class) NSDictionary<NSString *, NSNumber *> *argumentConditions;

/**
 Be called with arguments if invocation matched needs to verify before invoking.

 @param arguments input arguments which maybe decoded by query string of URL.
 @return a invocation returned if invocation needs to transmit other temporary invocation.
 */
+ (MDRouterInvocation *)verifyValidWithRouterArguments:(NSDictionary *)arguments;

@end
