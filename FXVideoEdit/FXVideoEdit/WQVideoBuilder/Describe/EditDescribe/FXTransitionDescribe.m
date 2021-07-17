//
//  FXTransitionDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTransitionDescribe.h"

@implementation FXTransitionDescribe

- (instancetype)init {
    self = [super init];
    if (self) {
        self.desType = FXDescribeTypeTransition;
        self.transType = FXTransTypeSwipeTransition;
    }
    return self;
}

- (NSDictionary *)objectDictionary {
    NSDictionary *dic = [super objectDictionary];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:@(_transType).stringValue forKey:@"transType"];
    [dictionary setObject:@(_preVideoIndex).stringValue forKey:@"preVideoIndex"];
    [dictionary setObject:@(_backVideoIndex).stringValue forKey:@"backVideoIndex"];

    return dictionary;
}

- (void)setObjectWithDic:(NSDictionary *)dic {
    [super setObjectWithDic:dic];
    _transType = [dic integerValueForKey:@"transType" default:0];
    _preVideoIndex = [dic integerValueForKey:@"preVideoIndex" default:0];
    _backVideoIndex = [dic integerValueForKey:@"backVideoIndex" default:0];
}

+ (CIFilter *)filterWithType:(FXTransType)transType
{
    NSString *filtername = nil;
    switch (transType) {
        case FXTransTypeNone:
            filtername = nil;
            break;
        case FXTransTypeAccordionFoldTransition:
            filtername = @"CIAccordionFoldTransition";
            break;
        case FXTransTypeBarsSwipeTransition:
            filtername = @"CIBarsSwipeTransition";
            break;
        case FXTransTypeCopyMachineTransition:
            filtername = @"CICopyMachineTransition";
            break;
        case FXTransTypeDisintegrateWithMaskTransition:
            filtername = @"CIDisintegrateWithMaskTransition";
            break;
        case FXTransTypeDissolveTransition:
            filtername = @"CIDissolveTransition";
            break;
        case FXTransTypeFlashTransition:
            filtername = @"CIFlashTransition";
            break;
        case FXTransTypeModTransition:
            filtername = @"CIModTransition";
            break;
        case FXTransTypePageCurlTransition:
            filtername = @"CIPageCurlTransition";
            break;
        case FXTransTypePageCurlWithShadowTransition:
            filtername = @"CIPageCurlWithShadowTransition";
            break;
        case FXTransTypeRippleTransition:
            filtername = @"CIRippleTransition";
            break;
        case FXTransTypeSwipeTransition:
            filtername = @"CISwipeTransition";
            break;
    }
    if (!filtername) {
        return nil;
    }
    CIFilter *filter = [CIFilter filterWithName:filtername];
    return filter;
}


+ (NSString *)transitionNameWithType:(FXTransType)transType{
    NSDictionary *map = @{
        @(FXTransTypeNone):@"无",
        @(FXTransTypeAccordionFoldTransition):@"手风琴褶皱",
        @(FXTransTypeBarsSwipeTransition):@"栅栏滑动",
        @(FXTransTypeCopyMachineTransition):@"复印机",
        @(FXTransTypeDisintegrateWithMaskTransition):@"面具瓦解",
        @(FXTransTypeDissolveTransition):@"溶解",
        @(FXTransTypeFlashTransition):@"闪光",
        @(FXTransTypeModTransition):@"现代",
        @(FXTransTypePageCurlTransition):@"翻页",
        @(FXTransTypePageCurlWithShadowTransition):@"阴影翻页",
        @(FXTransTypeRippleTransition):@"波纹",
        @(FXTransTypeSwipeTransition):@"擦除",
    };
    return map[@(transType)];
}

@end
