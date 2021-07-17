//
//  FXVideoPreviewViewController.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/17.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoPreviewViewController.h"

@interface FXVideoPreviewViewController ()

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) id timeObserver;


@end

@implementation FXVideoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        _playbackView = [FXPlaybackView.alloc initWithFrame:self.view.bounds];
        _playbackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_playbackView];
    }

    {
        __weak typeof(self) weakSelf = self;
        UITapGestureRecognizer *tapGestureRecognizer = [UITapGestureRecognizer.alloc initWithActionBlock:^(id _Nonnull sender) {
            [weakSelf play];
        }];
        [self.view addGestureRecognizer:tapGestureRecognizer];
    }
    // Do any additional setup after loading the view.
}

- (void)changePreviewComposition:(FXPreviewComposition *)composition
{
    _previewComposition = composition;
    AVPlayerItem *playerItem = [composition buildForCropPreview];
    [self p_playPlayerItem:playerItem];

}

- (void)play {
    if (self.isPlaying) {
        [self stopPlayback];
    } else {
        AVAudioSession *recordSession = [AVAudioSession sharedInstance];
        [recordSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [recordSession setActive:YES error:nil];
        [self.player play];
        self.isPlaying = YES;
        [self p_addPlayerTimeObserver];
    }
}

- (void)stopPlayback {
    self.player.rate = 0.0f;
    self.isPlaying = NO;
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
}

- (void)seekVideoToPercent:(CGFloat)percent {
    [self stopPlayback];
    CMTime duration = self.playerItem.duration;
    Float64 totalTime = CMTimeGetSeconds(duration);
    CMTime time = CMTimeMakeWithSeconds(totalTime * percent, 600);

    [self.playerItem seekToTime:time
                toleranceBefore:kCMTimeZero
                 toleranceAfter:kCMTimeZero
              completionHandler:^(BOOL finished){
              }];

    //    [self.player seekToTime:time toleranceBefore:CMTimeMake(1, 60) toleranceAfter:CMTimeMake(1, 60) completionHandler:^(BOOL finished) {
    //        [self filterImageWithTime:self.playerItem.currentTime];
    //
    //    }];

    ////    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    //
    //    [self.player ss_seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:nil];
}

#pragma mark -

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

}
#pragma mark -

#pragma mark 通知处理
- (void)handleNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]) {
        [self stopPlayback];
    }
}

#pragma mark 逻辑
- (void)p_playPlayerItem:(AVPlayerItem *)playerItem {
    self.playerItem = playerItem;
    self.playerItem.videoApertureMode = AVVideoApertureModeProductionAperture;
    self.playerItem.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmTimeDomain;
    if (playerItem) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf p_prepareToPlay];
        });
    } else {
        NSLog(@"Player item is nil.  Nothing to play.");
    }
}

- (void)p_prepareToPlay {
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.playbackView.playerLayer.player = self.player;
    } else {
        _playbackView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        //        [self.player play];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];

}

- (void)p_playTimerCheck:(CMTime)time {
    if (_isPlaying) {
        CMTime duration = self.playerItem.duration;
        Float64 totalTime = CMTimeGetSeconds(duration);
        Float64 currentTime = CMTimeGetSeconds(time);
        if (_delegate && [_delegate respondsToSelector:@selector(videoPlayToTime:)]) {
            [_delegate videoPlayToTime:currentTime / totalTime];
        }
    }
}

- (void)p_addPlayerTimeObserver {
    // Create 0.5 second refresh interval - REFRESH_INTERVAL == 0.5
    CMTime interval = CMTimeMake(1, 100);

    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:^(CMTime time) {
                                                                 [weakSelf p_playTimerCheck:time];
                                                             }];
}
@end
