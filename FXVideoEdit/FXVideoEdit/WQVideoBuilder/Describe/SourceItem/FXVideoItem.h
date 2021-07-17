//
//  FXVideoItem.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXMediaItem.h"
#import "FXVideoTransition.h"
#import "FXVideoTrimView.h"
#import "FXNVideoTrimView.h"

@interface FXVideoItem : FXMediaItem<FXVideoTrimViewDelegate, FXNVideoTrimViewDelegate>

@property (strong, nonatomic) NSArray *thumbnails;

+ (id)videoItemWithURL:(NSURL *)url;

@property (nonatomic, strong) AVAssetTrack *videoTrack;

@property (nonatomic, strong) AVAssetTrack *audioTrack;

- (UIImage *)trimViewImageForTime:(CMTime)time;

@end
