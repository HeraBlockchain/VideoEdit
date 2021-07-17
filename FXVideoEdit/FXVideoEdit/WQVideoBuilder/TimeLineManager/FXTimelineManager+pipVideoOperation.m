//
//  FXTimelineManager+pipVideoOperation.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager+pipVideoOperation.h"
#import "FXTimelineManager+resource.h"

@implementation FXTimelineManager (pipVideoOperation)

- (void)addPipVideoAtTime:(CMTime)startTime video:(FXVideoItem *)videoItem {
    [self addSource:videoItem type:FXDescribeTypePip];
    FXPIPVideoDescribe *addVideo = [FXPIPVideoDescribe new];
    addVideo.videoItem = videoItem;
    addVideo.startTime = startTime;
    addVideo.duration = videoItem.timeRange.duration;
    addVideo.sourceRange = videoItem.timeRange;
    [self.timelineDescribe.pipVideoArray addObject:addVideo];
}

- (void)setPipAudioVolume:(CGFloat)volume
{
    self.timelineDescribe.pipVideoVolume = volume;
}

@end
