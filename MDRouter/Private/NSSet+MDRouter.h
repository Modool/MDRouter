//
//  NSSet+MDRouter.h
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet<__covariant ObjectType> (MDRouter)

- (NSSet<ObjectType> *)setByAddingObjectsFromArray:(NSArray<ObjectType> *)array;

- (NSSet<ObjectType> *)setByIntersectSet:(NSSet<ObjectType> *)otherSet;

- (NSSet<ObjectType> *)setByMinusSet:(NSSet<ObjectType> *)otherSet;

- (NSSet<ObjectType> *)setByUnionSet:(NSSet<ObjectType> *)otherSet;

@end
