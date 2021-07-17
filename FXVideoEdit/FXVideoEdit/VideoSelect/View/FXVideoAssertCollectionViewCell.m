//
//  FXVideoAssertCollectionViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoAssertCollectionViewCell.h"
#import "NSString+FXExpand.h"

@interface FXVideoAssertCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *selectIcon;

@end

@implementation FXVideoAssertCollectionViewCell

#pragma mark 对外
+ (UIEdgeInsets)imageViewEdgeInsets {
    if (IS_IPAD) {
        return UIEdgeInsetsMake(12, 12, 12, 12);
    } else {
        return UIEdgeInsetsMake(6, 6, 6, 6);
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (_selectedIndex != NSNotFound) {
        if (_needShowSelectedIndex) {
            [_selectIcon setTitle:@(_selectedIndex + 1).stringValue forState:UIControlStateNormal];
            [_selectIcon setBackgroundImage:[UIImage imageNamed:@"SelectedBack"] forState:UIControlStateNormal];
        } else {
            [_selectIcon setTitle:nil forState:UIControlStateNormal];
            [_selectIcon setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
        }
    } else {
        [_selectIcon setTitle:nil forState:UIControlStateNormal];
        [_selectIcon setBackgroundImage:[UIImage imageNamed:@"UnSelected"] forState:UIControlStateNormal];
    }
}

- (void)setNeedShowSelectedIndex:(BOOL)needShowSelectedIndex {
    _needShowSelectedIndex = needShowSelectedIndex;
    self.selectedIndex = _selectedIndex;
}

#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;

        {
            _needShowSelectedIndex = NO;
        }

        {
            _imageView = [UIImageView new];
            _imageView.layer.cornerRadius = 4;
            _imageView.layer.masksToBounds = YES;
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:_imageView];
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakSelf.imageView.superview).insets(FXVideoAssertCollectionViewCell.imageViewEdgeInsets);
            }];
        }

        {
            _timeLabel = [UILabel new];
            _timeLabel.textColor = UIColor.whiteColor;
            _timeLabel.font = [UIFont systemFontOfSize:10];
            _timeLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_timeLabel];
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.timeLabel.superview).offset(-8);
                make.right.equalTo(weakSelf.imageView).offset(-3);
            }];
        }

        {
            _selectIcon = [UIButton buttonWithType:UIButtonTypeCustom];
            _selectIcon.userInteractionEnabled = NO;
            _selectIcon.titleLabel.font = [UIFont systemFontOfSize:11];
            _selectIcon.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:_selectIcon];
            [_selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(weakSelf.imageView);
            }];
        }

        {
            [self addObserverBlockForKeyPath:@"dataModel.thumbnailImageLoadStatus"
                                       block:^(id _Nonnull obj, id _Nullable oldVal, id _Nullable newVal) {
                                           switch (weakSelf.dataModel.thumbnailImageLoadStatus) {
                                               case FXPhotoLoadStatusNoLoadStatus:
                                                   weakSelf.imageView.image = nil;
                                                   break;
                                               case FXPhotoLoadStatusLoadingStatus:
                                                   weakSelf.imageView.image = nil;

                                                   break;
                                               case FXPhotoLoadStatusLoadedStatus:
                                                   weakSelf.imageView.image = weakSelf.dataModel.thumbnailImage;
                                                   break;
                                               case FXPhotoLoadStatusLoadErrorStatus:
                                                   weakSelf.imageView.image = nil;
                                               default:
                                                   break;
                                           }
                                       }];
            [self addObserverBlockForKeyPath:@"dataModel.asset.duration"
                                       block:^(id _Nonnull obj, id _Nullable oldVal, id _Nullable newVal) {
                                           weakSelf.timeLabel.text = [NSString fx_stringWithVideoDuration:weakSelf.dataModel.asset.duration];
                                       }];
        }
    }

    return self;
}
#pragma mark -

#pragma mark NSObject
- (void)dealloc {
    [self removeObserverBlocks];
}
#pragma mark -

@end