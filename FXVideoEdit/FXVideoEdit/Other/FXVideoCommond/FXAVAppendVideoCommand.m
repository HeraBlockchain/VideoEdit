//
//  FXAVAppendVideoCommand.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVAppendVideoCommand.h"

@interface FXAVAppendVideoCommand ()

@property (nonatomic, strong) AVAssetTrack *assetAudioTrack;

@property (nonatomic, assign) NSInteger trackDegress;

@end

@implementation FXAVAppendVideoCommand

- (void)performWithAsset:(AVAsset *)asset appendAsset:(AVAsset *)appendAsset {
    [self appendWithAsset:appendAsset];
}

- (void)appendWithAsset:(AVAsset *)mixAsset {
    NSError *error = nil;

    AVAssetTrack *mixAssetVideoTrack = nil;
    AVAssetTrack *mixAssetAudioTrack = nil;
    // Check if the asset contains video and audio tracks
    if ([[mixAsset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        mixAssetVideoTrack = [mixAsset tracksWithMediaType:AVMediaTypeVideo][0];
    }

    if ([[mixAsset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        mixAssetAudioTrack = [mixAsset tracksWithMediaType:AVMediaTypeAudio][0];
    }

    if (mixAssetVideoTrack) {
        CGSize natureSize = mixAssetVideoTrack.naturalSize;
        NSInteger degress = [self degressFromTransform:mixAssetVideoTrack.preferredTransform];

        AVMutableCompositionTrack *videoTrack = [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo] lastObject];
        BOOL needNewInstrunction = YES;

        if (!(degress % 360) && !self.composition.instructions.count && CGSizeEqualToSize(natureSize, self.composition.mutableComposition.naturalSize) && videoTrack) {
            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetVideoTrack atTime:self.composition.duration error:&error];
            needNewInstrunction = NO;
        } else if (!(degress % 360) && self.composition.instructions.count) {
            CGAffineTransform transform;
            AVMutableVideoCompositionInstruction *instruction = [self.composition.instructions lastObject];
            AVMutableVideoCompositionLayerInstruction *layerInstruction = (AVMutableVideoCompositionLayerInstruction *)instruction.layerInstructions[0];
            [layerInstruction getTransformRampForTime:self.composition.duration startTransform:&transform endTransform:NULL timeRange:NULL];

            if (CGAffineTransformEqualToTransform(transform, mixAssetVideoTrack.preferredTransform) && CGSizeEqualToSize(self.composition.lastInstructionSize, natureSize)) {
                [instruction setTimeRange:CMTimeRangeMake(instruction.timeRange.start, CMTimeAdd(instruction.timeRange.duration, mixAsset.duration))];
                [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetVideoTrack atTime:self.composition.duration error:&error];
                needNewInstrunction = NO;
            } else {
                needNewInstrunction = YES;
            }
        }

        if (needNewInstrunction) {
            [self performVideoCompopsition];

            AVMutableCompositionTrack *newVideoTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:[FXVideoManager persistentTrackIDWithType:AVMediaTypeVideo]];

            //            AVMutableCompositionTrack *newVideoTrack = [self.composition.mutableComposition trackWithTrackID:kCMPersistentTrackID_Orignail_Video_Invalid];

            [newVideoTrack setPreferredTransform:mixAssetVideoTrack.preferredTransform];

            CMTime addtime = mixAsset.duration;
            [newVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, addtime) ofTrack:mixAssetVideoTrack atTime:self.composition.duration error:&error];

            AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            [instruction setTimeRange:CMTimeRangeMake(self.composition.duration, mixAsset.duration)];

            AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:newVideoTrack];

            CGSize renderSize = self.composition.mutableVideoComposition.renderSize;

            if (degress == 90 || degress == 270) {
                natureSize = CGSizeMake(natureSize.height, natureSize.width);
            }

            CGFloat scale = MIN(renderSize.width / natureSize.width, renderSize.height / natureSize.height);

            self.composition.lastInstructionSize = CGSizeMake(natureSize.width * scale, natureSize.height * scale);

            // 移至中心点
            CGPoint translate = CGPointMake((renderSize.width - natureSize.width * scale) * 0.5, (renderSize.height - natureSize.height * scale) * 0.5);

            CGAffineTransform naturalTransform = mixAssetVideoTrack.preferredTransform;
            CGAffineTransform preferredTransform = CGAffineTransformMake(naturalTransform.a * scale, naturalTransform.b * scale, naturalTransform.c * scale, naturalTransform.d * scale, naturalTransform.tx * scale + translate.x, naturalTransform.ty * scale + translate.y);

            [layerInstruction setTransform:preferredTransform atTime:kCMTimeZero];

            instruction.layerInstructions = @[layerInstruction];

            [self.composition.instructions addObject:instruction];
            self.composition.mutableVideoComposition.instructions = self.composition.instructions;
        }
    }

    if (mixAssetAudioTrack) {
        if (self.composition.mutableAudioMix) {
            AVMutableCompositionTrack *audioTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetAudioTrack atTime:self.composition.duration error:&error];

            AVMutableAudioMixInputParameters *audioParam = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:mixAssetAudioTrack];
            [audioParam setVolume:1.0 atTime:kCMTimeZero];
            [self.composition.audioMixParams addObject:audioParam];

            self.composition.mutableAudioMix.inputParameters = self.composition.audioMixParams;
        } else {
            AVMutableCompositionTrack *audioTrack = [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio] lastObject];

            if (!audioTrack) {
                audioTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            }
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetAudioTrack atTime:self.composition.duration error:&error];
        }
    }

    self.composition.duration = CMTimeAdd(self.composition.duration, mixAsset.duration);
    [[NSNotificationCenter defaultCenter] postNotificationName:FXAVExportCommandCompletionNotification object:self];
}

