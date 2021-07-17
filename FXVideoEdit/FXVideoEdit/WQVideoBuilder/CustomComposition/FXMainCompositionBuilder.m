//
//  FXOverlayCompositionBuilder.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXMainCompositionBuilder.h"
#import "FXAudioItem.h"
#import "FXCustomVideoCompositionInstruction.h"
#import "FXMainComposition.h"
#import "FXMediaItem.h"
#import "FXTitleItem.h"
#import "FXVideoCompositing.h"
#import "FXVideoItem.h"
#import "FXVideoTransition.h"

#import "FXAudioDescribe.h"
#import "FXCustomVideoCompositionInstruction.h"
#import "FXPipVideoComposition.h"
#import "FXTimelineDescribe.h"
#import "FXTransitionDescribe.h"
#import "FXVideoDescribe.h"
#import "FXPIPVideoDescribe.h"
#import "FXTimelineManager.h"
#import "FXTitleVideoComposition.h"

typedef enum : CMPersistentTrackID {
    KCMPersistentTrackIDVideoA = 100,
    KCMPersistentTrackIDVideoB,
    KCMPersistentTrackIDVideoC,
    KCMPersistentTrackIDAudioA,
    KCMPersistentTrackIDAudioB,
    KCMPersistentTrackIDAudioC,
    KCMPersistentTrackIDAudioD,
}KCMPersistentTrackID;

@interface FXMainCompositionBuilder ()

@property (strong, nonatomic) AVMutableComposition *composition;

@property (weak, nonatomic) AVMutableCompositionTrack *musicTrack;

@property (nonatomic, strong) AVMutableAudioMix *audioMix;

@property (nonatomic, strong) NSMutableArray *instructionArray;

@property (nonatomic, strong) FXTimelineDescribe *timelineDescribe;

@property (nonatomic, assign) BOOL buildForExport;

@end

@implementation FXMainCompositionBuilder

- (id)initWithTimeline:(FXTimelineDescribe *)timelineDescribe {
    self = [super init];
    if (self) {
        _timelineDescribe = timelineDescribe;
        _instructionArray = [NSMutableArray new];
    }
    return self;
}

- (FXMainComposition *)buildComposition {
//    _buildForExport = YES;

    self.composition = [AVMutableComposition composition];

    [self buildCompositionTracks];

    AVVideoComposition *videoComposition = [self buildVideoComposition];
    FXPipVideoComposition *video = [[FXPipVideoComposition alloc] initWithVideo:_timelineDescribe.pipVideoArray];
    FXTitleVideoComposition *title = [[FXTitleVideoComposition alloc] initWithTitle:_timelineDescribe.titleArray];
    return [[FXMainComposition alloc] // 1
        initWithComposition:self.composition
           videoComposition:videoComposition
                   audioMix:_audioMix
            titleLayer:[self createTextAnimationLayerWithText:_timelineDescribe.titleArray.firstObject]
                   videoPip:video
                      title:title];
}

- (FXMainComposition *)buildCompositionForExport {
    _buildForExport = YES;
    return [self buildComposition];
}



