//
//  FXMainComposition.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FXPipVideoComposition;
@class FXTitleVideoComposition;

@interface FXMainComposition : NSObject

@property (strong, nonatomic, readonly) AVComposition *composition;
@property (strong, nonatomic, readonly) AVVideoComposition *videoComposition;
@property (strong, nonatomic, readonly) AVAudioMix *audioMix;
@property (strong, nonatomic, readonly) CALayer *titleLayer;
@property (nonatomic, strong) FXPipVideoComposition *pipVideoComposition;
@property (nonatomic, strong) FXTitleVideoComposition *titleVideoComposition;

- (id)initWithComposition:(AVComposition *)composition
         videoComposition:(AVVideoComposition *)videoComposition
                 audioMix:(AVAudioMix *)audioMix
               titleLayer:(CALayer *)titleLayer
                 videoPip:(FXPipVideoComposition *)video
                    title:(FXTitleVideoComposition *)title;

- (AVPlayerItem *)makePlayable;

- (AVAssetExportSession *)makeExportable;

@end
