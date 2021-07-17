//
//  FXVideoItem.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoItem.h"
#import "FXVideoTrimView.h"

@interface FXVideoItem () <FXVideoTrimViewDelegate>

@property (strong, nonatomic) AVAssetImageGenerator *imageGenerator;

@property (strong, nonatomic) NSMutableArray *images;

@property (nonatomic, strong) NSMutableDictionary *imageFrameDictionary;

@end

@implementation FXVideoItem

+ (id)videoItemWithURL:(NSURL *)url {
    return [[self alloc] initWithURL:url];
}

- (id)initWithURL:(NSURL *)url {
    self = [super initWithURL:url];
    if (self) {
        _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
        _imageGenerator.maximumSize = CGSizeMake(120, 120);
        _thumbnails = @[];
        _images = [NSMutableArray arrayWithCapacity:4];
        _imageFrameDictionary = [NSMutableDictionary new];
    }
    return self;
}

- (id)initWithAvAsset:(AVAsset *)videoAsset
{
    AVURLAsset *urlAsset = (AVURLAsset *)videoAsset;
    self = [super initWithURL:urlAsset.URL];
    if (self) {
        _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
        _imageGenerator.maximumSize = CGSizeMake(120, 120);
        _thumbnails = @[];
        _images = [NSMutableArray arrayWithCapacity:4];
        _imageFrameDictionary = [NSMutableDictionary new];
    }
    return self;
}


- (AVAssetTrack *)videoTrack {
    AVAssetTrack *track = [self.asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    return track;
}

- (AVAssetTrack *)audioTrack {
    AVAssetTrack *track = [self.asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    return track;
}

- (NSString *)mediaType {
    return AVMediaTypeVideo;
}

- (void)performPostPrepareActionsWithCompletionBlock:(FXPreparationCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self generateThumbnailsWithCompletionBlock:completionBlock];
    });
}

- (void)generateThumbnailsWithCompletionBlock:(FXPreparationCompletionBlock)completionBlock {
    CMTime timeStep = CMTimeMake(600, 600);
    NSMutableArray *timeArray = [NSMutableArray new];

    CMTimeRange range = self.timeRange;

    CMTime startTime = range.start;
    while (CMTimeCompare(startTime, range.duration) < 0) {
        NSValue *timeValue = [NSValue valueWithCMTime:startTime];
        [timeArray addObject:timeValue];
        startTime = CMTimeAdd(startTime, timeStep);
    }
    __block NSUInteger count = 0;
    __weak typeof(self) weakSelf = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:timeArray
                                              completionHandler:^(CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *_Nullable error) {
                                                  UIImage *videoImage = [UIImage imageWithCGImage:image];
                                                  [weakSelf.imageFrameDictionary setObject:[self cropImage:videoImage] forKey:[self timeKeyForCMTime:requestedTime]];
                                                  count++;
                                                  if (count == timeArray.count) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          completionBlock(YES);
                                                          [weakSelf loadHalfImage];
                                                      });
                                                  }
                                              }];
}

- (void)loadHalfImage {
    CMTime timeStep = CMTimeMake(600, 600);
    NSMutableArray *timeArray = [NSMutableArray new];

    CMTimeRange range = self.timeRange;

    CMTime startTime = CMTimeAdd(CMTimeMake(300, 600), range.start);
    while (CMTimeCompare(startTime, range.start) < 0) {
        NSValue *timeValue = [NSValue valueWithCMTime:startTime];
        [timeArray addObject:timeValue];
        startTime = CMTimeAdd(startTime, timeStep);
    }
    __block NSUInteger count = 0;
    __weak typeof(self) weakSelf = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:timeArray
                                              completionHandler:^(CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *_Nullable error) {
                                                  UIImage *videoImage = [UIImage imageWithCGImage:image];
                                                  [weakSelf.imageFrameDictionary setObject:[self cropImage:videoImage] forKey:[self timeKeyForCMTime:requestedTime]];
                                                  count++;
                                                  if (count == timeArray.count) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{

                                                                     });
                                                  }
                                              }];
}

- (void)loadAllUnLoadImage {
    CMTime timeStep = CMTimeMake(300, 600);
    NSMutableArray *timeArray = [NSMutableArray new];

    CMTimeRange range = self.timeRange;
    CMTime startTime = CMTimeAdd(CMTimeMake(150, 600), range.start);

    while (CMTimeCompare(startTime, range.duration) < 0) {
        NSValue *timeValue = [NSValue valueWithCMTime:startTime];
        [timeArray addObject:timeValue];
        startTime = CMTimeAdd(startTime, timeStep);
    }
    __block NSUInteger count = 0;
    __weak typeof(self) weakSelf = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:timeArray
                                              completionHandler:^(CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *_Nullable error) {
                                                  UIImage *videoImage = [UIImage imageWithCGImage:image];
                                                  [weakSelf.imageFrameDictionary setObject:videoImage forKey:[self timeKeyForCMTime:requestedTime]];
                                                  count++;
                                                  if (count == timeArray.count) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                     });
                                                  }
                                              }];
}

- (UIImage *)cropImage:(UIImage *)sourceImage {
    UIImage *newImage = [sourceImage imageByCropToRect:CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.width)];
    return newImage;
}

#pragma mark function

- (NSString *)timeKeyForCMTime:(CMTime)time {
    NSString *timeKeyString = nil;
    if (time.value == 0) {
        timeKeyString = [NSString stringWithFormat:@"%lld+1", time.value];
    } else {
        if (time.timescale == 600) {
            timeKeyString = [NSString stringWithFormat:@"%lld+%d", time.value, time.timescale];
        } else {
            CMTime newTime = CMTimeConvertScale(time, 600, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
            timeKeyString = [NSString stringWithFormat:@"%lld+%d", newTime.value, newTime.timescale];
        }
    }
    return timeKeyString;
}

+ (CMTime)cmtimeFromKey:(NSString *)key {
    NSArray *array = [key componentsSeparatedByString:@"+"];
    int64_t time = [[array objectOrNilAtIndex:0] longLongValue];
    int32_t scale = [[array objectOrNilAtIndex:1] intValue];
    return CMTimeMake(time, scale);
}

- (UIImage *)trimViewImageForTime:(CMTime)time {
    if (FXIsEmpty(self.imageFrameDictionary)) {
        return nil;
    }
    NSString *key = [self timeKeyForCMTime:time];
    if ([self.imageFrameDictionary containsObjectForKey:key]) {
        return [self.imageFrameDictionary objectForKey:key];
    } else {
        int64_t value = time.value;
        int left = value % 150;
        value = MAX(value - left, 0);
        while (![self.imageFrameDictionary containsObjectForKey:[self timeKeyForCMTime:CMTimeMake(value, 600)]]) {
            NSLog(@"%lld", value);
            value -= 150;
        }
        value = MAX(value, 0);
        return [self.imageFrameDictionary objectForKey:[self timeKeyForCMTime:CMTimeMake(value, 600)]];
    }
    return nil;
}

@end