- (void)buildCompositionTracks {
    AVMutableCompositionTrack *compositionTrackA = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                 preferredTrackID:KCMPersistentTrackIDVideoA];
    AVMutableCompositionTrack *compositionTrackB = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                 preferredTrackID:KCMPersistentTrackIDVideoB];
    
    //画中画轨道
    AVMutableCompositionTrack *compositionTrackC = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                 preferredTrackID:KCMPersistentTrackIDVideoC];
    
    NSArray *videoTracks = @[compositionTrackA, compositionTrackB];

    AVMutableCompositionTrack *audioTrackA = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                           preferredTrackID:KCMPersistentTrackIDAudioA];
    AVMutableCompositionTrack *audioTrackB = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                           preferredTrackID:KCMPersistentTrackIDAudioB];

    AVMutableCompositionTrack *audioTrackC = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                           preferredTrackID:KCMPersistentTrackIDAudioC];
    AVMutableCompositionTrack *audioTrackD = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                           preferredTrackID:KCMPersistentTrackIDAudioD];
    NSArray *audioTracks = @[audioTrackA, audioTrackB];

    //AB 轨道，用来做视频转场

    CMTime cursorTime = kCMTimeZero;

    NSArray *videos = self.timelineDescribe.videoArray;

    [_instructionArray removeAllObjects];

    FXTransitionDescribe *lastDescribe = nil;
    for (NSUInteger i = 0; i < videos.count; i++) {
        NSUInteger trackIndex = i % 2;

        FXVideoDescribe *videoDescribe = videos[i];
        FXTransitionDescribe *transDescribe = [[FXTimelineManager sharedInstance] transitionItemWithPreIndex:i backIndex:i + 1];

        AVMutableCompositionTrack *currentTrack = videoTracks[trackIndex];
        AVMutableCompositionTrack *currentAudioTrack = audioTracks[trackIndex];

        AVAssetTrack *assetTrack = videoDescribe.videoItem.videoTrack;
        [currentTrack insertTimeRange:videoDescribe.sourceRange
                              ofTrack:assetTrack
                               atTime:cursorTime
                                error:nil];
        videoDescribe.trackID = currentTrack.trackID;
        [currentTrack scaleTimeRange:CMTimeRangeMake(cursorTime, videoDescribe.sourceRange.duration)
                          toDuration:videoDescribe.duration];

        AVAssetTrack *audioAssetTrack = videoDescribe.videoItem.audioTrack;
        [currentAudioTrack insertTimeRange:videoDescribe.sourceRange
                                   ofTrack:audioAssetTrack
                                    atTime:cursorTime error:nil];
        [currentAudioTrack scaleTimeRange:CMTimeRangeMake(cursorTime, videoDescribe.sourceRange.duration)
                               toDuration:videoDescribe.duration];
        
        cursorTime = CMTimeAdd(cursorTime, videoDescribe.duration);
        if (transDescribe) {
            cursorTime = CMTimeSubtract(cursorTime, transDescribe.duration);
        }
        lastDescribe = transDescribe;
    }
    cursorTime = kCMTimeZero;
    if (self.timelineDescribe.audioArray.count) {
        for (FXAudioDescribe *audioDescribe in self.timelineDescribe.audioArray) {
            AVAssetTrack *audioAssetTrack = audioDescribe.audioItem.audioTrack;
            [audioTrackD insertTimeRange:audioDescribe.sourceRange
                                       ofTrack:audioAssetTrack
                                        atTime:cursorTime error:nil];
            cursorTime = CMTimeAdd(cursorTime, audioDescribe.duration);
        }
    }
    if (_buildForExport) {
        NSArray *pipVideos = self.timelineDescribe.pipVideoArray;
        for (FXPIPVideoDescribe *pipVideoDes in pipVideos) {
            AVAssetTrack *assetTrack = pipVideoDes.videoItem.videoTrack;
            AVAssetTrack *assetAudioTrack = pipVideoDes.videoItem.audioTrack;
            [compositionTrackC insertTimeRange:pipVideoDes.sourceRange
                                  ofTrack:assetTrack
                                        atTime:pipVideoDes.startTime
                                    error:nil];
            [audioTrackC insertTimeRange:pipVideoDes.sourceRange
                                 ofTrack:assetAudioTrack
                                  atTime:pipVideoDes.startTime
                                   error:nil];
        }
    }
    _audioMix = [AVMutableAudioMix audioMix];
    NSMutableArray<AVMutableAudioMixInputParameters *> *inputParametersArray = @[].mutableCopy;
    NSMutableArray<AVMutableAudioMixInputParameters *> *audioParametersArray = @[].mutableCopy;
    AVMutableAudioMixInputParameters *audioParametersA = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrackA];
    audioParametersA.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmTimeDomain;
    AVMutableAudioMixInputParameters *audioParametersB = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrackB];
    audioParametersB.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmTimeDomain;
    AVMutableAudioMixInputParameters *audioParametersC = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrackC];
    audioParametersC.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmTimeDomain;
    AVMutableAudioMixInputParameters *audioParametersD = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrackD];
    audioParametersD.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmTimeDomain;
    [audioParametersD setVolume:1.0 atTime:kCMTimeZero];
    [audioParametersArray addObject:audioParametersA];
    [audioParametersArray addObject:audioParametersB];
    [audioParametersArray addObject:audioParametersC];

    if (_buildForExport) {
        [audioParametersArray addObject:audioParametersD];
    }
    [inputParametersArray addObjectsFromArray:audioParametersArray];
    _audioMix.inputParameters = inputParametersArray;
}

