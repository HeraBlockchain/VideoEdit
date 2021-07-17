//
//  FXPipVideoItemCollectionViewCell.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineItemViewModel.h"
#import "FXVideoTrimView.h"
#import <Foundation/Foundation.h>

@interface FXPipVideoItemCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) FXVideoTrimView *itemView;

@property (nonatomic) CMTimeRange maxTimeRange;

@property (nonatomic, strong) FXTimelineItemViewModel *itemModel;

- (BOOL)isPointInDragHandle:(CGPoint)point;

@end