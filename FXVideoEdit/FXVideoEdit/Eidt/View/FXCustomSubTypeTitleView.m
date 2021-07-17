//
//  FXCustomSubTypeTitleView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXCustomSubTypeTitleView.h"

@interface FXCustomSubTypeTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FXCustomSubTypeTitleView

#pragma mark 对外
- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (NSString *)title {
    return _titleLabel.text;
}

+ (CGFloat)heightOfCustomSubTypeTitleView {
    return IS_IPAD ? 60 : 42;
}
#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        {
            _titleLabel = [UILabel new];
            _titleLabel.textColor = UIColor.whiteColor;
            _titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 20 : 14];
            [self addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(weakSelf.titleLabel.superview);
                make.size.lessThanOrEqualTo(weakSelf.titleLabel.superview);
            }];
        }

        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
            [button addBlockForControlEvents:UIControlEventTouchUpInside
                                       block:^(id _Nonnull sender) {
                                           if (weakSelf.closeButtonActionBlock) {
                                               weakSelf.closeButtonActionBlock();
                                           }
                                       }];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(button.superview);
                make.left.equalTo(button.superview).offset(IS_IPAD ? 20 : 16);
            }];
        }

        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"确定"] forState:UIControlStateNormal];
            [button addBlockForControlEvents:UIControlEventTouchUpInside
                                       block:^(id _Nonnull sender) {
                                           if (weakSelf.doneButtonActionBlock) {
                                               weakSelf.doneButtonActionBlock();
                                           }
                                       }];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(button.superview);
                make.right.equalTo(button.superview).offset(IS_IPAD ? -20 : -16);
            }];
        }
    }

    return self;
}
#pragma mark -

@end