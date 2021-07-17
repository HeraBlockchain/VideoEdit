//
//  FXTimelineDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineDescribe.h"

@implementation FXTimelineDescribe

- (instancetype)init {
    self = [super init];
    if (self) {
        _duration = kCMTimeInvalid;
        _lengthTimeScale = LENGTH_TIME_SCALE_MIN;
        _pictureSize = FXPictureSizeDefult;
        _videoArray = [NSMutableArray new];
        _transitionArray = [NSMutableArray new];
        _audioArray = [NSMutableArray new];
        _pipVideoArray = [NSMutableArray new];
        _musicArray = [NSMutableArray new];
        _titleArray = [NSMutableArray new];
        _pipVideoVolume = 100;
        _mainVideoVolume = 100;
    }
    return self;
}

@end
