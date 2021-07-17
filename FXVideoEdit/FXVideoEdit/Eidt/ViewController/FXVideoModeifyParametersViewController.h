//
//  FXVideoModeifyParametersViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoEditOperationType.h"
#import "FXViewController.h"

@class FXVideoItem;
@class FXVideoModeifyParametersViewController;
@class FXTransitionDescribe;

NS_ASSUME_NONNULL_BEGIN

@protocol FXVideoModeifyParametersViewControllerDelegate <NSObject>

- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController scrollViewDidScrollPercent:(Float64)percent;
- (void)scrollVideoWillDragInvideoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController;
- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController clickConnectionButtonAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController clickBeginButtonAtIndexPath:(NSIndexPath *)indexPath;
- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController clickEndButtonAtIndexPath:(NSIndexPath *)indexPaths;
- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController clickButtonWithType:(FXVideoModeifyParameterType)type subType:(FXVideoModeifyParameterSubType)subType;

@end

@interface FXVideoModeifyParametersViewController : FXViewController

@property (nonatomic, weak) id<FXVideoModeifyParametersViewControllerDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray<NSIndexPath *> *selectedIndexPaths;

- (void)addPlentySourceVideoAsset:(NSArray<FXVideoItem *> *)videoItemArray;

- (void)addSourceVideoAsset:(FXVideoItem *)videoItem;

- (void)addSourceVideoAsset:(FXVideoItem *)videoItem index:(NSUInteger)index;

- (void)addPipVideo:(FXVideoItem *)videoItem;

- (void)seekToTimePercent:(double)percent;

- (void)divideVideo;

- (void)rotateVideo;

- (void)changeVideoRate:(CGFloat)rate;

- (void)removeVideo;
/**
 * 撤销操作
 */
- (void)undoOperation;

/**
 * 重做操作
 */
- (void)redoOperation;

- (void)rebuildTimelineView;

@end

NS_ASSUME_NONNULL_END
