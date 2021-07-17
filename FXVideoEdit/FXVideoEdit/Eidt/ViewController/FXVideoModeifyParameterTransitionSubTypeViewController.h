//
//  FXTransitionViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTransitionDescribe.h"
#import "FXViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoModeifyParameterTransitionSubTypeViewController : FXViewController

@property (nonatomic, copy) void (^transitionSelectedBlock)(FXTransType transType);

@end

NS_ASSUME_NONNULL_END