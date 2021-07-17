//
//  FXTimeLineView.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXTimeLineView;
@class FXTransitionDescribe;
@class FXVideoItem;

NS_ASSUME_NONNULL_BEGIN

@protocol FXTimeLineViewDelegate <NSObject>

- (void)scrollVideoWillDragInTimeLineView:(FXTimeLineView *)timeLineView;
- (void)timeLineView:(FXTimeLineView *)timeLineView scrollViewDragScrollPercent:(Float64)percent;
- (void)timeLineView:(FXTimeLineView *)timeLineView clickConnectionButtonAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)timeLineView:(FXTimeLineView *)timeLineView clickBeginButtonAtIndexPath:(NSIndexPath *)indexPath;
- (void)timeLineView:(FXTimeLineView *)timeLineView clickEndButtonAtIndexPath:(NSIndexPath *)indexPaths;

@end

@interface FXTimeLineView : UIView

@property (nonatomic, weak, nullable) id<FXTimeLineViewDelegate> delegate;

- (void)seekToTimePercent:(double)percent;

@property (nonatomic, strong, readonly) NSArray<NSIndexPath *> *selectedIndexPaths;

/**
 *  添加视频资源
 */
- (void)addSourceVideoAsset:(FXVideoItem *)videoItem;

- (void)addSourceVideoAsset:(FXVideoItem *)videoItem index:(NSUInteger)index;

- (void)addPlentySourceVideoAsset:(NSArray<FXVideoItem *> *)videoItemArray;

//  添加画中画视频
- (void)addPipVideo:(FXVideoItem *)videoItem;

/**
 * 撤销操作
 */
- (void)undoOperation;

/**
 * 重做操作
 */
- (void)redoOperation;

/**
 *  分割视频
 */
- (void)divideVideo;

/**
 *  旋转视频，每次顺时针90度
 */
- (void)rotateVideo;

/**
 *  改变视频倍速
 */
- (void)changeVideoRate:(CGFloat)rate;

- (void)removeVideo;

- (void)moveVideoItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

- (void)cancelMoveOperation;

- (void)confirmMoveOperation;

- (void)rebuildTimelineView;

@end

NS_ASSUME_NONNULL_END
