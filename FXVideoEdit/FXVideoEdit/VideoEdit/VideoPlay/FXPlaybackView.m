//
//  FXPlaybackView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXPlaybackView.h"

@implementation FXPlaybackView

#pragma mark 对外
- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)[self layer];
}
#pragma mark -

#pragma mark UIView
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return self;
}
#pragma mark -

@end