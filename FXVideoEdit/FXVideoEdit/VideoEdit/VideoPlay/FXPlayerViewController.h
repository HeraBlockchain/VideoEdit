//
//  FXPlayerViewController.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXPlaybackView.h"
#import "HFDraggableView.h"
#import <UIKit/UIKit.h>

@class FXMainComposition;

@protocol FXPlayerViewControllerDelegate <NSObject>

- (void)videoPlayToTime:(Float64)currentPercent;

@end

@interface FXPlayerViewController : UIViewController

@property (nonatomic, weak) id<FXPlayerViewControllerDelegate> delegate;

@property (nonatomic, strong) FXPlaybackView *playbackView;

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) UIButton *pictureButton;

@property (nonatomic, strong) UIView *loadingView;

@property (assign, nonatomic) BOOL isPlaying;

@property (nonatomic, strong) FXPlaybackView *pipPlayView;

@property (nonatomic, strong) HFDraggableView *pipHoldView;

@property (nonatomic, strong, readonly) FXMainComposition *mainComposition;

- (void)changeMainComposition:(FXMainComposition *)mainComposition;

- (void)play;

- (void)stopPlayback;

- (void)seekVideoToPercent:(CGFloat)percent;

@end
