//
//  FXVideoModeifyParameterFilterSubTypeViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXFilterDescribe.h"
#import "FXViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoModeifyParameterFilterSubTypeViewController : FXViewController

@property (nonatomic, copy) void (^filterSelectedBlock)(FXFilterDescribeType filterType);

@property (nonatomic, assign) NSInteger selectedVideoIndex;

@end

NS_ASSUME_NONNULL_END
