//
//  AVPlayer+SeekSmoothly.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/17.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVPlayer (SeekSmoothly)

- (void)ss_seekToTime:(CMTime)time;

- (void)ss_seekToTime:(CMTime)time
      toleranceBefore:(CMTime)toleranceBefore
       toleranceAfter:(CMTime)toleranceAfter
    completionHandler:(void (^)(BOOL))completionHandler;

@end