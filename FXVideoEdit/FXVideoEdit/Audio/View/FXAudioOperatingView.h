//
//  FXAudioOperatingView.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXAudioOperatingView : UIView

@property (nonatomic, copy) void (^clickDeleteBlock)(void);

@property (nonatomic, copy) void (^clickShareBlock)(void);

@end

NS_ASSUME_NONNULL_END