//
//  FXTimeLineViewController.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/27.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXVideoItem;
@class FXAudioItem;
@class FXTimelineItem;
@class FXTimelineDescribe;
@class FXTransitionDescribe;

@protocol FXTimeLineViewControllerDelegate <NSObject>

- (void)scrollViewDidScrollPercent:(Float64)percent;

- (void)scrollVideoWillDrag;

- (void)clickTransitionButtonAtIndex:(FXTransitionDescribe *)describe;

@end

@interface FXTimeLineViewController : UIViewController

@property (nonatomic, weak) id<FXTimeLineViewControllerDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)seekToTimePercent:(double)percent;

/**
 *  添加视频资源
 */
- (void)addSourceVideoAsset:(FXVideoItem *)videoItem;

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

@end