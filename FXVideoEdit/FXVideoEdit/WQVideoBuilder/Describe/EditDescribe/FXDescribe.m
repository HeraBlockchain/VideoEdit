//
//  FXDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXDescribe.h"

@implementation FXDescribe

- (instancetype)init {
    self = [super init];
    if (self) {
        _startTime = kCMTimeInvalid;
        _duration = kCMTimeInvalid;
        _desType = FXDescribeTypeNone;
        _scale = 1.0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;

    CMTime newDuration = CMTimeMultiplyByFloat64(self.sourceRange.duration, 1.0 / scale);
    self.duration = newDuration;
}

- (NSString *)valueForTime:(CMTime)time {
    Float64 floatTime = CMTimeGetSeconds(time);
    return @(floatTime).stringValue;
}

- (CMTime)timeWithDouble:(double)time {
    return CMTimeMakeWithSeconds(time, 600);
}

- (NSDictionary *)objectDictionary {
    NSDictionary *dict = @{@"startTime": [self valueForTime:_startTime],
                           @"duration": [self valueForTime:_duration],
                           @"sourceRangeStart": [self valueForTime:_sourceRange.start],
                           @"sourceRangeDuration": [self valueForTime:_sourceRange.duration],
                           @"desType": @(_desType),
                           @"scale": @(_scale)};
    return dict;
}

- (void)setObjectWithDic:(NSDictionary *)dic {
    _startTime = [self timeWithDouble:[dic doubleValueForKey:@"startTime" default:0]];
    _duration = [self timeWithDouble:[dic doubleValueForKey:@"duration" default:0]];
    CMTime sourceStart = [self timeWithDouble:[dic doubleValueForKey:@"sourceRangeStart" default:0]];
    CMTime sourceDuration = [self timeWithDouble:[dic doubleValueForKey:@"sourceRangeDuration" default:0]];
    _sourceRange = CMTimeRangeMake(sourceStart, sourceDuration);
    _desType = [dic integerValueForKey:@"desType" default:0];
    _scale = [dic floatValueForKey:@"scale" default:1.0];
}

@end
