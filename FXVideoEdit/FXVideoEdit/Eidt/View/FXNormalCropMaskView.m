//
//  FXNormalCropMaskView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/11.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXNormalCropMaskView.h"

@interface FXNormalCropMaskView ()

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIView *rightView;

@end

@implementation FXNormalCropMaskView

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            _edgeInsets = IS_IPAD ? UIEdgeInsetsMake(2, 10, 2, 10) : UIEdgeInsetsMake(2, 10, 2, 10);
            _right = 0;
            _left = 0;
        }

        __weak typeof(self) weakSelf = self;
        {
            _leftView = UIView.new;
            UIPanGestureRecognizer *panGestureRecognizer = [UIPanGestureRecognizer.alloc initWithActionBlock:^(UIPanGestureRecognizer *_Nonnull sender) {
                CGPoint point = [sender locationInView:weakSelf];
                point.x = MAX(point.x, 0);
                point.x = MIN(point.x, weakSelf.bounds.size.width - weakSelf.edgeInsets.right - weakSelf.edgeInsets.left - weakSelf.right);
                if (weakSelf.left != point.x) {
                    weakSelf.left = point.x;
                    [weakSelf setNeedsUpdateConstraints];
                    [weakSelf setNeedsDisplay];
                    if (weakSelf.MoveBlock) {
                        weakSelf.MoveBlock(weakSelf.left/weakSelf.bounds.size.width);
                    }
                }
            }];
            [_leftView addGestureRecognizer:panGestureRecognizer];
            _leftView.backgroundColor = UIColor.clearColor;
            [self addSubview:_leftView];
            [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_leftView.superview);
                make.width.mas_equalTo(_edgeInsets.left);
                make.height.equalTo(_leftView.superview);
            }];

            UIView *lineView = UIView.new;
            lineView.backgroundColor = UIColor.whiteColor;
            [_leftView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(lineView.superview);
                make.size.mas_equalTo(IS_IPAD ? CGSizeMake(2, 14) : CGSizeMake(2, 14));
            }];
        }

        {
            self.backgroundColor = UIColor.clearColor;
        }

        {
            _rightView = UIView.new;
            UIPanGestureRecognizer *panGestureRecognizer = [UIPanGestureRecognizer.alloc initWithActionBlock:^(UIPanGestureRecognizer *_Nonnull sender) {
                CGPoint point = [sender locationInView:weakSelf];
                point.x = weakSelf.bounds.size.width - point.x;
                point.x = MAX(point.x, 0);
                point.x = MIN(point.x, weakSelf.bounds.size.width - weakSelf.edgeInsets.right - weakSelf.edgeInsets.left - weakSelf.left);
                if (weakSelf.right != point.x) {
                    weakSelf.right = point.x;
                    [weakSelf setNeedsUpdateConstraints];
                    [weakSelf setNeedsDisplay];
                    if (weakSelf.MoveBlock) {
                        weakSelf.MoveBlock(weakSelf.right/weakSelf.bounds.size.width);
                    }
                }
            }];
            [_rightView addGestureRecognizer:panGestureRecognizer];
            _rightView.backgroundColor = UIColor.clearColor;
            [self addSubview:_rightView];
            [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_rightView.superview);
                make.width.mas_equalTo(_edgeInsets.right);
                make.height.equalTo(_rightView.superview);
            }];

            UIView *lineView = UIView.new;
            lineView.backgroundColor = UIColor.whiteColor;
            [_rightView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(lineView.superview);
                make.size.mas_equalTo(IS_IPAD ? CGSizeMake(2, 14) : CGSizeMake(2, 14));
            }];
        }
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIColor colorWithRGBA:0xF54184FF] setFill];

    CGRect bounds = self.bounds;
    bounds.origin.x = _left;
    bounds.size.width -= (_left + _right);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.layer.cornerRadius];
    [bezierPath appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectInset(bounds, _edgeInsets.left, _edgeInsets.top) cornerRadius:2]];
    bezierPath.usesEvenOddFillRule = YES;
    [bezierPath fill];
}

- (void)updateConstraints {
    [super updateConstraints];
    [_leftView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftView.superview.mas_left).offset(_left + _edgeInsets.left / 2);
    }];

    [_rightView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rightView.superview.mas_right).offset(-1 * (_right + _edgeInsets.right / 2));
    }];
}

#pragma mark -
@end
