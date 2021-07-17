//
//  FXNPIPVideoItemCollectionViewCell.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/7.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLineCollectionViewCell.h"
#import "FXTimelineItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXNPIPVideoItemCollectionViewCell : FXTimeLineCollectionViewCell

@property (nonatomic, strong) FXTimelineItemViewModel *cellData;

@end

NS_ASSUME_NONNULL_END