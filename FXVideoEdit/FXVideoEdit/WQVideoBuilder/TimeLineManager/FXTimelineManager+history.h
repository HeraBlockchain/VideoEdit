//
//  FXTimelineManager+history.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager.h"

@interface FXTimelineManager (history)

- (void)undoOperation;

- (void)redoOperation;

/**
 *  重置为上次保存的操作
 */
- (void)resetOperation;


/**
 * 保存视频操作步骤
 */
- (void)saveHistoryData;




- (BOOL)canundo;

- (BOOL)canRedo;


- (FXTimelineDescribe *)timelineScaleWithJson:(NSString *)jsonString;

@end
