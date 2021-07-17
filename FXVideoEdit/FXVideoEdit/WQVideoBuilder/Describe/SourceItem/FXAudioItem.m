//
//  FXAudioItem.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioItem.h"

@implementation FXAudioItem


- (AVAssetTrack *)audioTrack {
    AVAssetTrack *track = [self.asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    return track;
}

@end
