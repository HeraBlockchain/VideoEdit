//
//  FXVideoModeifyParameterSubtitleSubTypeViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXViewController.h"

@class FXTitleDescribe;

@interface FXVideoModeifyParameterSubtitleSubTypeViewController : FXViewController

@property (nonatomic, copy) void (^selectFontBlock)(NSString *fontName);

@property (nonatomic, copy) void (^selectColorBlock)(UIColor *color);

@property (nonatomic, copy) void (^alphaChangeBlock)(CGFloat alpha);

@property (nonatomic, copy) void (^clickDoneBlock)(UIFont *font, UIColor *color);

@property (nonatomic, strong) FXTitleDescribe *titleDescribe;

@end
