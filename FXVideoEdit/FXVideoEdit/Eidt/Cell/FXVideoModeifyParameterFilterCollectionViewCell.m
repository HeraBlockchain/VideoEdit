//
//  FXVideoModeifyParameterFilterCollectionViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterFilterCollectionViewCell.h"

@interface FXVideoModeifyParameterFilterCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FXVideoModeifyParameterFilterCollectionViewCell

#pragma mark 对外
- (void)setType:(FXFilterDescribeType)type {
    _type = type;
    _titleLabel.text = [FXFilterDescribe filterNameWithType:_type];
    //_imageView.image =  ...;
}
#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        {
            self.contentView.layer.cornerRadius = IS_IPAD ? 4 : 4;
            self.contentView.layer.borderWidth = IS_IPAD ? 1 : 1;
            self.contentView.layer.masksToBounds = YES;
            self.contentView.layer.borderColor = UIColor.blackColor.CGColor;
        }
        
        {
            _titleLabel = UILabel.new;
            _titleLabel.textColor = UIColor.whiteColor;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.adjustsFontSizeToFitWidth = YES;
            _titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 16 : 8];
            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.width.equalTo(_titleLabel.superview);
                make.bottom.equalTo(_titleLabel.superview).offset(IS_IPAD ? -10 : -10);
            }];
        }

        {
            _imageView = UIImageView.new;
            _imageView.backgroundColor = [UIColor colorWithRGB:arc4random()];
            _imageView.layer.cornerRadius = 4;
            _imageView.layer.masksToBounds = YES;
            [self.contentView addSubview:_imageView];
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.centerX.equalTo(_imageView.superview);
                make.bottom.equalTo(_titleLabel.mas_top).offset(IS_IPAD ? -16 : -15);
                make.height.equalTo(_imageView.mas_width);
            }];
        }
    }

    return self;
}

#pragma mark UICollectionViewCell
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.contentView.layer.borderColor = self.selected ? [UIColor colorWithRGBA:0xF54184FF].CGColor : UIColor.blackColor.CGColor;
}

@end
