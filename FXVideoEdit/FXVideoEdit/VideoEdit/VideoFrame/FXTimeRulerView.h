//
//  FXTimeRulerView.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/16.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXTimeRulerView : UIView

- (instancetype)initWithFrame:(CGRect)frame widthPerSecond:(CGFloat)width themeColor:(UIColor *)color totalTime:(Float64)timeInterval;

@end