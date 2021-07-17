//
//  FXNVideoTrimView.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/4.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FXNVideoTrimView;

@protocol FXNVideoTrimViewDelegate <NSObject>

@required

- (UIImage *)trimViewImageForTime:(CMTime)time;

@optional

- (void)videoTrimViewTapInTrimView:(FXNVideoTrimView *)trimView;

- (void)videoAddButtonClickInTrimView:(FXNVideoTrimView *)trimView;

@end

@interface FXNVideoTrimView : UIView

- (void)setDelegate:(nullable id<FXNVideoTrimViewDelegate>)delegate timeRange:(CMTimeRange)timeRange;

@end

NS_ASSUME_NONNULL_END