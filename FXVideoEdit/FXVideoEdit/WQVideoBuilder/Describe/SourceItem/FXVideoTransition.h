//
//  FXVideoTransition.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/27.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FXAVTransitionType) {
    kTransitionTypeNone = 0,
    kTransitionTypePushHorizontalSpinFromRight = 1,
    kTransitionTypePushHorizontalFromRight,
    kTransitionTypePushHorizontalFromLeft,
    kTransitionTypePushVerticalFromBottom,
    kTransitionTypePushVerticalFromTop,
    kTransitionTypeCrossFade, //溶解
    kTransitionTypeCropRectangle, //向四角擦除
    kTransitionTypeMiddleTransform, //从四边向中间消失
    kTransitionTypeLeftAndRightToMiddleTransform, //左右到中间合成
    kTransitionTypeUpAndDownToMiddleTransform, //上下到中间合成
    kTransitionTypeLeftAndRightToMiddleInUpDownTransform, //上下各一半左右到中间合成
    kTransitionTypeMultiLeftRightToMiddleInUpDownTransform, //上下多个条，左右到中间合成
    kTransitionTypeUpAndDownToMiddleInLeftRightTransform, //左右各一半上下到中间合成
    kTransitionTypeUpDownLeftAndRightToMiddleTransform, //上下左右角到中间合成
    kTransitionTypeFadeInAndFadeOut, //淡入淡出
};

@interface FXVideoTransition : NSObject

+ (id)videoTransition;

+ (id)disolveTransitionWithDuration:(CMTime)duration;

@property (nonatomic) FXAVTransitionType type;

@property (nonatomic) CMTimeRange timeRange;

@property (nonatomic) CMTime duration; //持续时间

@end