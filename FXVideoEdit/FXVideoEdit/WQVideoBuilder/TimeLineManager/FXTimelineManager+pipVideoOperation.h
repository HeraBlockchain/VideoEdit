//
//  FXTimelineManager+pipVideoOperation.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager.h"

@interface FXTimelineManager (pipVideoOperation)

- (void)addPipVideoAtTime:(CMTime)startTime video:(FXVideoItem *)videoItem;


/**
 *   设置画中画音量，默认1.0，取值范围0--1.0
 */
- (void)setPipAudioVolume:(CGFloat)volume;

@end
