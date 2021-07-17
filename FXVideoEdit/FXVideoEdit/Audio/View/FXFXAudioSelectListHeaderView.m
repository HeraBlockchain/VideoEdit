//
//  FXFXAudioSelectListHeaderView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXFXAudioSelectListHeaderView.h"

@interface FXFXAudioSelectListHeaderView ()

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation FXFXAudioSelectListHeaderView

#pragma mark 对外
- (void)setAudioListEditing:(BOOL)audioListEditing {
    _audioListEditing = audioListEditing;
    [_leftButton setTitle:_audioListEditing ? @"取消" : @"编辑" forState:UIControlStateNormal];
    _rightButton.hidden = !_audioListEditing;
}

- (void)setChooseAll:(BOOL)chooseAll {
    _chooseAll = chooseAll;
    [_rightButton setTitle:_chooseAll ? @"取消全选" : @"全选" forState:UIControlStateNormal];
}
#pragma mark -

#pragma mark UITableViewHeaderFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        {
            self.contentView.backgroundColor = [UIColor colorWithRGBA:0x181818FF];
        }

        __weak typeof(self) weakSelf = self;
        {
            _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_leftButton addBlockForControlEvents:UIControlEventTouchUpInside
                                            block:^(id _Nonnull sender) {
                                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(clickLeftButtonInAudioSelectListHeaderView:)]) {
                                                    [weakSelf.delegate clickLeftButtonInAudioSelectListHeaderView:weakSelf];
                                                }
                                            }];
            [_leftButton setTitleColor:[UIColor colorWithRGBA:0x999DA4FF] forState:UIControlStateNormal];
            _leftButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 20 : 14];
            [self.contentView addSubview:_leftButton];
            [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.leftButton.superview);
                make.left.equalTo(weakSelf.leftButton.superview).offset(IS_IPAD ? 20 : 16);
            }];
        }

        {
            _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_rightButton addBlockForControlEvents:UIControlEventTouchUpInside
                                             block:^(id _Nonnull sender) {
                                                 if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(clickRightButtonInAudioSelectListHeaderView:)]) {
                                                     [weakSelf.delegate clickRightButtonInAudioSelectListHeaderView:weakSelf];
                                                 }
                                             }];
            [_rightButton setTitleColor:[UIColor colorWithRGBA:0x999DA4FF] forState:UIControlStateNormal];
            _rightButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 20 : 14];
            [self.contentView addSubview:_rightButton];
            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.rightButton.superview);
                make.right.equalTo(weakSelf.rightButton.superview).offset(IS_IPAD ? -20 : -16);
            }];
        }
    }

    return self;
}
#pragma mark -

@end