//
//  FXVideoTrimView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/16.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoTrimView.h"

@interface FXVideoTrimView () <UIScrollViewDelegate>

@property (nonatomic, assign) CMTime startTime;

@property (nonatomic, assign) CMTime durationTime;

@end

@implementation FXVideoTrimView

- (instancetype)initWithFrame:(CGRect)frame timeRange:(CMTimeRange)timeRange;
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    if (self) {
        _durationTime = timeRange.duration;
        _startTime = timeRange.start;
        [self addGesture];
    }
    return self;
}

- (void)reloadAllSubViews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self loadTrimImage];
}

- (void)loadTrimImage {
    Float64 durationSeconds = CMTimeGetSeconds(_durationTime);
    CGFloat width = CGRectGetWidth(self.frame);
    Float64 timePerWidth = durationSeconds / width;
    int num = (int)(width / TRIM_IMAGE_WIDTH) + 1;
    CMTime start = _startTime;
    for (int i = 0; i < num; i++) {
        if (_delegate && [_delegate respondsToSelector:@selector(trimViewImageForTime:)]) {
            UIImage *showImage = [_delegate trimViewImageForTime:start];
            UIImageView *imageVIew = [self getImageViewWithIndex:i];
            imageVIew.image = showImage;
            [self addSubview:imageVIew];
        }
        start = CMTimeAdd(start, CMTimeMake(timePerWidth * 60 * 600, 600));
    }
}

- (UIImageView *)getImageViewWithIndex:(NSInteger)index {
    CGFloat originalX = 60 * index;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat viewWidth = TRIM_IMAGE_WIDTH;
    if (originalX + 60 > width) {
        viewWidth = width - originalX;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60 * index, 0, viewWidth, 60)];
    return imageView;
    ;
}

- (void)clickTransButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(videoAddButtonClick:)]) {
        [_delegate videoAddButtonClick:self];
    }
}

- (void)addGesture {
    //    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    //    [self addGestureRecognizer:tapGes];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectdNotification:) name:@"kNotificationSelected" object:nil];
}

- (void)tapView:(UIGestureRecognizer *)ges {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationSelected" object:nil];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = UIColor.redColor.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)selectdNotification:(NSNotification *)noti {
    self.layer.borderWidth = 0;
    self.layer.borderColor = UIColor.redColor.CGColor;
    self.layer.masksToBounds = NO;
}

@end