//
//  FXTimeLineCollectionViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/4.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLineCollectionViewCell.h"

@interface FXTimeLineCollectionViewCell ()

@end

@implementation FXTimeLineCollectionViewCell

#pragma mark 对外
- (CGRect)leftAddButtonFrameInView:(UIView *)view {
    return [_leftAddButton convertRect:_leftAddButton.bounds toView:view];
}

- (CGRect)rightAddButtonFrameInView:(UIView *)view {
    return [_rightAddButton convertRect:_rightAddButton.bounds toView:view];
}

- (void)setLeftButtonOffset:(CGFloat)leftOffset rightButtonOffset:(CGFloat)rightButtonOffset {
    __weak typeof(self) weakSelf = self;
    [_leftAddButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftAddButton.superview.mas_left).offset(leftOffset);
    }];

    [_rightAddButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rightAddButton.superview.mas_right).offset(rightButtonOffset);
    }];
}
#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.clearColor;
        self.layer.masksToBounds = NO;
        self.contentView.layer.masksToBounds = NO;

        __weak typeof(self) weakSelf = self;
        {
            _leftAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_leftAddButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
            _leftAddButton.userInteractionEnabled = NO;
            [self.contentView addSubview:_leftAddButton];
            [_leftAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_leftAddButton.superview);
            }];
        }

        {
            _rightAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_rightAddButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
            _rightAddButton.userInteractionEnabled = NO;
            [self.contentView addSubview:_rightAddButton];
            [_rightAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_rightAddButton.superview);
            }];
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView bringSubviewToFront:_leftAddButton];
    [self.contentView bringSubviewToFront:_rightAddButton];
}

- (void)layoutAddButton
{
    [self.contentView bringSubviewToFront:_leftAddButton];
    [self.contentView bringSubviewToFront:_rightAddButton];
}

#pragma mark -

@end
