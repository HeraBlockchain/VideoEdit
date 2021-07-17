//
//  FXTitleInputView.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/15.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXPlayerViewController;
@class FXTitleDescribe;
@class HFDraggableView;

@interface FXTitleInputView : UIView

@property (nonatomic, copy) void (^doneButtonActionBlock)(NSString *text);

@property (nonatomic, assign) CGFloat currentPercent;

@property (nonatomic, copy) NSString *inputText;;

- (instancetype)initWithDraggableView:(HFDraggableView *)dragView
                        titleDescribe:(FXTitleDescribe *)titleDescribe;

- (void)inputViewShow;

- (void)inputViewHiden;

- (void)setHoldViewController:(FXPlayerViewController *)holdViewController;


@end
