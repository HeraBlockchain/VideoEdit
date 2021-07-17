//
//  FXAVTransitionsCommand.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/22.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVTransitionsCommand.h"

@implementation FXAVTransitionsCommand

#pragma mark - 转场layer
- (AVMutableVideoCompositionInstruction *)transitionInstructionWith:(AVMutableCompositionTrack *)compositionVideoTrack
                                                               next:(AVMutableCompositionTrack *)nextcompositionVideoTrack
                                                          timeRange:(CMTimeRange)transitionTimeRange
                                                     transitionType:(FXAVTransitionType)transitionType {
    AVMutableVideoCompositionInstruction *transitionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    transitionInstruction.timeRange = transitionTimeRange;

    AVMutableVideoCompositionLayerInstruction *fromLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack]; //当前视频track

    AVMutableVideoCompositionLayerInstruction *toLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack]; //下一个视频track
    // Fade in the toLayer by setting a ramp from 0.0 to 1.0.
    [toLayer setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:transitionTimeRange];

    CGFloat videoWidth = compositionVideoTrack.naturalSize.width;
    CGFloat videoHeight = compositionVideoTrack.naturalSize.height;

    switch (transitionType) {
        case kTransitionTypeNone: {
            [toLayer setOpacity:1.0 atTime:kCMTimeZero];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, nil];
            break;
        }
        case kTransitionTypeCrossFade: //溶解
        {
            // Fade out the fromLayer by setting a ramp from 1.0 to 0.0.
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            break;
        }
        case kTransitionTypeCropRectangle: {
            AVMutableVideoCompositionLayerInstruction *fromLayerRightup = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *fromLayerLeftup = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *fromLayerLeftDown = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];

            //右下
            CGRect startRect = CGRectMake(videoWidth / 2.0, videoHeight / 2.0, videoWidth / 2.0, videoHeight / 2.0);
            CGRect endRect = CGRectMake(videoWidth, videoHeight, 0.0f, 0.0f);
            //通过裁剪实现擦除
            [fromLayer setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:transitionTimeRange];
            //右上
            startRect = CGRectMake(videoWidth / 2.0, 0, videoWidth / 2.0, videoHeight / 2.0);
            endRect = CGRectMake(videoWidth, 0.0f, 0.0f, 0.0f);
            //通过裁剪实现擦除
            [fromLayerRightup setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:transitionTimeRange];
            //左上
            startRect = CGRectMake(0, 0, videoWidth / 2.0, videoHeight / 2.0);
            endRect = CGRectZero;
            //通过裁剪实现擦除
            [fromLayerLeftup setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:transitionTimeRange];
            //左上
            startRect = CGRectMake(0, videoHeight / 2.0, videoWidth / 2.0, videoHeight / 2.0);
            endRect = CGRectMake(0, videoHeight, 0.0f, 0.0f);
            //通过裁剪实现擦除
            [fromLayerLeftDown setCropRectangleRampFromStartCropRectangle:startRect toEndCropRectangle:endRect timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, fromLayerRightup, fromLayerLeftup, fromLayerLeftDown, nil];

            break;
        }
        case kTransitionTypePushHorizontalSpinFromRight: {
            CGAffineTransform scaleT = CGAffineTransformMakeScale(0.1, 0.1);
            CGAffineTransform rotateT = CGAffineTransformMakeRotation(M_PI);
            CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformConcat(scaleT, rotateT), 1, 1);
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:transform timeRange:transitionTimeRange];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];

            break;
        }
        case kTransitionTypeMiddleTransform: {
            CGAffineTransform scaleT = CGAffineTransformMakeScale(0.001, 0.001);
            CGAffineTransform transform = CGAffineTransformTranslate(scaleT, videoWidth * 500, videoHeight * 500);
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:transform timeRange:transitionTimeRange];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];

            break;
        }
        case kTransitionTypePushHorizontalFromRight: {
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(-videoWidth, 0) timeRange:transitionTimeRange];

            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];

            break;
        }

        case kTransitionTypeLeftAndRightToMiddleInUpDownTransform: {
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];

            AVMutableVideoCompositionLayerInstruction *toLayerLeft = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerRight = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];

            [toLayerLeft setCropRectangle:CGRectMake(0, 0, videoWidth, videoHeight / 2.0) atTime:kCMTimeZero];
            [toLayerLeft setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            [toLayerRight setCropRectangle:CGRectMake(0, videoHeight / 2.0, videoWidth, videoHeight / 2.0) atTime:kCMTimeZero];
            [toLayerRight setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerRight, toLayerLeft, fromLayer, nil];
            break;
        }

        case kTransitionTypeMultiLeftRightToMiddleInUpDownTransform: {
            /**
                 <---R
             L--->
                 <---R
             L--->
                 <---R
             **/
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];

            AVMutableVideoCompositionLayerInstruction *toLayerRight1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack]; ///<---R
            AVMutableVideoCompositionLayerInstruction *toLayerLeft1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack]; ///L--->
            AVMutableVideoCompositionLayerInstruction *toLayerRight2 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack]; ///<---R
            AVMutableVideoCompositionLayerInstruction *toLayerLeft2 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack]; ///L--->
            AVMutableVideoCompositionLayerInstruction *toLayerRight3 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack]; ///<---R

            CGFloat height = videoHeight / 5.0;

            [toLayerRight1 setCropRectangle:CGRectMake(0, 0, videoWidth, height) atTime:kCMTimeZero];
            [toLayerRight1 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            [toLayerLeft1 setCropRectangle:CGRectMake(0, height, videoWidth, height) atTime:kCMTimeZero];
            [toLayerLeft1 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            [toLayerRight2 setCropRectangle:CGRectMake(0, height * 2, videoWidth, height) atTime:kCMTimeZero];
            [toLayerRight2 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            [toLayerLeft2 setCropRectangle:CGRectMake(0, height * 3, videoWidth, height) atTime:kCMTimeZero];
            [toLayerLeft2 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            [toLayerRight3 setCropRectangle:CGRectMake(0, height * 4, videoWidth, height) atTime:kCMTimeZero];
            [toLayerRight3 setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerRight1, toLayerLeft1, toLayerRight2, toLayerLeft2, toLayerRight3, fromLayer, nil];
            break;
        }

        case kTransitionTypeLeftAndRightToMiddleTransform: {
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];

            AVMutableVideoCompositionLayerInstruction *toLayerLeft = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerRight = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];

            [toLayerLeft setCropRectangle:CGRectMake(0, 0, videoWidth / 2.0, videoHeight) atTime:kCMTimeZero];
            [toLayerLeft setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth / 2.0, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            [toLayerRight setCropRectangle:CGRectMake(videoWidth / 2.0, 0, videoWidth / 2.0, videoHeight) atTime:kCMTimeZero];
            [toLayerRight setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth / 2.0, 0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerRight, toLayerLeft, fromLayer, nil];
            break;
        }
        case kTransitionTypeUpAndDownToMiddleInLeftRightTransform: {
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];

            AVMutableVideoCompositionLayerInstruction *toLayerUp = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerDown = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];

            [toLayerUp setTransform:CGAffineTransformScale(CGAffineTransformMakeRotation(-1.0), 1.5, 1) atTime:kCMTimeZero];
            [toLayerUp setCropRectangle:CGRectMake(0, 0, videoWidth / 2.0, videoHeight * 2) atTime:kCMTimeZero];

            [toLayerUp setTransformRampFromStartTransform:CGAffineTransformScale(CGAffineTransformMakeRotation(-1.0), 1.5, 1) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            [toLayerDown setCropRectangle:CGRectMake(videoWidth / 2.0, 0, videoWidth / 2.0, videoHeight) atTime:kCMTimeZero];
            [toLayerDown setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, videoHeight) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerUp, toLayerDown, fromLayer, nil];
            break;
        }
        case kTransitionTypeUpDownLeftAndRightToMiddleTransform: {
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];

            AVMutableVideoCompositionLayerInstruction *toLayerUpLeft = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerUpRight = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerDownLeft = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerDownRight = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];

            [toLayerUpLeft setCropRectangle:CGRectMake(0, 0, videoWidth / 2.0, videoHeight / 2.0) atTime:kCMTimeZero];
            [toLayerUpLeft setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth / 2.0, -videoHeight / 2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            [toLayerUpRight setCropRectangle:CGRectMake(videoWidth / 2.0, 0, videoWidth / 2.0, videoHeight / 2.0) atTime:kCMTimeZero];
            [toLayerUpRight setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth / 2.0, -videoHeight / 2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            [toLayerDownLeft setCropRectangle:CGRectMake(0, videoHeight / 2.0, videoWidth / 2.0, videoHeight / 2.0) atTime:kCMTimeZero];
            [toLayerDownLeft setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-videoWidth / 2.0, videoHeight / 2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            [toLayerDownRight setCropRectangle:CGRectMake(videoWidth / 2.0, videoHeight / 2.0, videoWidth / 2.0, videoHeight / 2.0) atTime:kCMTimeZero];
            [toLayerDownRight setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(videoWidth / 2.0, videoHeight / 2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerUpLeft, toLayerDownLeft, toLayerDownRight, toLayerUpRight, fromLayer, nil];
            break;
        }

        case kTransitionTypeUpAndDownToMiddleTransform: {
            [fromLayer setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:transitionTimeRange];

            AVMutableVideoCompositionLayerInstruction *toLayerUp = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];
            AVMutableVideoCompositionLayerInstruction *toLayerDown = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextcompositionVideoTrack];

            [toLayerUp setCropRectangle:CGRectMake(0, 0, videoWidth, videoHeight / 2.0) atTime:kCMTimeZero];
            [toLayerUp setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, -videoHeight / 2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            [toLayerDown setCropRectangle:CGRectMake(0.0, videoHeight / 2.0, videoWidth, videoHeight / 2.0) atTime:kCMTimeZero];
            [toLayerDown setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, videoHeight / 2.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayerUp, toLayerDown, fromLayer, nil];

            break;
        }
        case kTransitionTypePushHorizontalFromLeft: //水平从左至右
        {
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(compositionVideoTrack.naturalSize.width, 0.0) timeRange:transitionTimeRange];

            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(-compositionVideoTrack.naturalSize.width, 0.0) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            break;
        }
        case kTransitionTypePushVerticalFromBottom: {
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(0, -compositionVideoTrack.naturalSize.height) timeRange:transitionTimeRange];

            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, +compositionVideoTrack.naturalSize.height) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];
            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];
            break;
        }
        case kTransitionTypePushVerticalFromTop: {
            [fromLayer setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(0, compositionVideoTrack.naturalSize.height) timeRange:transitionTimeRange];

            [toLayer setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(0, -compositionVideoTrack.naturalSize.height) toEndTransform:CGAffineTransformIdentity timeRange:transitionTimeRange];

            transitionInstruction.layerInstructions = [NSArray arrayWithObjects:toLayer, fromLayer, nil];

            break;
        }
        default:
            break;
    }

    return transitionInstruction;
}

@end