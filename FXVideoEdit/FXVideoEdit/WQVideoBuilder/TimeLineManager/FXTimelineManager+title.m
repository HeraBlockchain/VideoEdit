//
//  FXTimelineManager+title.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager+title.h"
#import "FXTitleDescribe.h"

@implementation FXTimelineManager (title)

- (void)addTitleWithTitle:(FXTitleDescribe *)titleDescribe{
    [self.timelineDescribe.titleArray addObject:titleDescribe];
    [self reArrangementTitleDescribe];
}

- (void)removeTitleAtIndex:(NSInteger)index
{
    [self.timelineDescribe.titleArray removeObjectAtIndex:index];
    [self reArrangementTitleDescribe];
}


- (void)reArrangementTitleDescribe
{
    NSInteger index = 0;
    for (FXTitleDescribe *titleDescribe in self.timelineDescribe.titleArray) {
        titleDescribe.titleIndex = index;
        index++;
    }
}

- (NSArray *)titleArrayWithVideoDescribe:(FXVideoDescribe *)videoDescribe
{
    NSMutableArray *array = [NSMutableArray new];
    CMTimeRange videoRange = CMTimeRangeMake(videoDescribe.startTime, videoDescribe.duration);
    for (FXTitleDescribe *titleDescribe in self.timelineDescribe.titleArray) {
        CMTimeRange titleRange = CMTimeRangeMake(titleDescribe.startTime, titleDescribe.duration);
        CMTimeRange unionRange = CMTimeRangeGetIntersection(videoRange, titleRange);
        if (!CMTIMERANGE_IS_EMPTY(unionRange)) {
            [array addObject:titleDescribe];
        }
    }
    return array;
}



@end
