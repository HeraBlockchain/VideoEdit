//
//  FXNVideoTrimView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/4.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXNVideoTrimView.h"
#import "UIView+Yoga.h"

@interface FXNVideoTrimView ()

@property (nonatomic, assign) CMTime startTime;

@property (nonatomic, assign) CMTime durationTime;

@property (nonatomic, weak) id<FXNVideoTrimViewDelegate> delegate;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation FXNVideoTrimView

#pragma mark 对外
- (void)setDelegate:(id<FXNVideoTrimViewDelegate>)delegate timeRange:(CMTimeRange)timeRange {
    _durationTime = timeRange.duration;
    _startTime = timeRange.start;
    _delegate = delegate;
    [self setNeedsLayout];
}
#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        _containerView = [UIView new];
        _containerView.layer.masksToBounds = YES;
        [_containerView configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
            layout.isEnabled = YES;
            layout.flexDirection = YGFlexDirectionRow;
            layout.width = YGPercentValue(100);
            layout.height = YGPercentValue(100);
        }];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.containerView.superview);
        }];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self p_resetUI];
}

#pragma mark -

#pragma mark 逻辑
- (void)p_resetUI {
    {
        [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    if (self.bounds.size.height == 0) {
        return;
    }

    {
        Float64 durationSeconds = CMTimeGetSeconds(_durationTime);
        CGFloat width = CGRectGetWidth(self.frame);
        Float64 timePerWidth = durationSeconds / width;
        int num = (int)(width / self.bounds.size.height) + 1;
        CMTime start = _startTime;
        for (int i = 0; i < num; i++) {
            if (_delegate && [_delegate respondsToSelector:@selector(trimViewImageForTime:)]) {
                UIImageView *imageVIew = UIImageView.new;
                imageVIew.image = [_delegate trimViewImageForTime:start];
                [_containerView addSubview:imageVIew];
                [imageVIew configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                    layout.isEnabled = YES;
                    layout.height = YGPercentValue(100);
                    layout.aspectRatio = 1.0;
                }];
            }
            start = CMTimeAdd(start, CMTimeMake(timePerWidth * 60 * 600, 600));
        }
    }

    {
        [_containerView.yoga applyLayoutPreservingOrigin:YES];
    }
}
#pragma mark -

@end