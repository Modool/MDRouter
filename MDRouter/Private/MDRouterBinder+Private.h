//
//  MDRouterBinder+Private.h
//  MDRouter
//
//  Created by xulinfeng on 2019/4/10.
//  Copyright © 2019 markejave. All rights reserved.
//

#import <MDRouter/MDRouter.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDRouterBinder () {
    MDRouter *_router;
}

+ (instancetype)binderWithRouter:(MDRouter *)router;

- (void)load;

@end

NS_ASSUME_NONNULL_END
