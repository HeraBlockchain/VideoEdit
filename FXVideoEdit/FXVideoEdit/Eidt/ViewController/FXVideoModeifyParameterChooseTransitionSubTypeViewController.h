//
//  FXVideoModeifyParameterChooseTransitionSubTypeViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoModeifyParameterChooseTransitionSubTypeViewController : FXViewController

@property (nonatomic, copy, nullable) void (^addNewVideoBlock)(void);

@property (nonatomic, copy, nullable) void (^addTransitionBlock)(void);

@end

NS_ASSUME_NONNULL_END