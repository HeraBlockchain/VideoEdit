//
//  FXFilterDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXFilterDescribe.h"

@implementation FXFilterDescribe

+ (CIFilter *)filterWithType:(FXFilterDescribeType)filterType
{
    NSString *filtername = nil;
    switch (filterType) {
        case FXFilterDescribeTypeNone:
            filtername = nil;
            break;
        case FXFilterDescribeTypeChrome:
            filtername = @"CIPhotoEffectChrome";
            break;
        case FXFilterDescribeTypeFade:
            filtername = @"CIPhotoEffectFade";
            break;
        case FXFilterDescribeTypeInstant:
            filtername = @"CIPhotoEffectInstant";
            break;
        case FXFilterDescribeTypeMono:
            filtername = @"CIPhotoEffectMono";
            break;
        case FXFilterDescribeTypeNoir:
            filtername = @"CIPhotoEffectNoir";
            break;
        case FXFilterDescribeTypeprocess:
            filtername = @"CIPhotoEffectProcess";
            break;
        case FXFilterDescribeTypeTonal:
            filtername = @"CIPhotoEffectTonal";
            break;
        case FXFilterDescribeTypeTransfer:
            filtername = @"CIPhotoEffectTransfer";
            break;
        default:
            break;
    }
    if (!filtername) {
        return nil;
    }
    CIFilter *filter = [CIFilter filterWithName:filtername];
    return filter;
}

+(NSString *)filterNameWithType:(FXFilterDescribeType)type{
    
    NSDictionary *map = @{@(FXFilterDescribeTypeNone):@"原画",
             @(FXFilterDescribeTypeChrome):@"铬黄",
             @(FXFilterDescribeTypeFade):@"褪色",
             @(FXFilterDescribeTypeInstant):@"即时",
             @(FXFilterDescribeTypeMono):@"单色",
             @(FXFilterDescribeTypeNoir):@"黑色",
             @(FXFilterDescribeTypeprocess):@"冲印",
             @(FXFilterDescribeTypeTonal):@"色调",
             @(FXFilterDescribeTypeTransfer):@"转移",
    };
    
    return map[@(type)];
}

@end