- (BOOL)isTweeningTransition:(FXTransitionDescribe *)transition {
    if (!transition)
        return NO;
    if (CMTIME_IS_VALID(transition.duration) && CMTimeCompare(transition.duration, kCMTimeZero) == 1) {
        return YES;
    }
    return NO;
}


- (AVVideoComposition *)buildVideoComposition {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:self.composition];
    [self buildVideoCompositionInstructions:videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.customVideoCompositorClass = [FXVideoCompositing class];
    videoComposition.instructions = _instructionArray;
    videoComposition.renderSize = self.timelineDescribe.defaultNaturalSize;
    return videoComposition;
}

- (void)buildVideoCompositionInstructions:(AVMutableVideoComposition *)videoComposition
{
    [_instructionArray removeAllObjects];
    NSArray *insArray =  videoComposition.instructions;
    for (AVMutableVideoCompositionInstruction *vci in insArray) {
        if (vci.layerInstructions.count == 1) {
            //只有一个
            AVVideoCompositionLayerInstruction *layerInstruction = vci.layerInstructions.firstObject;
            FXVideoDescribe *video = [self videoDescribeWithTimeRange:vci.timeRange track:layerInstruction.trackID];
            FXCustomVideoCompositionInstruction *instruction = [FXCustomVideoCompositionInstruction new];
            instruction.simpleLayerInstructions = @[[self createLayerInsWithVideoItem:video andTrackID:layerInstruction.trackID]];
            instruction.timeRange = vci.timeRange;
            [_instructionArray addObject:instruction];
        }
        else if (vci.layerInstructions.count == 2){
            BOOL hasPip = NO;
            FXPIPVideoDescribe *pipVideoDescribe;
            FXVideoDescribe *videoDescribe;
            CMPersistentTrackID pipTrackID = 0;
            CMPersistentTrackID videoTrackID = 0;
            for (AVVideoCompositionLayerInstruction *layerInstruction in vci.layerInstructions) {
                if (layerInstruction.trackID == KCMPersistentTrackIDVideoC) {
                    hasPip = YES;
                    pipVideoDescribe = [self pipVideoDescribeWithTimeRange:vci.timeRange track:layerInstruction.trackID];
                    pipTrackID = layerInstruction.trackID;
                }
                else{
                    videoDescribe = [self videoDescribeWithTimeRange:vci.timeRange track:layerInstruction.trackID];
                    videoTrackID = layerInstruction.trackID;
                }
            }
            if (hasPip) {
                FXCustomVideoCompositionInstruction *instruction = [FXCustomVideoCompositionInstruction new];
                FXCustomVideoCompositionLayerInstruction *forlayerIns = [self createLayerInsWithVideoItem:videoDescribe andTrackID:videoTrackID];
                FXCustomVideoCompositionLayerInstruction *backLayerIns = [self createLayerInsWithPipVideoItem:pipVideoDescribe andTrackID:pipTrackID];
                instruction.timeRange = vci.timeRange;
                instruction.simpleLayerInstructions = @[forlayerIns, backLayerIns];
                [_instructionArray addObject:instruction];
            }
            else{
                AVVideoCompositionLayerInstruction *firstLayerInstruction = vci.layerInstructions.firstObject;
                AVVideoCompositionLayerInstruction *secondLayerInstruction = vci.layerInstructions.lastObject;
                FXVideoDescribe *one = [self videoDescribeWithTimeRange:vci.timeRange track:firstLayerInstruction.trackID];
                FXVideoDescribe *two = [self videoDescribeWithTimeRange:vci.timeRange track:secondLayerInstruction.trackID];
                FXVideoDescribe *preVideoDescribe;
                FXVideoDescribe *backVideoDescribe;
                CMPersistentTrackID forgroundTrackID;
                CMPersistentTrackID backgroundTrackID;
                if (one.videoIndex < two.videoIndex) {
                    preVideoDescribe = one;
                    backVideoDescribe = two;
                    forgroundTrackID = firstLayerInstruction.trackID;
                    backgroundTrackID = secondLayerInstruction.trackID;
                }
                else{
                    preVideoDescribe = two;
                    backVideoDescribe = one;
                    forgroundTrackID = secondLayerInstruction.trackID;
                    backgroundTrackID = firstLayerInstruction.trackID;
                }
                FXCustomVideoCompositionInstruction *transitionIns = [FXCustomVideoCompositionInstruction new];
                transitionIns.transitionInstruction = [FXCustomVideoCompositionTransitionInstruction new];
                transitionIns.transitionInstruction.forgroundTrackID = forgroundTrackID;
                transitionIns.transitionInstruction.backgroundTrackID = backgroundTrackID;
                FXTransitionDescribe *transDescribe = [[FXTimelineManager sharedInstance] transitionItemWithPreIndex:preVideoDescribe.videoIndex backIndex:backVideoDescribe.videoIndex];
                transitionIns.transitionInstruction.videoTransition = transDescribe;
                FXFilter *filter = [FXFilter initWithTransType:transDescribe.transType];
                transitionIns.transitionInstruction.filter = filter;
                
                FXCustomVideoCompositionLayerInstruction *forlayerIns = [self createLayerInsWithVideoItem:preVideoDescribe andTrackID:forgroundTrackID];
                FXCustomVideoCompositionLayerInstruction *backLayerIns = [self createLayerInsWithVideoItem:backVideoDescribe andTrackID:backgroundTrackID];
                transitionIns.timeRange = vci.timeRange;
                transitionIns.simpleLayerInstructions = @[forlayerIns, backLayerIns];
                [_instructionArray addObject:transitionIns];
            }
        }
        else if (vci.layerInstructions.count == 3){
            NSMutableArray *array = [NSMutableArray new];
            
            AVVideoCompositionLayerInstruction *pipLayerInstruction = nil;
            for (AVVideoCompositionLayerInstruction *layerInstruction in vci.layerInstructions) {
                if (layerInstruction.trackID == KCMPersistentTrackIDVideoC) {
                    pipLayerInstruction = layerInstruction;
                }
                else{
                    [array addObject:layerInstruction];
                }
            }
            
            AVVideoCompositionLayerInstruction *firstLayerInstruction = array.firstObject;
            AVVideoCompositionLayerInstruction *secondLayerInstruction = [array lastObject];
            FXVideoDescribe *one = [self videoDescribeWithTimeRange:vci.timeRange track:firstLayerInstruction.trackID];
            FXVideoDescribe *two = [self videoDescribeWithTimeRange:vci.timeRange track:secondLayerInstruction.trackID];
            FXPIPVideoDescribe *pip = [self pipVideoDescribeWithTimeRange:vci.timeRange track:pipLayerInstruction.trackID];
            FXVideoDescribe *preVideoDescribe;
            FXVideoDescribe *backVideoDescribe;
            CMPersistentTrackID forgroundTrackID;
            CMPersistentTrackID backgroundTrackID;
            if (one.videoIndex < two.videoIndex) {
                preVideoDescribe = one;
                backVideoDescribe = two;
                forgroundTrackID = firstLayerInstruction.trackID;
                backgroundTrackID = secondLayerInstruction.trackID;
            }
            else{
                preVideoDescribe = two;
                backVideoDescribe = one;
                forgroundTrackID = secondLayerInstruction.trackID;
                backgroundTrackID = firstLayerInstruction.trackID;
            }
            FXCustomVideoCompositionInstruction *transitionIns = [FXCustomVideoCompositionInstruction new];
            transitionIns.transitionInstruction = [FXCustomVideoCompositionTransitionInstruction new];
            transitionIns.transitionInstruction.forgroundTrackID = forgroundTrackID;
            transitionIns.transitionInstruction.backgroundTrackID = backgroundTrackID;
            FXTransitionDescribe *transDescribe = [[FXTimelineManager sharedInstance] transitionItemWithPreIndex:preVideoDescribe.videoIndex backIndex:backVideoDescribe.videoIndex];
            transitionIns.transitionInstruction.videoTransition = transDescribe;
            FXFilter *filter = [FXFilter initWithTransType:transDescribe.transType];
            transitionIns.transitionInstruction.filter = filter;
            FXCustomVideoCompositionLayerInstruction *forlayerIns = [self createLayerInsWithVideoItem:preVideoDescribe andTrackID:forgroundTrackID];
            FXCustomVideoCompositionLayerInstruction *backLayerIns = [self createLayerInsWithVideoItem:backVideoDescribe andTrackID:backgroundTrackID];
            FXCustomVideoCompositionLayerInstruction *pipLayerIns = [self createLayerInsWithPipVideoItem:pip andTrackID:pipLayerInstruction.trackID];
            transitionIns.timeRange = vci.timeRange;
            transitionIns.simpleLayerInstructions = @[forlayerIns, backLayerIns,pipLayerIns];
            [_instructionArray addObject:transitionIns];
        }
    }
}

