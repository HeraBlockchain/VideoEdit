//
//  FXPlayerViewController.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXPlayerViewController.h"
#import "AVPlayer+SeekSmoothly.h"
#import "AVPlayerItem+FXAdd.h"
#import "FXMainComposition.h"
#import "FXPipVideoComposition.h"
#import "FXTimelineManager.h"
#import "FXTitleVideoComposition.h"

#define STATUS_KEYPATH @"status"

static const NSString *PlayerItemStatusContext;

@interface FXPlayerViewController ()

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) id timeObserver;

@property (nonatomic, strong) FXPipVideoComposition *pipVideoComposition;

@property (nonatomic, strong) FXTitleVideoComposition *titleVideoComposition;

@property (nonatomic, assign) CGSize naturalSize;

@end

@implementation FXPlayerViewController

#pragma mark 对外

- (void)changeMainComposition:(FXMainComposition *)mainComposition {
    [_pipVideoComposition cleanPipVideoView];
    _mainComposition = mainComposition;
    _pipVideoComposition = mainComposition.pipVideoComposition;
    _titleVideoComposition = mainComposition.titleVideoComposition;
    AVPlayerItem *playerItem = [_mainComposition makePlayable];
    _naturalSize = [FXTimelineManager sharedInstance].timelineDescribe.defaultNaturalSize;
    [self calculatePlayerView];
    [self p_playPlayerItem:playerItem];
    [_pipVideoComposition setHoldViewController:self];
    [_titleVideoComposition setHoldViewController:self];
}

- (void)calculatePlayerView
{
    CGFloat whPer = _naturalSize.width/_naturalSize.height;
    CGSize holdSize = self.view.bounds.size;
    CGFloat holdwhPer = holdSize.width/holdSize.height;
    if (whPer < holdwhPer) {
        //高顶住
        CGFloat width = holdSize.height * whPer;
        [_playbackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.view);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(width);
        }];
    }
    else{
        CGFloat heigh = holdSize.width / whPer;
        [_playbackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view);
            make.height.mas_equalTo(heigh);
        }];
    }
}

- (void)play {
    if (self.isPlaying) {
        [self stopPlayback];
    } else {
        AVAudioSession *recordSession = [AVAudioSession sharedInstance];
        [recordSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [recordSession setActive:YES error:nil];
        self.player.volume = [FXTimelineManager sharedInstance].timelineDescribe.mainVideoVolume/100;
        [self.player play];
        self.isPlaying = YES;
        [self p_addPlayerTimeObserver];
        [self.pipVideoComposition playVideo];
    }
}

- (void)stopPlayback {
    self.player.rate = 0.0f;
    self.isPlaying = NO;
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    [self.pipVideoComposition stopPlay];
}

- (void)seekVideoToPercent:(CGFloat)percent {
    [self stopPlayback];
    CMTime duration = self.playerItem.duration;
    Float64 totalTime = CMTimeGetSeconds(duration);
    CMTime time = CMTimeMakeWithSeconds(totalTime * percent, 600);
    [self.pipVideoComposition seekVideoToTime:time];
    [self.titleVideoComposition seekVideoToTime:time];

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

#pragma mark UIViewController
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
}
#pragma mark -

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &PlayerItemStatusContext) {
    }
}
#pragma mark -

#pragma mark 通知处理
- (void)handleNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]) {
        [self stopPlayback];
    }
}
#pragma mark -

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
    [self.playerItem addObserver:self forKeyPath:STATUS_KEYPATH options:0 context:&PlayerItemStatusContext];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];

    if (self.playerItem.syncLayer) {
        [self addSynchronizedLayer:self.playerItem.syncLayer];
        self.playerItem.syncLayer = nil;
    }
}

- (void)p_playTimerCheck:(CMTime)time {
    if (_isPlaying) {
        CMTime duration = self.playerItem.duration;
        Float64 totalTime = CMTimeGetSeconds(duration);
        Float64 currentTime = CMTimeGetSeconds(time);
        if (_delegate && [_delegate respondsToSelector:@selector(videoPlayToTime:)]) {
            [_delegate videoPlayToTime:currentTime / totalTime];
        }
        [_pipVideoComposition videoPlayToTime:time];
        [_pipVideoComposition videoPlayToTime:time];
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
#pragma mark -

#pragma mark Attach AVSynchronizedLayer to layer tree

- (void)addSynchronizedLayer:(AVSynchronizedLayer *)synchLayer {
    // Remove old if it still exists
    //    [self.titleView removeFromSuperview];
    //
    //    synchLayer.bounds = FX720pVideoRect;
    //    self.titleView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [self.titleView.layer addSublayer:synchLayer];
    //
    //    CGFloat scale = fminf(self.view.boundsWidth / TH720pVideoSize.width, self.view.boundsHeight /TH720pVideoSize.height);
    //    CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(TH720pVideoSize, self.view.bounds);
    //    self.titleView.center = CGPointMake( CGRectGetMidX(videoRect), CGRectGetMidY(videoRect));
    //    self.titleView.transform = CGAffineTransformMakeScale(scale, scale);
    //
    //
    //    [self.view addSubview:self.titleView];
}

#pragma mark -

#pragma mark pip
- (void)addPipView {
    _pipHoldView = [HFDraggableView new];
    _pipPlayView = [FXPlaybackView new];
}
#pragma mark -
@end
