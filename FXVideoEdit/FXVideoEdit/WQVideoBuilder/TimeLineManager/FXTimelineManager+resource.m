//
//  FXTimelineManager+resource.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager+resource.h"

@implementation FXTimelineManager (resource)

- (void)addSource:(FXSourceItem *)item type:(FXDescribeType)type {
    if (type == FXDescribeTypeVideo) {
        [self.videoSourceArray addObject:item];
    } else if (type == FXDescribeTypeAudio) {
        [self.audioSourceArray addObject:item];
    }
}

- (FXSourceItem *)sourceItemWithtype:(FXDescribeType)type sourceUrl:(NSString *)url {
    if (type == FXDescribeTypeVideo) {
        for (FXVideoItem *videoItem in self.videoSourceArray) {
            if ([videoItem.urlString isEqualToString:url]) {
                return videoItem;
            }
        }
    } else if (type == FXDescribeTypeAudio) {
        for (FXAudioItem *audioItem in self.audioSourceArray) {
            if ([audioItem.urlString isEqualToString:url]) {
                return audioItem;
            }
        }
    }
    return nil;
}

@end