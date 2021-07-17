//
//  FXTransitionDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXDescribe.h"

typedef NS_ENUM(NSUInteger, FXTransType) {
    FXTransTypeNone,
    FXTransTypeAccordionFoldTransition,
    FXTransTypeBarsSwipeTransition,
    FXTransTypeCopyMachineTransition,
    FXTransTypeDisintegrateWithMaskTransition,
    FXTransTypeDissolveTransition,
    FXTransTypeFlashTransition,
    FXTransTypeModTransition,
    FXTransTypePageCurlTransition,
    FXTransTypePageCurlWithShadowTransition,
    FXTransTypeRippleTransition,
    FXTransTypeSwipeTransition
};

@interface FXTransitionDescribe : FXDescribe

@property (nonatomic, assign) NSInteger preVideoIndex;

@property (nonatomic, assign) NSInteger backVideoIndex;

@property (nonatomic, assign) CMTime preDuration;

@property (nonatomic, assign) CMTime backDuration;

@property (nonatomic, assign) FXTransType transType;

+ (CIFilter *)filterWithType:(FXTransType)transType;

+ (NSString *)transitionNameWithType:(FXTransType)transType;

@end
