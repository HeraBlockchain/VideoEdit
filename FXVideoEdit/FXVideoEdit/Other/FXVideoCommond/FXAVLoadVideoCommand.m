//
//  FXAVLoadVideoCommand.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVLoadVideoCommand.h"

@interface FXAVLoadVideoCommand ()

@property (nonatomic, strong) AVAssetTrack *assetVideoTrack;

@property (nonatomic, strong) AVAssetTrack *assetAudioTrack;

@property (nonatomic, assign) NSInteger trackDegress;

@end

@implementation FXAVLoadVideoCommand

- (void)performWithAsset:(AVAsset *)asset {
    //    [super performWithAsset:asset];
    // 1.1､视频资源的轨道
    if (!self.assetVideoTrack) {
        if ([asset tracksWithMediaType:AVMediaTypeVideo].count != 0) {
            self.assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        }
    }

    // 1.2､音频资源的轨道
    if (!self.assetAudioTrack) {
        if ([asset tracksWithMediaType:AVMediaTypeAudio].count != 0) {
            self.assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        }
    }
    // 2､创建混合器

    if (!self.composition.mutableComposition) {
        // 要混合的时间
        CMTime insertionPoint = kCMTimeZero;
        NSError *error = nil;

        self.composition.mutableComposition = [AVMutableComposition composition];
        //  2.1､把视频轨道加入到混合器做出新的轨道
        if (self.assetVideoTrack != nil) {
            AVMutableCompositionTrack *compostionVideoTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];

            [compostionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:self.assetVideoTrack atTime:insertionPoint error:&error];

            self.composition.duration = self.composition.mutableComposition.duration;

            //                 self.trackDegress = [self degressFromTransform:self.assetVideoTrack.preferredTransform];
            //
            //                 self.composition.mutableComposition.naturalSize = compostionVideoTrack.naturalSize;
            //                 if (self.trackDegress % 360) {
            //                     [self performVideoCompopsition];
            //
            //                 }
        }
        //  2.2､把音频轨道加入到混合器做出新的轨道
        if (self.assetAudioTrack != nil) {
            AVMutableCompositionTrack *compositionAudioTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:self.assetAudioTrack atTime:insertionPoint error:&error];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:FXAVExportCommandCompletionNotification object:self];
}

@end