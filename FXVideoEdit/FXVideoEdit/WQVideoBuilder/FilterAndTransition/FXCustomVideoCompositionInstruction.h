//
//  FXCustomVideoCompositionInstruction.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/30.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXFilter.h"
#import "FXTransitionDescribe.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "FXVideoDescribe.h"

@interface FXCustomVideoCompositionLayerInstruction : NSObject

@property (nonatomic, assign) CMPersistentTrackID trackID;

@property (nonatomic, assign) CMPersistentTrackID pipTrackID;

@property (nonatomic, assign) CGAffineTransform transform;

@property (nonatomic, strong, nullable) FXDescribe *videoDescribe;

@property (nonatomic, strong) CIFilter *filter;

- (instancetype)initWithTrackID:(CMPersistentTrackID)trackID
                      transform:(CGAffineTransform)transform
                      videoItem:(FXDescribe *)videoDescribe
                         filter:(CIFilter *)filter;

@end

/**
 必须给两个 trackID
 */
@interface FXCustomVideoCompositionTransitionInstruction : NSObject

@property (nonatomic, assign) CMPersistentTrackID forgroundTrackID;

@property (nonatomic, assign) CMPersistentTrackID backgroundTrackID;

@property (nonatomic, strong) FXTransitionDescribe *videoTransition;

@property (nonatomic, strong) FXFilter *filter;


@end

@interface FXCustomVideoCompositionInstruction : NSObject <AVVideoCompositionInstruction>

@property (nonatomic, assign) CMTimeRange timeRange;
@property (nonatomic, assign) BOOL enablePostProcessing;
@property (nonatomic) BOOL containsTweening;

@property (nonatomic, copy) NSArray<AVVideoCompositionLayerInstruction *> *_Nullable layerInstructions;
@property (nonatomic, assign, nullable) NSArray<NSValue *> *requiredSourceTrackIDs;
@property (nonatomic, assign) CMPersistentTrackID passthroughTrackID;

@property (nonatomic, strong) FXCustomVideoCompositionTransitionInstruction *transitionInstruction;

@property (nonatomic, strong) NSArray<FXCustomVideoCompositionLayerInstruction *> *simpleLayerInstructions;

@property (nonatomic, assign) int instructionType;

- (instancetype)initWithPassthroughTrackID:(CMPersistentTrackID)passthroughTrackID timeRange:(CMTimeRange)timeRange;
- (instancetype)initWithSourceTrackIDs:(NSArray<NSValue *> *)sourceTrackIDs timeRange:(CMTimeRange)timeRange;

/// 处理 pixelBuffer，并返回结果
- (CVPixelBufferRef)applyPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end
