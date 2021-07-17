//
//  AVPlayerItem+FXAdd.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVPlayerItem (FXAdd)

@property (strong, nonatomic) AVSynchronizedLayer *syncLayer;

- (BOOL)hasValidDuration;

- (void)muteAudioTracks:(BOOL)value;

@end