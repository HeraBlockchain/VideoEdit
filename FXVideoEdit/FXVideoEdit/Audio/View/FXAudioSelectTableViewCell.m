//
//  FXAudioSelectTableViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioSelectTableViewCell.h"
#import "NSString+FXExpand.h"

@interface FXAudioSelectTableViewCell ()

@property (nonatomic, assign) BOOL audioEditing;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *authorLabel;

@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) UIImageView *selectIcon;

@end

@implementation FXAudioSelectTableViewCell

#pragma mark 对外
+ (NSString *)reuseIdentifierForAudioSelectTableViewCell:(BOOL)audioEditing {
    return [@{@"audioEditing": @(audioEditing)} jsonStringEncoded];
}

- (void)setDataModel:(FXAudioDataModel *)dataModel {
    _dataModel = dataModel;
    _nameLabel.text = _dataModel.name;
    _authorLabel.text = _dataModel.author.length > 0 ? _dataModel.author : @"未知";
    _durationLabel.text = [NSString fx_stringWithVideoDuration:dataModel.duration];
}
#pragma mark -

#pragma mark UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        {
            self.backgroundColor = UIColor.clearColor;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        {
            _audioEditing = [[[reuseIdentifier jsonValueDecoded] objectForKey:@"audioEditing"] boolValue];
        }

        __weak typeof(self) weakSelf = self;
        UIView *backView = [UIView new];
        {
            [self.contentView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(backView.superview);
                make.left.equalTo(backView.superview).offset(weakSelf.audioEditing ? (IS_IPAD ? 72 : 53) : 0);
            }];
        }

        {
            _nameLabel = UILabel.new;
            _nameLabel.textColor = UIColor.whiteColor;
            _nameLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 22 : 16];
            [backView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.nameLabel.superview).offset(IS_IPAD ? 20 : 16);
                make.bottom.equalTo(weakSelf.nameLabel.superview.mas_centerY);
                make.right.lessThanOrEqualTo(weakSelf.nameLabel.superview);
            }];
        }

        {
            _authorLabel = UILabel.new;
            _authorLabel.adjustsFontSizeToFitWidth = YES;
            _authorLabel.textColor = [UIColor colorWithRGBA:0x999DA4FF];
            _authorLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 12 : 8];
            [backView addSubview:_authorLabel];
            [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.nameLabel);
                make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(IS_IPAD ? 6 : 4);
                make.width.mas_lessThanOrEqualTo(IS_IPAD ? 150 : 85);
            }];
        }

        {
            _durationLabel = UILabel.new;
            _durationLabel.textColor = _authorLabel.textColor;
            _durationLabel.font = _authorLabel.font;
            [backView addSubview:_durationLabel];
            [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.durationLabel.superview).offset(IS_IPAD ? 155 : 90);
                make.right.lessThanOrEqualTo(weakSelf.durationLabel.superview);
                make.centerY.equalTo(weakSelf.authorLabel);
            }];
        }

        {
            if (!_audioEditing) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = [UIColor colorWithRGBA:0xF54184FF];
                button.layer.cornerRadius = 4;
                button.layer.masksToBounds = YES;
                button.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 20 : 16];
                button.contentEdgeInsets = UIEdgeInsetsMake(4, IS_IPAD ? 24 : 18, 4, IS_IPAD ? 24 : 18);
                [button setTitle:@"使用" forState:UIControlStateNormal];
                [button addBlockForControlEvents:UIControlEventTouchUpInside
                                           block:^(id _Nonnull sender) {
                                               if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(clickUseButttonInAudioSelectTableViewCell:)]) {
                                                   [weakSelf.delegate clickUseButttonInAudioSelectTableViewCell:weakSelf];
                                               }
                                           }];
                [button sizeToFit];
                self.accessoryView = button;
            } else {
                _selectIcon = [UIImageView new];
                _selectIcon.image = [UIImage imageNamed:@"UnSelected"];
                [self.contentView addSubview:_selectIcon];
                [_selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(weakSelf.selectIcon.superview);
                    make.left.equalTo(weakSelf.selectIcon.superview).offset(IS_IPAD ? 28 : 24);
                }];
            }
        }
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _selectIcon.image = [UIImage imageNamed:self.selected ? @"Selected" : @"UnSelected"];
}

#pragma mark -

@end