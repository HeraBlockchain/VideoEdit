//
//  FXTimelineManager+videoEdit.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager+resource.h"
#import "FXTimelineManager+videoEdit.h"

@implementation FXTimelineManager (videoEdit)

- (void)addSourceVideos:(NSArray <FXVideoItem *> *)videoItemArray
{
    if (!videoItemArray.count) {
        return;
    }
    if (self.timelineDescribe.videoArray.count == 0) {
        NSInteger index = 0;
        for (FXVideoItem *video in videoItemArray) {
            [self addSourceAtIndex:index videoAsset:video];
            index++;
        }
    }
}

- (void)addSourceAtIndex:(NSInteger)index
              videoAsset:(FXVideoItem *)videoItem {
    if (self.timelineDescribe.videoArray.count == 0) {
        self.timelineDescribe.defaultNaturalSize = videoItem.videoTrack.naturalSize;
    }
    [self addSource:videoItem type:FXDescribeTypeVideo];
    if (index == 0 || index == self.timelineDescribe.videoArray.count) {
        //插入在最前方和最后
        FXVideoDescribe *addVideo = [FXVideoDescribe new];
        addVideo.videoItem = videoItem;
        addVideo.startTime = self.timelineDescribe.duration;
        addVideo.sourceRange = videoItem.timeRange;
        addVideo.duration = videoItem.timeRange.duration;
        if (index == 0) {
            [self.timelineDescribe.videoArray insertObject:addVideo atIndex:0];
        } else {
            [self.timelineDescribe.videoArray addObject:addVideo];
        }
        [self reArrangementItems];
    } else {
        FXVideoDescribe *addVideo = [FXVideoDescribe new];
        addVideo.videoItem = videoItem;
        addVideo.startTime = self.timelineDescribe.duration;
        addVideo.duration = videoItem.timeRange.duration;
        addVideo.sourceRange = videoItem.timeRange;
        [self.timelineDescribe.videoArray insertObject:addVideo atIndex:index];
        [self reArrangementItems];
    }
}

- (void)executeMoveVideoItem {
    
    for (FXVideoDescribe *video in self.timelineDescribe.videoArray) {
        
    }
    [self reArrangementItems];
}


- (void)moveVideoItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self removeTransitionItemAtVideoIndex:fromIndex];
    [self removeTransitionItemAtVideoIndex:toIndex];
    FXVideoDescribe *videoDes = [self.timelineDescribe.videoArray objectAtIndex:fromIndex];
    [self.timelineDescribe.videoArray insertObject:videoDes atIndex:toIndex];
    if (fromIndex < toIndex) {
        [self.timelineDescribe.videoArray removeObjectAtIndex:fromIndex];
    } else {
        [self.timelineDescribe.videoArray removeObjectAtIndex:fromIndex + 1];
    }
    [self reArrangementItems];
}

- (void)removeVideoItemAtIndex:(NSInteger)index {
    [self removeTransitionItemAtVideoIndex:index];
    if (index == self.timelineDescribe.videoArray.count - 1) {
        [self.timelineDescribe.videoArray removeLastObject];
    } else if (index == 0) {
        [self.timelineDescribe.videoArray removeFirstObject];
    } else {
        [self.timelineDescribe.videoArray removeObjectAtIndex:index];
    }
    [self reArrangementItems];
}

- (CMTime)videoTransitionDuration:(FXVideoDescribe *)videoDescribe
                              pre:(BOOL)pre
{
    for (FXTransitionDescribe *transition in self.timelineDescribe.transitionArray) {
        if (pre) {
            if (transition.preVideoIndex == videoDescribe.videoIndex) {
                return transition.preDuration;
            }
        }
        else{
            if (transition.backVideoIndex == videoDescribe.videoIndex) {
                return transition.backDuration;
            }
        }
    }
    return kCMTimeZero;
}

