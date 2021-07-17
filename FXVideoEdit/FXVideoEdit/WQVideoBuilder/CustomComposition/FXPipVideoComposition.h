//
//  FXPipVideoComposition.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "HFDraggableView.h"
#import <Foundation/Foundation.h>

@class FXPIPVideoDescribe;
@class FXPlayerViewController;

@interface FXPipVideoComposition : NSObject

@property (nonatomic, strong) NSArray<FXPIPVideoDescribe *> *videoPipDescribeArray;

@property (nonatomic, assign) CMTime playTime;

@property (strong, nonatomic, readonly) AVMutableComposition *composition;

- (instancetype)initWithVideo:(NSArray *)videoDesArray;

- (void)setHoldViewController:(FXPlayerViewController *)holdViewController;

- (void)videoPlayToTime:(CMTime)time;

- (void)seekVideoToTime:(CMTime)time;

- (void)playVideo;

- (void)stopPlay;

- (void)cleanPipVideoView;

@end
