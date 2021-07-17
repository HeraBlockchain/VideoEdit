//
//  FXPipVideoComposition.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXPipVideoComposition.h"
#import "FXPIPVideoDescribe.h"
#import "FXPlaybackView.h"
#import "FXPlayerViewController.h"
#import "HFDraggableView.h"
#import "FXTimelineManager.h"

@interface FXPipVideoComposition () <HFDraggableViewDelegate>

@property (nonatomic, strong) FXPlayerViewController *holdViewController;

@property (nonatomic, assign) CGRect holdFrame;

@property (nonatomic, strong) FXPlaybackView *playbackView;

@property (nonatomic, strong) HFDraggableView *draggableView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (strong, nonatomic) AVMutableComposition *composition;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayer *player;

@property (nonatomic, strong) FXPIPVideoDescribe *currentPlayVideo;

@property (nonatomic, assign) CGSize originalSize;

@property (nonatomic, assign) BOOL canPlayVideo;

@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation FXPipVideoComposition

- (instancetype)initWithVideo:(NSArray<FXPIPVideoDescribe *> *)videoDesArray {
    self = [super init];
    if (self) {
        _videoPipDescribeArray = videoDesArray;
        _currentIndex = 0;
        _canPlayVideo = NO;
        [self preparedVideoPipPlayback];
    }
    return self;
}

- (void)cleanPipVideoView
{
    [_draggableView removeFromSuperview];
    _draggableView = nil;
    _currentPlayVideo = nil;
}

- (void)setHoldViewController:(FXPlayerViewController *)holdViewController {
    _holdViewController = holdViewController;
}

- (void)seekVideoToTime:(CMTime)time {
    [self stopPlay];
    [self.playerItem seekToTime:time
                toleranceBefore:kCMTimeZero
                 toleranceAfter:kCMTimeZero
              completionHandler:^(BOOL finished){
              }];
}

- (void)videoPlayToTime:(CMTime)time {
    NSInteger i = 1;
    for (FXPIPVideoDescribe *video in self.videoPipDescribeArray) {
        CMTimeRange range = CMTimeRangeMake(video.startTime, video.duration);
        if (CMTimeRangeContainsTime(range, time)) {
            _currentPlayVideo = video;
            CGRect rect = _holdViewController.playbackView.frame;
            CGFloat width = rect.size.width * video.widthPercent;
            CGFloat height = rect.size.height * video.widthPercent;
            CGSize pipSize = _composition.naturalSize;
            if (pipSize.width > pipSize.height) {
                CGFloat per = pipSize.height / pipSize.width;
                height = width * per;
            } else {
                CGFloat per = pipSize.width / pipSize.height;
                width = height * per;
            }

            CGFloat originalX = rect.size.width * video.centerXP - width/2;
            CGFloat originalY = rect.size.height * video.centerYP - height/2;
            CGRect dragRect = CGRectMake(originalX, originalY, width*video.scaleSize, height*video.scaleSize);

            if (_draggableView) {
                _draggableView.bounds = CGRectMake(0, 0, dragRect.size.width, dragRect.size.height);
                _draggableView.angle = _currentPlayVideo.rotateAngle;
                [HFDraggableView setActiveView:nil];
                if (_isPlaying) {
                    return;
                }
                [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                return;
            } else {
                [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                [HFDraggableView setActiveView:nil];
                _playbackView = [[FXPlaybackView alloc] init];
                self.playbackView.playerLayer.player = self.player;
                _draggableView = [[HFDraggableView alloc] initWithFrame:dragRect];
                _draggableView.angle = _currentPlayVideo.rotateAngle;
                _draggableView.delegate = self;
                _draggableView.superRect = rect;
                _originalSize = dragRect.size;
                [self.holdViewController.playbackView addSubview:_draggableView];
                [_draggableView addSubview:_playbackView];
                [_playbackView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsZero);
                }];
                _canPlayVideo = YES;
                [self playVideo];
                _currentIndex = i;
            }
            return;
        }
        i++;
    }
    [_draggableView removeFromSuperview];
    _draggableView = nil;
    _currentPlayVideo = nil;
}

- (void)preparedVideoPipPlayback {
    if (!self.videoPipDescribeArray.count) {
        return;
    }
    _composition = [AVMutableComposition new];
    for (FXPIPVideoDescribe *video in self.videoPipDescribeArray) {
        NSError *error;
        if ([_composition insertTimeRange:video.sourceRange ofAsset:video.videoItem.asset atTime:video.startTime error:&error]) {
            NSLog(@"add success");
        }
    }
    self.playerItem = [AVPlayerItem playerItemWithAsset:_composition];
    if (@available(iOS 11.0, *)) {
//        self.playerItem.videoApertureMode = AVVideoApertureModeProductionAperture;
    } else {
        // Fallback on earlier versions
    }
    self.playerItem.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmTimeDomain;
    if (self.playerItem) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self prepareToPlay];
        });
    } else {
        NSLog(@"Player item is nil.  Nothing to play.");
    }
}

- (void)prepareToPlay {
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.player.volume = [FXTimelineManager sharedInstance].timelineDescribe.pipVideoVolume/100;
    } else {
        self.player.volume = [FXTimelineManager sharedInstance].timelineDescribe.pipVideoVolume/100;
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
}

- (void)playVideo {
    if (!_canPlayVideo) {
        return;
    }
    if (_isPlaying) {
        return;
    }
    [self.player play];
    _isPlaying = YES;
}

- (void)stopPlay {
    _isPlaying = NO;
    [self.player pause];
}

#pragma - mark HFDraggableViewDelegate

- (void)draggableViewChangeFinish:(HFDraggableView *)draggableView {
    CGRect bounds = self.draggableView.bounds;
    CGPoint center = self.draggableView.center;
    CGRect holdRect = _holdViewController.playbackView.frame;
    _currentPlayVideo.centerXP = center.x / holdRect.size.width;
    _currentPlayVideo.centerYP = center.y / holdRect.size.height;
    _currentPlayVideo.scaleSize = bounds.size.width/_originalSize.width;
    _currentPlayVideo.rotateAngle = self.draggableView.angle;
}

@end