- (FXCustomVideoCompositionLayerInstruction *)createLayerInsWithVideoItem:(FXVideoDescribe *)videoDescribe
                                                               andTrackID:(CMPersistentTrackID)trackID
{
    CGAffineTransform rotate = [FXSizeHelper transformFromRotate:videoDescribe.rotate natureSize:videoDescribe.videoItem.videoTrack.naturalSize];
    CGAffineTransform transform = [FXSizeHelper scaleTransformWithNatureSize:videoDescribe.videoItem.videoTrack.naturalSize natureTrans:rotate renderSize:_timelineDescribe.defaultNaturalSize toRotate:videoDescribe.rotate];
    return [[FXCustomVideoCompositionLayerInstruction alloc] initWithTrackID:trackID
                                                                   transform:transform
                                                                   videoItem:videoDescribe
                                                                      filter:[FXFilterDescribe filterWithType:videoDescribe.filterType]];
}

- (FXCustomVideoCompositionLayerInstruction *)createLayerInsWithPipVideoItem:(FXPIPVideoDescribe *)videoDescribe
                                                               andTrackID:(CMPersistentTrackID)trackID
{
    CGSize natureSize;
    CGSize renderSize = _timelineDescribe.defaultNaturalSize;
    if (renderSize.width < renderSize.height) {
        CGFloat width = renderSize.width*videoDescribe.widthPercent*videoDescribe.scaleSize;
        CGFloat height = width * renderSize.height/renderSize.width;
        natureSize = CGSizeMake(width, height);
    }
    else{
        CGFloat height = renderSize.height*videoDescribe.widthPercent*videoDescribe.scaleSize;
        CGFloat width = height * renderSize.width/renderSize.height;
        natureSize = CGSizeMake(width, height);
    }
    CGFloat scale = natureSize.width/videoDescribe.videoItem.videoTrack.naturalSize.width;
    
    CGPoint translate = CGPointMake(renderSize.width*videoDescribe.centerXP - renderSize.width * scale/2, renderSize.height *(1- scale/2 - videoDescribe.centerYP));

    CGAffineTransform scaleTrans = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform moveTrans = CGAffineTransformTranslate(scaleTrans, translate.x / scale, translate.y /scale);
    
    CGAffineTransform roateTransform = CGAffineTransformMakeRotation(-videoDescribe.rotateAngle);
    CGAffineTransform finallyTransform = CGAffineTransformMake(scale, roateTransform.b, roateTransform.c, scale, moveTrans.tx, moveTrans.ty);
    
    
    
    return [[FXCustomVideoCompositionLayerInstruction alloc] initWithTrackID:trackID
                                                                   transform:finallyTransform
                                                                   videoItem:videoDescribe
                                                                      filter:nil];
}

