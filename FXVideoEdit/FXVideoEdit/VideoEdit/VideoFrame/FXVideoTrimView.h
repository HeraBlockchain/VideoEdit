//
//  FXVideoTrimView.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/16.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXVideoTrimView;

@protocol FXVideoTrimViewDelegate <NSObject>

@required

- (UIImage *)trimViewImageForTime:(CMTime)time;

@optional

- (void)videoTrimViewTap:(FXVideoTrimView *)trimView;

- (void)videoAddButtonClick:(FXVideoTrimView *)trimView;

@end

@interface FXVideoTrimView : UIView

@property (nonatomic, weak) id<FXVideoTrimViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame timeRange:(CMTimeRange)timeRange;

- (void)reloadAllSubViews;

@end