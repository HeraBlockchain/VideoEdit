//
//  FXVideoDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoDescribe.h"
#import "FXTimelineManager.h"

@interface FXVideoDescribe ()

@property (nonatomic, assign) FXRotation rotate;

@end

@implementation FXVideoDescribe

- (instancetype)init {
    self = [super init];
    if (self) {
        self.desType = FXDescribeTypeVideo;
        self.rotate = FXRotationNone;
        _filterType = FXFilterDescribeTypeFade;
    }
    return self;
}

- (FXVideoDescribe *)copyVideoDescribe
{
    FXVideoDescribe *video = [[FXVideoDescribe alloc] init];
    
    video.startTime = self.startTime;
    video.duration = self.duration;
    video.sourceRange = self.sourceRange;
    video.scale = self.scale;
    video.desType = self.desType;

    
    video.videoIndex = self.videoIndex;
    video.reverse = self.reverse;
    video.rotate = self.rotate;
    video.videoItem = self.videoItem;
    video.mute = self.mute;
    video.filterType = self.filterType;
    video.trackID = self.trackID;
    
    return video;
}

- (void)rotaToNextAnale {
    _rotate++;
    if (_rotate > FXRotation270) {
        _rotate = FXRotationNone;
    }
}

- (NSDictionary *)objectDictionary {
    NSDictionary *dic = [super objectDictionary];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:@(_reverse).stringValue forKey:@"reverse"];
    [dictionary setObject:@(_rotate).stringValue forKey:@"rotate"];
    [dictionary setObject:@(_videoIndex).stringValue forKey:@"videoIndex"];
    [dictionary setObject:_videoItem.urlString forKey:@"videoItem"];
    [dictionary setObject:@(_mute).stringValue forKey:@"mute"];
    [dictionary setObject:@(_filterType).stringValue forKey:@"filterType"];
    return dictionary;
}

- (void)setObjectWithDic:(NSDictionary *)dic {
    [super setObjectWithDic:dic];
    _videoIndex = [dic integerValueForKey:@"videoIndex" default:0];
    _reverse = [dic boolValueForKey:@"reverse" default:NO];
    _rotate = [dic intValueForKey:@"rotate" default:0];
    NSString *urlString = [dic stringValueForKey:@"videoItem" default:nil];
    _videoItem = (FXVideoItem *)[[FXTimelineManager sharedInstance] sourceItemWithtype:self.desType sourceUrl:urlString];
    _mute = [dic boolValueForKey:@"mute" default:NO];
    _filterType = [dic intValueForKey:@"filterType" default:0];

}

- (UIImage *)coverImage {
    UIImage *image = [_videoItem trimViewImageForTime:self.sourceRange.start];
    return image;
}

@end
