//
//  FXSelectedVideoCollectionViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXSelectedVideoCollectionViewCell.h"
#import "NSString+FXExpand.h"

@interface FXSelectedVideoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation FXSelectedVideoCollectionViewCell

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            self.contentView.backgroundColor = UIColor.blackColor;
        }

        {
            _imageView = [UIImageView.alloc initWithFrame:self.contentView.bounds];
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView.layer.masksToBounds = YES;
            _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.contentView addSubview:_imageView];
        }

        __weak typeof(self) weakSelf = self;
        {
            _timeLabel = UILabel.new;
            _timeLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 28 : 12];
            _timeLabel.layer.cornerRadius = 4;
            _timeLabel.textColor = UIColor.whiteColor;
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_timeLabel];
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(weakSelf.timeLabel.superview);
                make.width.lessThanOrEqualTo(weakSelf.timeLabel.superview);
            }];
        }

        {
            _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_deleteButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_deleteButton setImage:[UIImage imageNamed:@"DeleteAssert"] forState:UIControlStateNormal];
            [self.contentView addSubview:_deleteButton];
            [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(weakSelf.deleteButton.superview);
                make.size.mas_equalTo([UIImage imageNamed:@"DeleteAssert"].size);
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

#pragma mark UI回调
- (void)clickButton:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clickDeleteButtonInSelectedVideoCollectionViewCell:)]) {
        [_delegate clickDeleteButtonInSelectedVideoCollectionViewCell:self];
    }
}
#pragma mark -

@end