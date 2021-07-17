//
//  FXTimelineManager+recordAudio.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager.h"

@interface FXTimelineManager (recordAudio) <AVAudioRecorderDelegate>

/**
 *   设置音量，默认1.0，取值范围0--1.0
 */
- (void)setRecordAudioVolume:(CGFloat)volume;

- (void)prepareAudioRecorder;

- (void)startRecordAtTime:(CMTime)startTime;

- (void)stopRecord:(NSInteger)index;

- (NSTimeInterval)currentRecordTime;

@end

