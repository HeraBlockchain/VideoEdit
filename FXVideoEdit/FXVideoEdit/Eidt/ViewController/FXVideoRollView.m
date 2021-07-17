//
//  FXVideoRollView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/16.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoRollView.h"
#import "FXTimelineItemViewModel.h"
#import "FXVideoDescribe.h"
#import "FXTimelineManager.h"
#import "FXTitleDescribe.h"


@interface FXVideoRollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *trimViewArray;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) FXTitleDescribe *titleDescribe;

@end


@implementation FXVideoRollView

- (instancetype)initWithTitle:(FXTitleDescribe *)titleDes
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.titleDescribe = titleDes;
        [self configVideoTrimView];
        [self configCoverView];
    }
    return self;
}

- (void)configCoverView
{
    Float64 totalTime = CMTimeGetSeconds([FXTimelineManager sharedInstance].timelineDescribe.duration);
    CGFloat timeWidth = (_scrollView.contentSize.width - kScreenWidth)/totalTime;
    Float64 start = CMTimeGetSeconds(_titleDescribe.startTime);
    Float64 duration = CMTimeGetSeconds(_titleDescribe.duration);

    _coverView = UIView.new;
    _coverView.backgroundColor = [UIColor colorWithRed:245.0/255 green:65.0/255 blue:132.0/255 alpha:0.5];
    [_scrollView addSubview:_coverView];
    _coverView.frame = CGRectMake(start * timeWidth + kScreenWidth/2, 20, duration*timeWidth, 60);
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
    [_coverView addSubview:_leftButton];
    [_coverView addSubview:_rightButton];
    [_leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_coverView.mas_centerY);
        make.centerX.mas_equalTo(_coverView.mas_left);
    }];
    [_rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_coverView.mas_centerY);
        make.centerX.mas_equalTo(_coverView.mas_right);
    }];
    __weak typeof(self) weakSelf = self;
    UIPanGestureRecognizer *panGestureRecognizer = [UIPanGestureRecognizer.alloc initWithActionBlock:^(UIPanGestureRecognizer *_Nonnull sender) {
        CGPoint point = [sender locationInView:weakSelf.scrollView];
        CGFloat start = point.x;
        CGFloat width = CGRectGetMaxX(weakSelf.coverView.frame) - point.x;
        CGRect updateRect = CGRectMake(start, CGRectGetMinY(weakSelf.coverView.frame), width, CGRectGetHeight(weakSelf.coverView.frame));
        weakSelf.coverView.frame = updateRect;
        [weakSelf layoutIfNeeded];
    }];
    [_leftButton addGestureRecognizer:panGestureRecognizer];
    
    UIPanGestureRecognizer *rightPanGestureRecognizer = [UIPanGestureRecognizer.alloc initWithActionBlock:^(UIPanGestureRecognizer *_Nonnull sender) {
        CGPoint point = [sender locationInView:weakSelf.scrollView];
        CGFloat width =  point.x - CGRectGetMinX(weakSelf.coverView.frame);
        CGRect updateRect = CGRectMake(CGRectGetMinX(weakSelf.coverView.frame), CGRectGetMinY(weakSelf.coverView.frame), width, CGRectGetHeight(weakSelf.coverView.frame));
        weakSelf.coverView.frame = updateRect;
        [weakSelf layoutIfNeeded];
    }];
    [_rightButton addGestureRecognizer:rightPanGestureRecognizer];
}


- (void)configVideoTrimView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 140);
    [self addSubview:_scrollView];
    [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(140);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    _trimViewArray = [NSMutableArray new];
    NSMutableArray *videoTrackArray = [NSMutableArray new];
    FXTimelineItemViewModel *preModel = nil;
    for (FXVideoDescribe *describe in [FXTimelineManager sharedInstance].timelineDescribe.videoArray) {
        FXTimelineItemViewModel *model = [[FXTimelineItemViewModel alloc] initWithDescribe:describe];
        model.trackType = FXTrackTypeVideo;
        if (preModel) {
            FXVideoDescribe *video = (FXVideoDescribe *)preModel.describe;
            CMTime transTimeDuration = [[FXTimelineManager sharedInstance] videoTransitionDuration:video pre:YES];
            Float64 time = CMTimeGetSeconds(transTimeDuration);
            CGFloat offset = time * LENGTH_TIME_SCALE_MIN;
            preModel.widthInTimeline = preModel.widthInTimeline - offset;
            
            CGFloat startPosition = preModel.widthInTimeline + preModel.positionInTimeline;
            startPosition += MAIN_VIDEO_SPACE;
            model.positionInTimeline = startPosition;
            
            CMTime transDuration = [[FXTimelineManager sharedInstance] videoTransitionDuration:describe pre:NO];
            time = CMTimeGetSeconds(transDuration);
            offset = time * LENGTH_TIME_SCALE_MIN;
            model.widthInTimeline = model.widthInTimeline - offset;
        }
        else{
            model.positionInTimeline = 0;
        }
        preModel = model;
        [videoTrackArray addObject:model];
    }
    CGFloat width = kScreenWidth;
    CGFloat startOffset = kScreenWidth/2;
    for (FXTimelineItemViewModel *model in videoTrackArray) {
        FXVideoDescribe *videoDescribe = (FXVideoDescribe *)model.describe;
        FXVideoItem *item = videoDescribe.videoItem;
        FXNVideoTrimView *trimView = [FXNVideoTrimView.alloc initWithFrame:CGRectMake(startOffset + model.positionInTimeline,20, model.widthInTimeline, 60)];
        [trimView setDelegate:item timeRange:videoDescribe.sourceRange];
        [_scrollView addSubview:trimView];
        width+=model.widthInTimeline;
    }
    _scrollView.contentSize = CGSizeMake(width, 140);
    
    UIView *lineView = UIView.new;
    lineView.backgroundColor = UIColor.whiteColor;
    [self addSubview:lineView];
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self).offset(-20);
    }];
}

@end
