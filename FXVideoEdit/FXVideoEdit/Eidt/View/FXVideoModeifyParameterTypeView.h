//
//  FXVideoModeifyParameterTypeView.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoEditOperationType.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FXVideoModeifyParameterTypeView : UIView

@property (nonatomic, assign, readonly) FXVideoModeifyParameterType type;

@property (nonatomic, copy) void (^clickButtonActionBlock)(FXVideoModeifyParameterTypeView *selfView);

@end

NS_ASSUME_NONNULL_END