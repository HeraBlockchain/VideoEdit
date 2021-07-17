//
//  FXTimelineItemViewModel.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/27.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineItemViewModel.h"
#import "FXDescribe.h"
#import "FXSourceItem.h"
#import "FXVideoDescribe.h"
#import "FXTimelineManager.h"
#import "FXTitleDescribe.h"


@implementation FXTimeLineTitleModel


@end

@interface FXTimelineItemViewModel ()


@end


@implementation FXTimelineItemViewModel

- (id)initWithDescribe:(FXDescribe *)describe {
    return [self initWithDescribe:describe widthScale:LENGTH_TIME_SCALE_MIN];
}

- (id)initWithDescribe:(FXDescribe *)describe
            widthScale:(CGFloat)scale{
    self = [super init];
    if (self) {
        _describe = describe;
        _trackType = FXTrackTypeVideo;
        Float64 time = CMTimeGetSeconds(describe.duration);
        _widthInTimeline = time * scale;
        _minWidthInTimeline = time * LENGTH_TIME_SCALE_MIN;
        _maxWidthInTimeline = time * LENGTH_TIME_SCALE_MAX;
        Float64 startTime = CMTimeGetSeconds(_describe.startTime);
        _positionInTimeline = startTime * LENGTH_TIME_SCALE_MIN;
        if (_describe.desType == FXDescribeTypeTransition) {
            _widthInTimeline = 32;
        }
    }
    return self;
}

- (void)updateTimelineItem:(CGFloat)lengthScale {
    Float64 time = CMTimeGetSeconds(_describe.duration);
    _lengthTimeScale = lengthScale;
    _widthInTimeline = time * lengthScale;
    CMTime startTime = CMTimeMakeWithSeconds(_positionInTimeline / lengthScale, 600);
    _describe.startTime = startTime;
}

- (void)setTitleDescribeArray:(NSArray<FXTitleDescribe *> *)titleDescribeArray
{
    _titleDescribeArray = titleDescribeArray;
    [self layoutTitleSize];
}

- (void)layoutTitleSize
{
    CMTimeRange videoRange = CMTimeRangeMake(self.describe.startTime, self.describe.duration);
    for (FXTitleDescribe *titleDescribe in self.titleDescribeArray) {
        CMTimeRange titleRange = CMTimeRangeMake(titleDescribe.startTime, titleDescribe.duration);
        CMTimeRange unionRange = CMTimeRangeGetIntersection(videoRange, titleRange);
        if (!CMTIMERANGE_IS_EMPTY(unionRange)) {
            CMTime startTime = CMTimeSubtract(unionRange.start, self.describe.startTime);
            Float64 start = CMTimeGetSeconds(startTime);
            Float64 duration = CMTimeGetSeconds(unionRange.duration);
            FXTimeLineTitleModel *location = [FXTimeLineTitleModel new];
            location.position = start*LENGTH_TIME_SCALE_MIN;
            location.width = duration*LENGTH_TIME_SCALE_MIN;
            location.titleDescribe = titleDescribe;
            [self.titleModelArray addObject:location];
        }
    }
}

- (NSMutableArray *)titleModelArray
{
    if (!_titleModelArray) {
        _titleModelArray = [NSMutableArray new];
    }
    return _titleModelArray;;
}


@end
