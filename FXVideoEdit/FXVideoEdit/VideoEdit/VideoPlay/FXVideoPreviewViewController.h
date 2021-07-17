//
//  FXVideoPreviewViewController.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/17.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXPlaybackView.h"
#import "FXPreviewComposition.h"

@protocol FXVideoPreviewViewControllerDelegate <NSObject>

- (void)videoPlayToTime:(Float64)currentPercent;

@end


@interface FXVideoPreviewViewController : UIViewController

@property (nonatomic, weak) id<FXVideoPreviewViewControllerDelegate> delegate;

@property (nonatomic, strong) FXPlaybackView *playbackView;

@property (nonatomic, strong) FXPreviewComposition *previewComposition;

@property (assign, nonatomic) BOOL isPlaying;

- (void)changePreviewComposition:(FXPreviewComposition *)composition;

- (void)play;

- (void)stopPlayback;

- (void)seekVideoToPercent:(CGFloat)percent;

@end
