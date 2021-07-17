//
//  FXNVideoItemCollectionViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/4.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXNVideoItemCollectionViewCell.h"
#import "FXDescribe.h"
#import "FXNVideoTrimView.h"
#import "FXTimelineItemViewModel.h"
#import "FXVideoDescribe.h"
#import "FXVideoItem.h"
#import "FXTitleDescribe.h"
#import "FXTitleCoverView.h"

@interface FXNVideoItemCollectionViewCell ()

@property (strong, nonatomic) FXNVideoTrimView *itemView;

@property (nonatomic, strong) FXTimeLineTitleModel *selectedTitleModel;

@end

@implementation FXNVideoItemCollectionViewCell

#pragma mark 对外
- (void)setItemModel:(FXTimelineItemViewModel *)itemModel {
    _itemModel = itemModel;
    if (_itemModel) {
        FXVideoDescribe *videoDescribe = (FXVideoDescribe *)_itemModel.describe;
        FXVideoItem *item = videoDescribe.videoItem;
        [_itemView setDelegate:item timeRange:videoDescribe.sourceRange];
        [self layoutTitleView];
    }
}
#pragma mark -

- (void)layoutTitleView
{
    for (FXTimeLineTitleModel *titleModel in self.itemModel.titleModelArray) {
        FXTitleCoverView *coverView = [[FXTitleCoverView alloc] initWithModel:titleModel];
        [self.contentView addSubview:coverView];
    }
    [self layoutAddButton];
}

#pragma mark <UICollectionViewCell>
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _itemView.layer.borderColor = [UIColor colorWithRGBA:self.selected ? 0xF54184FF : 0x00000000].CGColor;
}
#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemView = [FXNVideoTrimView.alloc initWithFrame:self.contentView.bounds];
        _itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _itemView.layer.cornerRadius = IS_IPAD ? 6 : 4;
        _itemView.layer.borderWidth = 2.0;
        _itemView.layer.masksToBounds = YES;
        [self.contentView addSubview:_itemView];
    }

    return self;
}

#pragma mark -


@end
