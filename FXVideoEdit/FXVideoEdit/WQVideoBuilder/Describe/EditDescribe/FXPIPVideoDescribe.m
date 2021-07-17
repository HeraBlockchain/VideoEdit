//
//  FXPIPVideoDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXPIPVideoDescribe.h"
#import "FXTimelineManager.h"

@implementation FXPIPVideoDescribe

- (instancetype)init {
    self = [super init];
    if (self) {
        self.desType = FXDescribeTypePip;
        _rotateAngle = 0;
        _widthPercent = 0.5;
        _scaleSize = 1.0;
        _centerXP = 0.5;
        _centerYP = 0.5;
        _volume = 1.0;
    }
    return self;
}

- (NSDictionary *)objectDictionary {
    NSDictionary *dic = [super objectDictionary];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:@(_videoIndex).stringValue forKey:@"videoIndex"];
    [dictionary setObject:@(_rotateAngle).stringValue forKey:@"_rotateAngle"];
    [dictionary setObject:_videoItem.urlString forKey:@"videoItem"];
    [dictionary setObject:@(_centerXP).stringValue forKey:@"centerXP"];
    [dictionary setObject:@(_centerYP).stringValue forKey:@"centerYP"];
    [dictionary setObject:@(_widthPercent).stringValue forKey:@"widthPercent"];
    [dictionary setObject:@(_scaleSize).stringValue forKey:@"scaleSize"];
    [dictionary setObject:@(_volume) forKey:@"volume"];
    return dictionary;
}

- (void)setObjectWithDic:(NSDictionary *)dic {
    [super setObjectWithDic:dic];
    _videoIndex = [dic integerValueForKey:@"videoIndex" default:0];
    _rotateAngle = [dic floatValueForKey:@"rotateAngle" default:0];
    NSString *urlString = [dic stringValueForKey:@"videoItem" default:nil];
    _videoItem = (FXVideoItem *)[[FXTimelineManager sharedInstance] sourceItemWithtype:self.desType sourceUrl:urlString];
    _centerXP = [dic floatValueForKey:@"centerXP" default:0.5];
    _centerYP = [dic floatValueForKey:@"centerYP" default:0.5];
    _widthPercent = [dic floatValueForKey:@"widthPercent" default:0.5];
    _scaleSize = [dic floatValueForKey:@"scaleSize" default:0.5];
    _volume = [dic floatValueForKey:@"volume" default:1.0];
}

- (UIImage *)coverImage {
    UIImage *image = [_videoItem trimViewImageForTime:self.sourceRange.start];
    return image;
}

@end
