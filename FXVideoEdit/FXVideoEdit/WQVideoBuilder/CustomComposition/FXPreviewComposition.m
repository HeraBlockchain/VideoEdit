//
//  FXPreviewComposition.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/17.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXPreviewComposition.h"
#import "FXVideoDescribe.h"

@interface FXPreviewComposition ()

@property (nonatomic, strong) FXVideoDescribe *videoDescribe;

@end


@implementation FXPreviewComposition

- (instancetype)initWithVideo:(FXVideoDescribe *)videoDescribe{
    self = [super init];
    if (self) {
        self.videoDescribe = videoDescribe;
    }
    return self;
}

- (AVPlayerItem *)buildForCropPreview
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:_videoDescribe.videoItem.asset];
    return playerItem;
}


@end
