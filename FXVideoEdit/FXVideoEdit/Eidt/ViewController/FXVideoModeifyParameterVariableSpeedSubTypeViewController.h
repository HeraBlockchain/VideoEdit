//
//  FXVideoModeifyParameterVariableSpeedSubTypeViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoModeifyParameterVariableSpeedSubTypeViewController : FXViewController

@property (nonatomic, copy) void (^variableSpeedBlock)(CGFloat variableSpeed);

@end

NS_ASSUME_NONNULL_END