- (void)performVideoCompopsition {
    if (!self.composition.mutableVideoComposition) {
        self.composition.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
        self.composition.mutableVideoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
        self.composition.mutableVideoComposition.renderSize = self.composition.mutableComposition.naturalSize;

        AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.composition.mutableComposition duration]);

        NSArray *trackArray = [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = trackArray[0];

        AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

        [passThroughLayer setTransform:[self transformFromDegress:self.trackDegress natureSize:self.self.composition.mutableComposition.naturalSize] atTime:kCMTimeZero];
        passThroughInstruction.layerInstructions = @[passThroughLayer];

        [self.composition.instructions addObject:passThroughInstruction];
        self.composition.mutableVideoComposition.instructions = self.composition.instructions;

        if (self.trackDegress == 90 || self.trackDegress == 270) {
            self.composition.mutableVideoComposition.renderSize = CGSizeMake(self.self.composition.mutableComposition.naturalSize.height, self.self.composition.mutableComposition.naturalSize.width);
        }

        self.composition.lastInstructionSize = self.composition.mutableComposition.naturalSize = self.composition.mutableVideoComposition.renderSize;
    }
}

- (void)performAudioCompopsition {
    if (!self.composition.mutableAudioMix) {
        self.composition.mutableAudioMix = [AVMutableAudioMix audioMix];

        for (AVMutableCompositionTrack *compostionVideoTrack in [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio]) {
            AVMutableAudioMixInputParameters *audioParam = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compostionVideoTrack];
            [audioParam setVolume:1.0 atTime:kCMTimeZero];
            [self.composition.audioMixParams addObject:audioParam];
        }
        self.composition.mutableAudioMix.inputParameters = self.composition.audioMixParams;
    }
}

- (NSUInteger)degressFromTransform:(CGAffineTransform)transForm {
    NSUInteger degress = 0;

    if (transForm.a == 0 && transForm.b == 1.0 && transForm.c == -1.0 && transForm.d == 0) {
        // Portrait
        degress = 90;
    } else if (transForm.a == 0 && transForm.b == -1.0 && transForm.c == 1.0 && transForm.d == 0) {
        // PortraitUpsideDown
        degress = 270;
    } else if (transForm.a == 1.0 && transForm.b == 0 && transForm.c == 0 && transForm.d == 1.0) {
        // LandscapeRight
        degress = 0;
    } else if (transForm.a == -1.0 && transForm.b == 0 && transForm.c == 0 && transForm.d == -1.0) {
        // LandscapeLeft
        degress = 180;
    }

    return degress;
}

- (CGAffineTransform)transformFromDegress:(float)degress natureSize:(CGSize)natureSize {
    /** 矩阵校正 */
    // x = ax1 + cy1 + tx,y = bx1 + dy2 + ty
    if (degress == 90) {
        return CGAffineTransformMake(0, 1, -1, 0, natureSize.height, 0);
    } else if (degress == 180) {
        return CGAffineTransformMake(-1, 0, 0, -1, natureSize.width, natureSize.height);
    } else if (degress == 270) {
        return CGAffineTransformMake(0, -1, 1, 0, -natureSize.height, 2 * natureSize.width);
    } else {
        return CGAffineTransformIdentity;
    }
}

@end