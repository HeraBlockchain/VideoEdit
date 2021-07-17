//
//  FXMainComposition.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXMainComposition.h"
#import "AVPlayerItem+FXAdd.h"

@implementation FXMainComposition

- (instancetype)initWithComposition:(AVComposition *)composition
                   videoComposition:(AVVideoComposition *)videoComposition
                           audioMix:(AVAudioMix *)audioMix
                         titleLayer:(CALayer *)titleLayer
                           videoPip:(FXPipVideoComposition *)video
                              title:(FXTitleVideoComposition *)title
{
    self = [super init];
    if (self) {
        _composition = composition;
        _videoComposition = videoComposition;
        _audioMix = audioMix;
        _titleLayer = titleLayer;
        _pipVideoComposition = video;
        _titleVideoComposition = title;
    }
    return self;
}

- (AVPlayerItem *)makePlayable {
    AVPlayerItem *playerItem =
        [AVPlayerItem playerItemWithAsset:[self.composition copy]];
    playerItem.videoComposition = self.videoComposition;
    playerItem.audioMix = self.audioMix;
    if (self.titleLayer) {
        AVSynchronizedLayer *syncLayer =
            [AVSynchronizedLayer synchronizedLayerWithPlayerItem:playerItem];

        [syncLayer addSublayer:self.titleLayer];
        playerItem.syncLayer = syncLayer;
    }

    return playerItem;
}

- (AVAssetExportSession *)makeExportable {
    if (1) {
        CGRect rect = CGRectMake(0, 0, _videoComposition.renderSize.width, _videoComposition.renderSize.height);
        CALayer *animationLayer = [CALayer layer]; // 1
        animationLayer.frame = rect;

        CALayer *videoLayer = [CALayer layer];
        videoLayer.frame = rect;

        [animationLayer addSublayer:videoLayer]; // 2
        [animationLayer addSublayer:self.titleLayer];

        animationLayer.geometryFlipped = YES; // 3

        AVVideoCompositionCoreAnimationTool *animationTool = // 4
            [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                                                                                         inLayer:animationLayer];
        AVMutableVideoComposition *mvc =
            (AVMutableVideoComposition *)self.videoComposition;

        mvc.animationTool = animationTool;
        
//        CGSize size = self.videoComposition.renderSize;
//        // 1 - 这个layer就是用来显示水印的。
//        CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
//        [subtitle1Text setFont:@"Helvetica-Bold"];
//        [subtitle1Text setFontSize:36];
//        [subtitle1Text setFrame:CGRectMake(100, 100, 250, 150)];
//        [subtitle1Text setString:@"HHHFSFDBF"];
//        [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
//        [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
//        // 2 - The usual overlay
//        CALayer *overlayLayer = [CALayer layer];
//        [overlayLayer addSublayer:subtitle1Text];
//        overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
//        [overlayLayer setMasksToBounds:YES];
//        
//        CALayer *parentLayer = [CALayer layer];
//        CALayer *videoLayer = [CALayer layer];
//        parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
//        videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
//        // 这里看出区别了吧，我们把overlayLayer放在了videolayer的上面，所以水印总是显示在视频之上的。
//        [parentLayer addSublayer:videoLayer];
//        [parentLayer addSublayer:overlayLayer];
//        AVMutableVideoComposition *mvc =
//            (AVMutableVideoComposition *)self.videoComposition;
//        mvc.animationTool = [AVVideoCompositionCoreAnimationTool
//                                     videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        
    }

    NSString *presetName = AVAssetExportPresetHighestQuality;
    AVAssetExportSession *session =
        [[AVAssetExportSession alloc] initWithAsset:[self.composition copy]
                                         presetName:presetName];
    session.audioMix = self.audioMix;
    session.videoComposition = self.videoComposition;
    session.shouldOptimizeForNetworkUse = YES;
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%f.mp4", [[NSDate date] timeIntervalSinceReferenceDate]]];
    session.outputFileType = AVFileTypeMPEG4;
    return session;
}
@end
