//
//  FXVideoModeifyParameterCropSubTypeViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/11.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoDescribe.h"
#import "FXViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoModeifyParameterCropSubTypeViewController : FXViewController

@property (nonatomic, copy) void (^doneBlock)(CGFloat left, CGFloat rigtht);

@property (nonatomic, copy) void (^MoveBlock)(CGFloat percent);

+ (FXVideoModeifyParameterCropSubTypeViewController *)videoModeifyParameterCropSubTypeViewControllerWithVideoDescribe:(FXVideoDescribe *)videoDescribe;

@end

NS_ASSUME_NONNULL_END
