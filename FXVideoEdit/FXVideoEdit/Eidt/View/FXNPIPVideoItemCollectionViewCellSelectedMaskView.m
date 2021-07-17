//
//  FXNPIPVideoItemCollectionViewCellSelectedMaskView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXNPIPVideoItemCollectionViewCellSelectedMaskView.h"

@implementation FXNPIPVideoItemCollectionViewCellSelectedMaskView

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            UIView *leftLineView = UIView.new;
            leftLineView.backgroundColor = UIColor.whiteColor;
            [self addSubview:leftLineView];
            [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(leftLineView.superview);
                make.width.mas_equalTo(2);
                make.height.equalTo(leftLineView.superview).multipliedBy(0.5);
                make.centerX.equalTo(leftLineView.superview.mas_left).offset(4);
            }];
        }

        {
            self.backgroundColor = UIColor.clearColor;
        }

        {
            UIView *rightLineView = UIView.new;
            rightLineView.backgroundColor = UIColor.whiteColor;
            [self addSubview:rightLineView];
            [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(rightLineView.superview);
                make.width.mas_equalTo(2);
                make.height.equalTo(rightLineView.superview).multipliedBy(0.5);
                make.centerX.equalTo(rightLineView.superview.mas_right).offset(-4);
            }];
        }
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIColor colorWithRGBA:0xF54184FF] setFill];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius];
    [bezierPath appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 8, 1) cornerRadius:4]];
    bezierPath.usesEvenOddFillRule = YES;
    [bezierPath fill];
}
#pragma mark -

@end