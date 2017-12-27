//
//  NSSet+MDRouter.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "NSSet+MDRouter.h"

@implementation NSSet (MDRouter)

- (NSSet *)setByAddingObjectsFromArray:(NSArray *)array;{
    NSMutableSet *set = [self mutableCopy];
    [set addObjectsFromArray:array];
    
    return set;
}

- (NSSet *)setByIntersectSet:(NSSet *)otherSet;{
    NSMutableSet *set = [self mutableCopy];
    [set intersectSet:otherSet];
    
    return set;
}

- (NSSet *)setByMinusSet:(NSSet *)otherSet;{
    NSMutableSet *set = [self mutableCopy];
    [set minusSet:otherSet];
    
    return set;
}

- (NSSet *)setByUnionSet:(NSSet *)otherSet;{
    NSMutableSet *set = [self mutableCopy];
    [set unionSet:otherSet];
    
    return set;
}

@end
