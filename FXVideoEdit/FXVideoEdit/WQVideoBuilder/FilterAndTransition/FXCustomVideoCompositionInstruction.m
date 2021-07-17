//
//  FXCustomVideoCompositionInstruction.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/30.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXCustomVideoCompositionInstruction.h"
#import "CustomFilter.h"

@implementation FXCustomVideoCompositionLayerInstruction

- (instancetype)initWithTrackID:(CMPersistentTrackID)trackID
                      transform:(CGAffineTransform)transform
                      videoItem:(FXDescribe *)videoDescribe
                         filter:(CIFilter *)filter {
    if (self = [super init]) {
        NSParameterAssert(trackID != kCMPersistentTrackID_Invalid);
        self.trackID = trackID;
        self.transform = transform;
        self.videoDescribe = videoDescribe;
        self.filter = filter;
    }
    return self;
}

@end

#pragma mark

@implementation FXCustomVideoCompositionTransitionInstruction

@end

@interface FXCustomVideoCompositionInstruction ()



@end

#pragma mark

@interface FXCustomVideoCompositionInstruction ()

@property (nonatomic, strong) CustomFilter *filter;

@end

@implementation FXCustomVideoCompositionInstruction

+ (instancetype)new {
    FXCustomVideoCompositionInstruction *ins = [[FXCustomVideoCompositionInstruction alloc] init];
    ins.passthroughTrackID = kCMPersistentTrackID_Invalid;
    ins.requiredSourceTrackIDs = nil;
    ins.enablePostProcessing = YES;
    ins.containsTweening = NO;
    ins.timeRange = kCMTimeRangeInvalid;
    return ins;
}

- (instancetype)initWithPassthroughTrackID:(CMPersistentTrackID)passthroughTrackID timeRange:(CMTimeRange)timeRange {
    self = [super init];
    if (self) {
        _passthroughTrackID = passthroughTrackID;
        _timeRange = timeRange;
        _requiredSourceTrackIDs = @[];
        _containsTweening = NO;
        _enablePostProcessing = YES;
        _filter = [[CustomFilter alloc] init];
    }
    return self;
}

- (instancetype)initWithSourceTrackIDs:(NSArray<NSValue *> *)sourceTrackIDs timeRange:(CMTimeRange)timeRange {
    self = [super init];
    if (self) {
        _requiredSourceTrackIDs = sourceTrackIDs;
        _timeRange = timeRange;
        _passthroughTrackID = kCMPersistentTrackID_Invalid;
        _containsTweening = NO;
        _enablePostProcessing = YES;
        _filter = [[CustomFilter alloc] init];
    }
    return self;
}

#pragma mark - Public

- (CVPixelBufferRef)applyPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    self.filter.pixelBuffer = pixelBuffer;
    CVPixelBufferRef outputPixelBuffer = self.filter.outputPixelBuffer;
    CVPixelBufferRetain(outputPixelBuffer);
    return outputPixelBuffer;
}

@end