- (void)addTransitionItemPreIndex:(NSInteger)preIndex
                        backIndex:(NSInteger)backIndex
                        transType:(FXTransType)transType{
    FXTransitionDescribe *transition = [FXTransitionDescribe new];
    transition.duration = CMTimeMake(1200, 600);
    transition.preDuration = CMTimeMultiplyByFloat64(transition.duration, 0.5);
    transition.backDuration = CMTimeMultiplyByFloat64(transition.duration, 0.5);
    transition.startTime = kCMTimeZero;
    transition.transType = transType;
    transition.preVideoIndex = preIndex;
    transition.backVideoIndex = backIndex;
    [self.timelineDescribe.transitionArray addObject:transition];
    [self reArrangementItems];
}

- (void)changeTransitionItemPreIndex:(NSInteger)preIndex
                        backIndex:(NSInteger)backIndex
                         duration:(CMTime)duration
                        transType:(FXTransType)transType{
    BOOL found = NO;
    for (int i = 0; i < self.timelineDescribe.transitionArray.count; i++) {
        FXTransitionDescribe *transition = [self.timelineDescribe.transitionArray objectOrNilAtIndex:i];
        if (transition.preVideoIndex == preIndex && transition.backVideoIndex == backIndex) {
            found = YES;
            if (transType == FXTransTypeNone) {
                [self.timelineDescribe.transitionArray removeObjectAtIndex:i];
                [self reArrangementItems];
                return;
            }
            else{
                transition.duration = duration;
                transition.preDuration = CMTimeMultiplyByFloat64(transition.duration, 0.5);
                transition.backDuration = CMTimeMultiplyByFloat64(transition.duration, 0.5);
                transition.startTime = kCMTimeZero;
                transition.transType = transType;
                transition.preVideoIndex = preIndex;
                transition.backVideoIndex = backIndex;
                [self reArrangementItems];
            }
        }
    }
    if (!found) {
        [self addTransitionItemPreIndex:preIndex backIndex:backIndex transType:transType];
    }
}

- (FXTransitionDescribe *)transitionItemWithPreIndex:(NSInteger)preIndex
                                           backIndex:(NSInteger)backIndex
{
    for (int i = 0; i < self.timelineDescribe.transitionArray.count; i++) {
        FXTransitionDescribe *transition = [self.timelineDescribe.transitionArray objectOrNilAtIndex:i];
        if (transition.preVideoIndex == preIndex && transition.backVideoIndex == backIndex) {
            return transition;
        }
    }
    return nil;
}

- (void)removeTransitionItemAtVideoIndex:(NSInteger)index {
    for (int i = 0; i < self.timelineDescribe.transitionArray.count; i++) {
        FXTransitionDescribe *transition = [self.timelineDescribe.transitionArray objectOrNilAtIndex:i];
        if (transition.preVideoIndex == index || transition.backVideoIndex == index) {
            [self.timelineDescribe.transitionArray removeObjectAtIndex:i];
        }
    }
}

- (void)divideVideoAtTime:(CMTime)divideTime atIndex:(NSInteger)index {
    FXVideoDescribe *targetVideo = [self.timelineDescribe.videoArray objectOrNilAtIndex:index];

    FXVideoDescribe *preVideo = [targetVideo copyVideoDescribe];
    preVideo.duration = CMTimeSubtract(divideTime, targetVideo.startTime);

    targetVideo.startTime = divideTime;
    targetVideo.duration = CMTimeSubtract(targetVideo.duration, preVideo.duration);

    //计算在资源中的位置
    CMTime newPreDuration = CMTimeMultiplyByFloat64(preVideo.duration,preVideo.scale);
    CMTimeRange preRange = CMTimeRangeMake(targetVideo.sourceRange.start, newPreDuration);
    preVideo.sourceRange = preRange;
    
    CMTime newTargetDuration = CMTimeMultiplyByFloat64(targetVideo.duration,targetVideo.scale);
    targetVideo.sourceRange = CMTimeRangeMake(CMTimeRangeGetEnd(preRange), newTargetDuration);

    [self.timelineDescribe.videoArray insertObject:preVideo atIndex:targetVideo.videoIndex];

    [self reArrangementItems];
}