- (FXVideoDescribe *)videoDescribeWithTimeRange:(CMTimeRange)timeRange
                                          track:(KCMPersistentTrackID)track
{
    for (FXVideoDescribe *describe in self.timelineDescribe.videoArray) {
        if (describe.trackID == track) {
            CMTimeRange range = CMTimeRangeMake(describe.startTime, describe.duration);
            if (CMTimeRangeContainsTimeRange(range, timeRange)) {
                return describe;
            }
        }
    }
    return nil;
}

- (FXPIPVideoDescribe *)pipVideoDescribeWithTimeRange:(CMTimeRange)timeRange
                                          track:(KCMPersistentTrackID)track
{
    for (FXPIPVideoDescribe *describe in self.timelineDescribe.pipVideoArray) {
        CMTimeRange range = CMTimeRangeMake(describe.startTime, describe.duration);
        if (CMTimeRangeContainsTimeRange(range, timeRange)) {
            return describe;
        }
    }
    return nil;
}


#pragma mark title

- (CALayer *)createTextAnimationLayerWithText:(FXTitleDescribe *)titleDescribe
{
    CGRect videoFrame = CGRectMake(0, 0, _timelineDescribe.defaultNaturalSize.width, _timelineDescribe.defaultNaturalSize.height);
    CATextLayer *textLayer = [[CATextLayer alloc] init];
//    UIFont *font = [UIFont systemFontOfSize:100];
//    [textLayer setFont:(__bridge CFTypeRef _Nullable)(font)];
    [textLayer setFontSize:36];
    [textLayer setFrame:CGRectMake(0,
                                   0,
                                   videoFrame.size.width,
                                   videoFrame.size.height - 100)];
    [textLayer setString:titleDescribe.text];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    textLayer.opacity = 0;
    [textLayer setForegroundColor:[[UIColor redColor] CGColor]];
    
    CGFloat fontSize = 64.0f;
    UIFont *font = [UIFont fontWithName:@"GillSans-Bold" size:fontSize];
    NSDictionary *attrs =
        @{NSFontAttributeName            : font,
          NSForegroundColorAttributeName : (id) [UIColor whiteColor].CGColor};

    NSAttributedString *string =
        [[NSAttributedString alloc] initWithString:@"KKKK" attributes:attrs];

    CGSize textSize = [@"KKKK" sizeWithAttributes:attrs];

    CATextLayer *layer = [CATextLayer layer];
    layer.string = string;
    layer.bounds = CGRectMake(0.0f, 0.0f, textSize.width, textSize.height);
    layer.position = CGPointMake(200, 470.0f);
    layer.backgroundColor = [UIColor clearColor].CGColor;
    
    
    CAKeyframeAnimation *fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.beginTime = CMTimeGetSeconds(titleDescribe.startTime);
    fadeAnimation.duration  = CMTimeGetSeconds(titleDescribe.duration);
    fadeAnimation.values = @[@(0),@(1.0),@(1.0),@(0)];
    fadeAnimation.keyTimes = @[@(0),@(1/8.),@(7/8.),@(1)];
    fadeAnimation.removedOnCompletion = NO;
    [layer addAnimation:fadeAnimation forKey:@"fade"];
    
    CALayer *parentLayer = [CALayer layer];                                 // 2
    parentLayer.frame = videoFrame;
    parentLayer.opacity = 0.0f;
    [parentLayer addSublayer:layer];
    return parentLayer;
}


@end
