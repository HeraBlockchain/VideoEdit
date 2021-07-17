//
//  FXVideoControl.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoControl.h"
#import "NSString+FXExpand.h"

@interface FXVideoControl ()

@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) UIButton *centerButton;

@property (nonatomic, strong) UIButton *undoButton;

@property (nonatomic, strong) UIButton *redoButton;

@property (nonatomic, strong) UIProgressView *playProgressView;

@end

@implementation FXVideoControl

#pragma mark 对外
- (void)setRedoButtonEnabled:(BOOL)redoButtonEnabled {
    _redoButton.enabled = redoButtonEnabled;
}

- (BOOL)redoButtonEnabled {
    return _redoButton.enabled;
}

- (void)setUndoButtonEnabled:(BOOL)undoButtonEnabled {
    _undoButton.enabled = undoButtonEnabled;
}

- (BOOL)undoButtonEnabled {
    return _undoButton.enabled;
}

- (void)setDuration:(NSTimeInterval)duration totalDuration:(NSTimeInterval)totalDuration {
    _durationLabel.text = [NSString stringWithFormat:@"%@/%@", [NSString fx_stringWithVideoDuration:duration], [NSString fx_stringWithVideoDuration:totalDuration]];
    if (totalDuration > 0) {
        [_playProgressView setProgress:MAX(MIN(duration / totalDuration, 1.0), 0.0)];
    } else {
        [_playProgressView setProgress:0.0];
    }
}

#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;

        {
            _playProgressView = [UIProgressView new];
            [_playProgressView setProgress:0.0];
            [self addSubview:_playProgressView];
            [_playProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(weakSelf.playProgressView.superview);
            }];
        }

        {
            _durationLabel = [UILabel new];
            _durationLabel.textColor = [UIColor colorWithRGBA:0x999DA4FF];
            _durationLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 19 : 10];
            [self addSubview:_durationLabel];
            [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.durationLabel.superview).offset(IS_IPAD ? 20 : 16);
                make.centerY.equalTo(weakSelf.durationLabel.superview);
                make.right.lessThanOrEqualTo(weakSelf.durationLabel.superview);
            }];
        }

        {
            _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_centerButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
            [_centerButton addBlockForControlEvents:UIControlEventTouchUpInside
                                              block:^(id _Nonnull sender) {
                                                  if (weakSelf.centerButtonActionBlock) {
                                                      weakSelf.centerButtonActionBlock(weakSelf);
                                                  }
                                              }];
            [self addSubview:_centerButton];
            [_centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(weakSelf.centerButton.superview);
            }];
        }

        {
            _redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _redoButton.enabled = NO;
            [_redoButton setImage:[UIImage imageNamed:@"重做"] forState:UIControlStateNormal];
            [_redoButton addBlockForControlEvents:UIControlEventTouchUpInside
                                            block:^(id _Nonnull sender) {
                                                if (weakSelf.redoButtonActionBlock) {
                                                    weakSelf.redoButtonActionBlock(weakSelf);
                                                }
                                            }];
            [self addSubview:_redoButton];
            [_redoButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.redoButton.superview);
                make.right.equalTo(weakSelf.redoButton.superview).offset(IS_IPAD ? -20 : -16);
            }];
        }

        {
            _undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _undoButton.enabled = NO;
            [_undoButton setImage:[UIImage imageNamed:@"撤销"] forState:UIControlStateNormal];
            [_undoButton addBlockForControlEvents:UIControlEventTouchUpInside
                                            block:^(id _Nonnull sender) {
                                                if (weakSelf.undoButtonActionBlock) {
                                                    weakSelf.undoButtonActionBlock(weakSelf);
                                                }
                                            }];
            [self addSubview:_undoButton];
            [_undoButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.redoButton);
                make.right.equalTo(weakSelf.redoButton.mas_left).offset(IS_IPAD ? -40 : -20);
            }];
        }
    }

    return self;
}
#pragma mark -

@end