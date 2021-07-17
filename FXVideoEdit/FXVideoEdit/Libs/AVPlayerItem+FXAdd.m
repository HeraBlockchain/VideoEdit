//
//  AVPlayerItem+FXAdd.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "AVPlayerItem+FXAdd.h"
#import <objc/runtime.h>

static id FXSynchronizedLayerKey;

@implementation AVPlayerItem (FXAdd)

- (BOOL)hasValidDuration {
    return self.status == AVPlayerItemStatusReadyToPlay && !CMTIME_IS_INVALID(self.duration);
}

- (AVSynchronizedLayer *)syncLayer {
    return objc_getAssociatedObject(self, &FXSynchronizedLayerKey);
}

- (void)setSyncLayer:(AVSynchronizedLayer *)titleLayer {
    objc_setAssociatedObject(self, &FXSynchronizedLayerKey, titleLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)muteAudioTracks:(BOOL)value {
    for (AVPlayerItemTrack *track in self.tracks) {
        if ([track.assetTrack.mediaType isEqualToString:AVMediaTypeAudio]) {
            track.enabled = !value;
        }
    }
}

@end