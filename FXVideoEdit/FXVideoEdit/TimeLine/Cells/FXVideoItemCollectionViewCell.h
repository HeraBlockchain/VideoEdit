//
//  FXVideoItemCollectionViewCell.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineItemViewModel.h"
#import "FXVideoTrimView.h"
#import <UIKit/UIKit.h>

@interface FXVideoItemCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) FXVideoTrimView *itemView;

@property (nonatomic) CMTimeRange maxTimeRange;

@property (nonatomic, strong) FXTimelineItemViewModel *itemModel;

- (BOOL)isPointInDragHandle:(CGPoint)point;

@end