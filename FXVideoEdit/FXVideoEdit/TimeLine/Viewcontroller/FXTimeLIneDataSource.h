//
//  FXTimeLIneDataSource.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLIneCollectionViewLayout.h"
#import "FXTimeLineViewController.h"
#import <Foundation/Foundation.h>

@class FXTimelineItemViewModel;
@class FXTransitionDescribe;

@protocol FXTimeLIneDataSourceDelegate <NSObject>

- (void)scrollViewDidScrollPercent:(Float64)percent;

- (void)scrollVideoWillDrag;

- (void)timelineSelectedIndex:(NSInteger)index;

- (void)pipVideoMoveToPosition:(CGFloat)position timeline:(FXTimelineItemViewModel *)timelineItem;

- (void)clickTransitionButtonAtIndex:(FXTransitionDescribe *)describe;

@end

@interface FXTimeLIneDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegateTimelineLayout>

@property (nonatomic, weak) id<FXTimeLIneDataSourceDelegate> delegate;

+ (id)dataSourceWithCollectionView:(UICollectionView *)collectionView;

- (void)resetTimeline;

- (void)clearTimeline;

@property (strong, nonatomic) NSMutableArray *timelineItems;

@end