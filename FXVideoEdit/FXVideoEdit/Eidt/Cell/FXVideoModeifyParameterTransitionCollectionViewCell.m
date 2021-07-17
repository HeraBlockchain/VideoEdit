//
//  FXVideoModeifyParameterTransitionCollectionViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterTransitionCollectionViewCell.h"

@interface FXVideoModeifyParameterTransitionCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FXVideoModeifyParameterTransitionCollectionViewCell

#pragma mark 对外
- (void)setType:(FXTransType)type {
    _type = type;
    _label.text = [FXTransitionDescribe transitionNameWithType:_type];
    _imageView.backgroundColor = [UIColor colorWithRGB:arc4random()];
}
#pragma mark -

#pragma mark UIView
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
            _label = UILabel.new;
            _label.textAlignment = NSTextAlignmentCenter;
            _label.textColor = UIColor.whiteColor;
            _label.font = [UIFont systemFontOfSize:IS_IPAD ? 8 : 8];
            [self.contentView addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_label.superview).offset(IS_IPAD ? -5 : -5);
                make.centerX.width.equalTo(_label.superview);
            }];
        }

        {
            _imageView = UIImageView.new;
            [self.contentView addSubview:_imageView];
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_imageView.superview);
                make.bottom.equalTo(_label.mas_top).offset(-2);
                make.size.mas_equalTo(CGSizeMake(24, 24));
            }];
        }
    }

    return self;
}
#pragma mark -

#pragma mark UICollectionViewCell
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.contentView.layer.borderColor = self.selected ? [UIColor colorWithRGBA:0xF54184FF].CGColor : UIColor.blackColor.CGColor;
}
#pragma mark -

@end
