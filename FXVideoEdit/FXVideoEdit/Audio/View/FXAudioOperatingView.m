//
//  FXAudioOperatingView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioOperatingView.h"

@interface FXAudioOperatingView ()

@property (nonatomic, strong) QMUIButton *deleteButton;

@property (nonatomic, strong) QMUIButton *shareButton;

@end

@implementation FXAudioOperatingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;
        {
            _shareButton = [QMUIButton new];
            [_shareButton setImage:[UIImage imageNamed:@"AudioShare"] forState:UIControlStateNormal];
            [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
            [_shareButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            _shareButton.imagePosition = QMUIButtonImagePositionTop;
            _shareButton.spacingBetweenImageAndTitle = 8;
            _shareButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 18 : 8];
            [_shareButton addBlockForControlEvents:UIControlEventTouchUpInside
                                             block:^(id _Nonnull sender) {
                                                 weakSelf.clickShareBlock();
                                             }];
            [self addSubview:_shareButton];
            [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.shareButton.superview).offset(-20);
                make.right.equalTo(weakSelf.shareButton.superview.mas_centerX).offset(-30);
            }];
        }

        {
            _deleteButton = [QMUIButton new];
            [_deleteButton setImage:[UIImage imageNamed:@"AudioDelete"] forState:UIControlStateNormal];
            [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            [_deleteButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            _deleteButton.imagePosition = _shareButton.imagePosition;
            _deleteButton.spacingBetweenImageAndTitle = _shareButton.spacingBetweenImageAndTitle;
            _deleteButton.titleLabel.font = _shareButton.titleLabel.font;
            [_deleteButton addBlockForControlEvents:UIControlEventTouchUpInside
                                              block:^(id _Nonnull sender) {
                                                  weakSelf.clickDeleteBlock();
                                              }];
            [self addSubview:_deleteButton];
            [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.shareButton);
                make.left.equalTo(weakSelf.shareButton.superview.mas_centerX).offset(30);
            }];
        }
    }

    return self;
}

@end