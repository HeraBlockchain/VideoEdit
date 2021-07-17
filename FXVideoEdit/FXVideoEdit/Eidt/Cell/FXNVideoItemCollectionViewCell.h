//
//  FXNVideoItemCollectionViewCell.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/4.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLineCollectionViewCell.h"
@class FXTimelineItemViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface FXNVideoItemCollectionViewCell : FXTimeLineCollectionViewCell

@property (nonatomic, strong) FXTimelineItemViewModel *itemModel;

@end

NS_ASSUME_NONNULL_END