- (void)changeVideoScale:(CGFloat)scale atIndex:(NSInteger)index {
    FXVideoDescribe *videoDescribe = [self.timelineDescribe.videoArray objectOrNilAtIndex:index];
    videoDescribe.scale = scale;
    [self reArrangementItems];
}

- (void)rotateVideoAngle:(NSInteger)videoIndex {
    FXVideoDescribe *videoDescribe = [self.timelineDescribe.videoArray objectOrNilAtIndex:videoIndex];
    [videoDescribe rotaToNextAnale];
}

- (void)reArrangementItems {
    //重新排序
    NSInteger i = 0;
    CMTime courseTime = kCMTimeZero;
    for (FXVideoDescribe *videoDescribe in self.timelineDescribe.videoArray) {
        videoDescribe.startTime = courseTime;
        courseTime = CMTimeAdd(courseTime, videoDescribe.duration);
        videoDescribe.videoIndex = i;
        
        FXTransitionDescribe *preTransitionDes = [self transitionItemWithPreIndex:i backIndex:i + 1];
        if (preTransitionDes) {
            courseTime = CMTimeSubtract(courseTime, preTransitionDes.duration);
        }
        i++;
    }
    self.timelineDescribe.duration = courseTime;
}

- (void)setAudioVolume:(CGFloat)volume
{
    self.timelineDescribe.mainVideoVolume = volume;
}

- (void)setVideoPictureSize:(FXPictureSize)psize
{
    self.timelineDescribe.pictureSize = psize;
    FXVideoDescribe *video = self.timelineDescribe.videoArray.firstObject;
    CGSize original = video.videoItem.videoTrack.naturalSize;
    CGFloat whPer = 16.0/9.0;
    if (psize == FXPictureSizeDefult) {
        self.timelineDescribe.defaultNaturalSize = original;
        return;
    }
    else if (psize == FXPictureSize9X16){
        whPer = 9.0/16.0;
    }
    else if (psize == FXPictureSize3X4){
        whPer = 3.0/4.0;
    }
    else if (psize == FXPictureSize1X1){
        whPer = 1.0;
    }
    else if (psize == FXPictureSize4X3){
        whPer = 4.0/3.0;
    }
    else if (psize == FXPictureSize16X9){
        whPer = 16.0/9.0;
    }
    CGFloat videowhPer = original.width/original.height;
    if (videowhPer < whPer) {
        //高度固定了
        CGFloat width = whPer * original.height;
        self.timelineDescribe.defaultNaturalSize = CGSizeMake(width, original.height);

    }
    else{
        CGFloat height = original.width/whPer;
        self.timelineDescribe.defaultNaturalSize = CGSizeMake(original.width, height);
    }
    
}

- (void)changeFilterTypeAtIndex:(NSInteger)videoIndex
                         filter:(FXFilterDescribeType)type
{
    FXVideoDescribe *videoDescribe = [self.timelineDescribe.videoArray objectOrNilAtIndex:videoIndex];
    videoDescribe.filterType = type;
}

- (void)cropVideo:(FXVideoDescribe *)video
          leftPer:(CGFloat)left
         rightper:(CGFloat)right
{
    NSAssert(left < right, @"开始时间不能大于结束时间");
    Float64 totalTime = CMTimeGetSeconds(video.duration);
    CGFloat start = totalTime * left;
    CGFloat end = totalTime * right;
    CMTime startTime = CMTimeMakeWithSeconds(start, 600);
    CMTime duration = CMTimeMakeWithSeconds(end - start, 600);
    video.duration = duration;
    CMTimeRange sourceRange = CMTimeRangeMake(CMTimeAdd(video.sourceRange.start, startTime), duration);
    video.sourceRange = sourceRange;
}

@end
