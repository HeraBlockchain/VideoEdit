//
//  FXFXVideoModeifyParameterEditTypeViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineDescribe.h"
#import "FXViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoModeifyParameterSortSubTypeViewController : FXViewController

@property (nonatomic, copy) void (^SortDoneBlock)(BOOL hasEdit);

+ (FXVideoModeifyParameterSortSubTypeViewController *)videoModeifyParameterSortSubTypeViewControllerWithDataModel:(FXTimelineDescribe *)dataModel;

@end

NS_ASSUME_NONNULL_END
