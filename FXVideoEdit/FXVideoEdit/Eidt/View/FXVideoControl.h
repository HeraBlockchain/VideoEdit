//
//  FXVideoControl.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoControl : UIView

@property (nonatomic, assign) BOOL undoButtonEnabled;

@property (nonatomic, assign) BOOL redoButtonEnabled;

@property (nonatomic, copy, nullable) void (^centerButtonActionBlock)(FXVideoControl *control);

@property (nonatomic, copy, nullable) void (^undoButtonActionBlock)(FXVideoControl *control);

@property (nonatomic, copy, nullable) void (^redoButtonActionBlock)(FXVideoControl *control);

- (void)setDuration:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration;

@end

NS_ASSUME_NONNULL_END