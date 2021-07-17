//
//  NSString+FXExpand.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "NSString+FXExpand.h"

@implementation NSString (FXExpand)

+ (NSString *)fx_stringWithVideoDuration:(NSTimeInterval)timeInterval {
    u_int64_t duration = timeInterval;
    u_int64_t h = duration / (60 * 60);
    u_int64_t m = (duration - h * (60 * 60)) / 60;
    double s = (duration - h * (60 * 60) - m * 60);
    NSMutableString *string = NSMutableString.new;
    if (h > 0) {
        [string appendFormat:@"%@", @(h)];
    }

    if (m > 0) {
        if (string.length > 0) {
            [string appendFormat:@":%02llu", m];
        } else {
            [string appendFormat:@"%02llu", m];
        }
    } else {
    }

    if (s > 0) {
        if (string.length > 0) {
            [string appendFormat:@":%.02f", s];
        } else {
            [string appendFormat:@"00:%.02f", s];
        }
    }

    if (string.length == 0) {
        [string setString:@"0"];
    }

    return string;
}

@end
