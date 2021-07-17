//
//  FXVideoItemCollectionViewCell.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoItemCollectionViewCell.h"
#import "FXVideoDescribe.h"
#import "FXVideoItem.h"

@interface FXVideoItemCollectionViewCell ()

@property (strong, nonatomic) UIImageView *trimmerImageView;

@end

@implementation FXVideoItemCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setItemModel:(FXTimelineItemViewModel *)itemModel {
    _itemModel = itemModel;
    [self setItemViewWithFrame:self.frame];
}

- (void)setItemViewWithFrame:(CGRect)frame {
    FXVideoDescribe *videoDescribe = (FXVideoDescribe *)_itemModel.describe;
    FXVideoItem *item = videoDescribe.videoItem;
    _itemView = [[FXVideoTrimView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) timeRange:videoDescribe.sourceRange];
    _itemView.delegate = item;
    [self.contentView addSubview:_itemView];
    [_itemView reloadAllSubViews];
}

- (BOOL)isPointInDragHandle:(CGPoint)point {
    //    CGRect handleRect = CGRectMake(self.frameWidth - 30, 0, 30, self.frameHeight);
    //    BOOL contains = CGRectContainsPoint(handleRect, point);
    //    return contains;
    return NO;
}

- (void)setMaxTimeRange:(CMTimeRange)maxTimeRange {
    _maxTimeRange = maxTimeRange;
    //NSLog(@"Max Time Range Set");
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.layer.borderWidth = selected ? 1 : 0;
    self.layer.borderColor = UIColorMakeWithRGBA(245, 65, 132, 1).CGColor;

    self.trimmerImageView.frame = self.bounds;
    self.trimmerImageView.hidden = !selected;
    self.trimmerImageView.highlighted = NO;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.trimmerImageView.highlighted = highlighted;
}

- (void)layoutSubviews {
    self.trimmerImageView.frame = self.bounds;
}

@end