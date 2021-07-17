//
//  FXTimelineManager+recordAudio.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager+recordAudio.h"

@implementation FXTimelineManager (recordAudio)

- (void)setRecordAudioVolume:(CGFloat)volume
{
    
}

- (void)prepareAudioRecorder
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSDate *currentDate = [NSDate date];
    NSString *audioName = [currentDate stringWithFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",audioName]];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSDictionary *settings = @{
    /**录音的质量，一般给LOW就可以了
     typedef NS_ENUM(NSInteger, AVAudioQuality) {
     AVAudioQualityMin    = 0,
     AVAudioQualityLow    = 0x20,
     AVAudioQualityMedium = 0x40,
     AVAudioQualityHigh   = 0x60,
     AVAudioQualityMax    = 0x7F
     };*/
    AVEncoderAudioQualityKey : [NSNumber numberWithInteger:AVAudioQualityMedium],
    AVEncoderBitRateKey : [NSNumber numberWithInteger:16],
    AVSampleRateKey : [NSNumber numberWithFloat:8000],
    AVNumberOfChannelsKey : [NSNumber numberWithInteger:1]
    };
    NSError *error;
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:settings error:&error];
//    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate = self;
    if (error) {
        NSLog(@"error:%@",error.localizedDescription);
    }
    AVAudioSession *recordSession = [AVAudioSession sharedInstance];
    [recordSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [recordSession setActive:YES error:nil];
}

- (void)startRecordAtTime:(CMTime)startTime {
    self.startTime = startTime;
    if ([self.audioRecorder prepareToRecord]) {
        [self.audioRecorder record];
    }
}

- (void)stopRecord:(NSInteger)index {
    self.audioIndex = index;
    [self.audioRecorder stop];
}

- (NSTimeInterval)currentRecordTime
{
    return self.audioRecorder.currentTime;
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    __weak typeof(self) weakSelf = self;
    FXAudioItem *audio = [[FXAudioItem alloc] initWithURL:recorder.url];
    [audio prepareWithCompletionBlock:^(BOOL complete) {
        [weakSelf.recordAudioArray addObject:audio];
        FXAudioDescribe *audioDescribe = [FXAudioDescribe new];
        audioDescribe.audioItem = audio;
        audioDescribe.audioIndex = weakSelf.audioIndex;
        audioDescribe.startTime = weakSelf.startTime;
        audioDescribe.duration = audio.timeRange.duration;
        audioDescribe.sourceRange = audio.timeRange;
        [weakSelf addAudio:audioDescribe atIndex:weakSelf.audioIndex];
    }];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error
{
    NSLog(@"%@",error.localizedDescription);
}


- (void)addAudio:(FXAudioDescribe *)audioDes atIndex:(NSInteger)index
{
    [self addSource:audioDes.audioItem type:FXDescribeTypeAudio];
    if (self.timelineDescribe.audioArray.count) {
        [self.timelineDescribe.audioArray insertObject:audioDes atIndex:index];
    }
    else{
        if (index == 0) {
            [self.timelineDescribe.audioArray insertObject:audioDes atIndex:0];
        } else {
            [self.timelineDescribe.audioArray addObject:audioDes];
        }
    }
}


@end
