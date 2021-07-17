//
//  FXVideoCompositing.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/30.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoCompositing.h"
#import "FXCustomVideoCompositionInstruction.h"
#import "FXFilterDescribe.h"
#import "FXPIPVideoDescribe.h"

@interface FXVideoCompositing ()

@property (nonatomic, strong) dispatch_queue_t renderContextQueue;
@property (nonatomic, strong) dispatch_queue_t renderingQueue;
@property (nonatomic, assign) BOOL shouldCancelAllRequests;

@property (nonatomic, strong) AVVideoCompositionRenderContext *renderContext;
@property (nonatomic, strong) CIContext *context;

@end

@implementation FXVideoCompositing

- (instancetype)init {
    self = [super init];
    if (self) {
        _sourcePixelBufferAttributes = @{(id)kCVPixelBufferOpenGLCompatibilityKey: @YES,
                                         (id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
        _requiredPixelBufferAttributesForRenderContext = @{(id)kCVPixelBufferOpenGLCompatibilityKey: @YES,
                                                           (id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};

        _renderContextQueue = dispatch_queue_create("com.xunni.rendercontextqueue", 0);
        _renderingQueue = dispatch_queue_create("com.xunni.renderingqueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (CIContext *)context {
    if (!_context) {
        //        EAGLContext *conte = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (void)renderContextChanged:(AVVideoCompositionRenderContext *)newRenderContext {
    dispatch_sync(self.renderContextQueue, ^{
        self.renderContext = newRenderContext;
    });
}

- (void)startVideoCompositionRequest:(AVAsynchronousVideoCompositionRequest *)asyncVideoCompositionRequest {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.renderingQueue, ^{
        @autoreleasepool {
            if (self.shouldCancelAllRequests) {
                [asyncVideoCompositionRequest finishCancelledRequest];
            } else {
                CVPixelBufferRef resultPixels = NULL;
                NSError *err = nil;
                FXCustomVideoCompositionInstruction *videoCompositionInstruction = asyncVideoCompositionRequest.videoCompositionInstruction;
                if (videoCompositionInstruction.transitionInstruction) {
                    //有转场
                    resultPixels = [weakSelf finishTweeningCompositionRequest:asyncVideoCompositionRequest error:&err];
                } else {
                    resultPixels = [weakSelf finishPassthroughCompositionRequest:asyncVideoCompositionRequest error:&err];
                }
                if (resultPixels) {
                    [asyncVideoCompositionRequest finishWithComposedVideoFrame:resultPixels];
                    CVPixelBufferRelease(resultPixels);
                } else {
                    [asyncVideoCompositionRequest finishWithError:err];
                }
            }
        }
    });
}

- (CVPixelBufferRef)finishTweeningCompositionRequest:(AVAsynchronousVideoCompositionRequest *)request error:(NSError **)errOut {
    FXCustomVideoCompositionInstruction *videoCompositionInstruction = request.videoCompositionInstruction;
    FXCustomVideoCompositionTransitionInstruction *transitionIns = videoCompositionInstruction.transitionInstruction;
    CVPixelBufferRef foregroundSourceBuffer = [request sourceFrameByTrackID:transitionIns.forgroundTrackID];
    CVPixelBufferRef backgroundSourceBuffer = [request sourceFrameByTrackID:transitionIns.backgroundTrackID];
    CIImage *forImage = [CIImage imageWithCVPixelBuffer:foregroundSourceBuffer];
    CIImage *backImage = [CIImage imageWithCVPixelBuffer:backgroundSourceBuffer];
    FXCustomVideoCompositionLayerInstruction *forLayerInstructions = videoCompositionInstruction.simpleLayerInstructions.firstObject;
    FXCustomVideoCompositionLayerInstruction *backLayerInstructions = videoCompositionInstruction.simpleLayerInstructions.lastObject;
    forImage = [forImage imageByApplyingTransform:forLayerInstructions.transform];
    backImage = [backImage imageByApplyingTransform:backLayerInstructions.transform];
    
    FXFilter *filter = transitionIns.filter;
    [filter setForgroundImage:forImage];
    [filter setBackgroundImage:backImage];

    float tweenFactor = factorForTimeInRange(request.compositionTime, request.videoCompositionInstruction.timeRange);
    [filter setInputTime:[NSNumber numberWithFloat:tweenFactor]];
    CIImage *desImage = filter.outputImage;
    CVPixelBufferRef pixelBuffer = [self createEmptyPixelBuffer];
    [self.context render:desImage toCVPixelBuffer:pixelBuffer];
    return pixelBuffer;
}

- (CVPixelBufferRef)finishPassthroughCompositionRequest:(AVAsynchronousVideoCompositionRequest *)request error:(NSError **)errOut {
    FXCustomVideoCompositionInstruction *videoCompositionInstruction = request.videoCompositionInstruction;
    NSArray <FXCustomVideoCompositionLayerInstruction *>*videoInstructionArray = videoCompositionInstruction.simpleLayerInstructions;
    FXCustomVideoCompositionLayerInstruction *layerInstructions = videoInstructionArray.firstObject;
    FXCustomVideoCompositionLayerInstruction *piplayerInstructions;
    if (videoInstructionArray.count == 2) {
        piplayerInstructions = [videoInstructionArray lastObject];
    }
    CMPersistentTrackID trackID = layerInstructions.trackID;

    CVPixelBufferRef pixelBuffer = [self createEmptyPixelBuffer];
    CVPixelBufferRef sourcePixelBuffer = [request sourceFrameByTrackID:trackID];
    CIImage *sourceImage = [CIImage imageWithCVPixelBuffer:sourcePixelBuffer];
    CIFilter *colorFilter = layerInstructions.filter;
    if (colorFilter) {
        [colorFilter setValue:sourceImage forKey:@"inputImage"];
        sourceImage = colorFilter.outputImage;
    }
    CIFilter* filter = [CIFilter filterWithName:@"CIAffineTransform"];
    [filter setValue:[NSValue valueWithCGAffineTransform:layerInstructions.transform] forKey:@"inputTransform"];
    [filter setValue:sourceImage forKey:@"inputImage"];
    
    [self.context render:filter.outputImage toCVPixelBuffer:pixelBuffer];
    
    if (piplayerInstructions) {
        sourceImage = [CIImage imageWithCVImageBuffer:pixelBuffer];
        CMPersistentTrackID pipTrackID = piplayerInstructions.trackID;
        CVPixelBufferRef pipPixelBuffer = [request sourceFrameByTrackID:pipTrackID];
        CIImage *pipImage = [CIImage imageWithCVPixelBuffer:pipPixelBuffer];
        
        FXPIPVideoDescribe *videoDescribe = (FXPIPVideoDescribe *)piplayerInstructions.videoDescribe;
        CGSize natureSize;
        FXVideoDescribe *origiDescribe = (FXVideoDescribe *)layerInstructions.videoDescribe;
        CGSize renderSize = origiDescribe.videoItem.videoTrack.naturalSize;
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
        
        CGSize backSize = sourceImage.extent.size;
        CGPoint translate = CGPointMake(backSize.width*videoDescribe.centerXP, backSize.height *(1 - videoDescribe.centerYP));

        CGAffineTransform scaleTrans = CGAffineTransformMakeScale(scale, scale);
        
        CGFloat initialAngle = videoDescribe.rotateAngle;
        CGAffineTransform roateTransform;
        if (fabs(fmodf(initialAngle, M_PI_2)) < M_PI / 90) {
            roateTransform = CGAffineTransformMakeRotation((int)(initialAngle / M_PI_2) * M_PI_2);
        } else {
            roateTransform = CGAffineTransformMakeRotation(initialAngle);
        }
                
        pipImage = [pipImage imageByApplyingTransform:roateTransform];
        pipImage = [pipImage imageByApplyingTransform:scaleTrans];

        
        CGRect rect = pipImage.extent;
        CGPoint centerPoint = CGPointMake(rect.size.width/2 , rect.size.height/2 + rect.origin.y);

        CGAffineTransform moveTrans = CGAffineTransformTranslate(CGAffineTransformIdentity,translate.x - centerPoint.x,translate.y - centerPoint.y);

        NSValue *valuess = [NSValue valueWithCGAffineTransform:moveTrans];
        CIFilter* filter2 = [CIFilter filterWithName:@"CIAffineTransform"];
        [filter2 setValue:valuess forKey:@"inputTransform"];
        [filter2 setValue:pipImage forKey:@"inputImage"];
        
        CIImage *inputImage = filter2.outputImage;
        CGRect cropRect = sourceImage.extent;
        
        CIFilter* filter3 = [CIFilter filterWithName:@"CISourceOverCompositing"];
        [filter3 setValue:inputImage forKey:@"inputImage"];
        [filter3 setValue:sourceImage forKey:@"inputBackgroundImage"];
        
        CIImage *images = filter3.outputImage;
        images = [images imageByCroppingToRect:cropRect];
        [self.context render:images toCVPixelBuffer:pixelBuffer];
    }
    return pixelBuffer;
}

- (void)cancelAllPendingVideoCompositionRequests {
    self.shouldCancelAllRequests = YES;
    dispatch_barrier_async(self.renderingQueue, ^{
        self.shouldCancelAllRequests = NO;
    });
}

#pragma mark - Private

- (CVPixelBufferRef)newRenderdPixelBufferForRequest:(AVAsynchronousVideoCompositionRequest *)request {
    FXCustomVideoCompositionInstruction *videoCompositionInstruction = (FXCustomVideoCompositionInstruction *)request.videoCompositionInstruction;
    NSArray<AVVideoCompositionLayerInstruction *> *layerInstructions = videoCompositionInstruction.layerInstructions;
    CMPersistentTrackID trackID = layerInstructions.firstObject.trackID;

    CVPixelBufferRef sourcePixelBuffer = [request sourceFrameByTrackID:trackID];
    CVPixelBufferRef resultPixelBuffer = [videoCompositionInstruction applyPixelBuffer:sourcePixelBuffer];

    if (!resultPixelBuffer) {
        CVPixelBufferRef emptyPixelBuffer = [self createEmptyPixelBuffer];
        return emptyPixelBuffer;
    } else {
        return resultPixelBuffer;
    }
}

/// 创建一个空白的视频帧
- (CVPixelBufferRef)createEmptyPixelBuffer {
    CVPixelBufferRef pixelBuffer = [self.renderContext newPixelBuffer];
    CIImage *image = [CIImage imageWithColor:[CIColor grayColor]];
    [self.context render:image toCVPixelBuffer:pixelBuffer];
    return pixelBuffer;
}

#pragma mark - Accessors
// 用 CIImage 加滤镜

static Float64 factorForTimeInRange(CMTime time, CMTimeRange range) /* 0.0 -> 1.0 */
{
    CMTime elapsed = CMTimeSubtract(time, range.start);
    return CMTimeGetSeconds(elapsed) / CMTimeGetSeconds(range.duration);
}

@end
