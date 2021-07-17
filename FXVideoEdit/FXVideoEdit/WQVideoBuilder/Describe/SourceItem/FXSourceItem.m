//
//  FXTimelineItem.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXSourceItem.h"

@implementation FXSourceItem

- (id)init {
    self = [super init];
    if (self) {
        _timeRange = kCMTimeRangeInvalid;
    }
    return self;
}

@end