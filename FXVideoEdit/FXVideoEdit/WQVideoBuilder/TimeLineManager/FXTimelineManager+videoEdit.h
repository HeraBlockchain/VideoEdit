//
//  FXTimelineManager+videoEdit.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager.h"

@interface FXTimelineManager (videoEdit)

- (void)addSourceVideos:(NSArray <FXVideoItem *> *)videoItemArray;

/**
 *  添加视频资源
 */
- (void)addSourceAtIndex:(NSInteger)index
              videoAsset:(FXVideoItem *)videoItem;


/**
 *  删除指定位置的视频
 */
- (void)removeVideoItemAtIndex:(NSInteger)index;


/**
 *  分割视频
 */
- (void)divideVideoAtTime:(CMTime)divideTime atIndex:(NSInteger)index;

/**
 *   改变视频播放速度
 */
- (void)changeVideoScale:(CGFloat)scale atIndex:(NSInteger)index;

/**
 *  旋转视频
 */
- (void)rotateVideoAngle:(NSInteger)videoIndex;

/**
 *  移动视频的位置
 */
- (void)moveVideoItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

/**
 *   设置音量，默认1.0，取值范围0--1.0
 */
- (void)setAudioVolume:(CGFloat)volume;

/**
 *  设置视频画幅
 */
- (void)setVideoPictureSize:(FXPictureSize)psize;

- (void)changeFilterTypeAtIndex:(NSInteger)videoIndex
                         filter:(FXFilterDescribeType)type;

- (CMTime)videoTransitionDuration:(FXVideoDescribe *)videoDescribe
                              pre:(BOOL)pre;

//添加转场
- (void)addTransitionItemPreIndex:(NSInteger)preIndex
                        backIndex:(NSInteger)backIndex
                        transType:(FXTransType)transType;

//修改转场
- (void)changeTransitionItemPreIndex:(NSInteger)preIndex
                           backIndex:(NSInteger)backIndex
                            duration:(CMTime)duration
                           transType:(FXTransType)transType;

//获取转场数据
- (FXTransitionDescribe *)transitionItemWithPreIndex:(NSInteger)preIndex
                                           backIndex:(NSInteger)backIndex;

- (void)cropVideo:(FXVideoDescribe *)video
          leftPer:(CGFloat)left
         rightper:(CGFloat)right;

@end
