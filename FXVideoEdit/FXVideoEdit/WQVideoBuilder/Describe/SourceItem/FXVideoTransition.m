//
//  FXVideoTransition.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/27.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoTransition.h"

@implementation FXVideoTransition

+ (id)disolveTransitionWithDuration:(CMTime)duration {
    FXVideoTransition *transition = [self videoTransition];
    transition.type = kTransitionTypeNone;
    transition.duration = duration;
    return transition;
}

+ (id)videoTransition {
    return [[[self class] alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        _type = kTransitionTypeNone;
        _timeRange = kCMTimeRangeInvalid;
    }
    return self;
}

@end