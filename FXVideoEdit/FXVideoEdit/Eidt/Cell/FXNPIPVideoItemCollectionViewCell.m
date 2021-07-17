//
//  FXNPIPVideoItemCollectionViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/7.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXNPIPVideoItemCollectionViewCell.h"
#import "FXNPIPVideoItemCollectionViewCellSelectedMaskView.h"
#import "FXNVideoTrimView.h"
#import "FXVideoDescribe.h"

@interface FXNPIPVideoItemCollectionViewCell ()

@property (nonatomic, strong) FXNVideoTrimView *itemView;

@property (nonatomic, strong) FXNPIPVideoItemCollectionViewCellSelectedMaskView *selectedMaskView;

@end

@implementation FXNPIPVideoItemCollectionViewCell

#pragma mark 对外
- (void)setCellData:(FXTimelineItemViewModel *)cellData {
    _cellData = cellData;
    if (_cellData) {
        FXVideoDescribe *videoDescribe = (FXVideoDescribe *)_cellData.describe;
        FXVideoItem *item = videoDescribe.videoItem;
        [_itemView setDelegate:item timeRange:videoDescribe.sourceRange];
    }
}
#pragma mark -

#pragma mark <UICollectionViewCell>
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _selectedMaskView.hidden = !self.selected;
}
#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakSelf = self;

        {
            self.contentView.layer.cornerRadius = IS_IPAD ? 4 : 2;
            self.contentView.layer.masksToBounds = YES;
        }

        {
            _itemView = FXNVideoTrimView.new;
            _itemView.layer.cornerRadius = IS_IPAD ? 6 : 4;
            _itemView.layer.masksToBounds = YES;
            [self.contentView addSubview:_itemView];
            [_itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.width.equalTo(weakSelf.itemView.superview);
                make.height.equalTo(weakSelf.itemView.superview).multipliedBy(0.5);
                make.bottom.equalTo(weakSelf.itemView.superview).offset(-5);
            }];
        }

        {
            _selectedMaskView = [FXNPIPVideoItemCollectionViewCellSelectedMaskView.alloc initWithFrame:_itemView.bounds];
            _selectedMaskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _selectedMaskView.hidden = YES;
            [_itemView addSubview:_selectedMaskView];
        }

        {
            self->_leftAddButton.hidden = YES;
            self->_rightAddButton.hidden = YES;
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_selectedMaskView setNeedsDisplay];
}

#pragma mark -

@end