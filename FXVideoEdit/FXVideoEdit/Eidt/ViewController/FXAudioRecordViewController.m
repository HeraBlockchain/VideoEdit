//
//  FXAudioRecordViewController.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/14.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioRecordViewController.h"
#import "FXCustomSubTypeTitleView.h"
#import "FXTimelineManager.h"
#import "FXTimelineItemViewModel.h"
#import "FXNVideoTrimView.h"
#import "FXFunctionHelp.h"
#import "FXVideoRollView.h"


typedef NS_ENUM(NSUInteger, FXRecordState) {
    FXRecordStatePrepare,
    FXRecordStateRecording,
    FXRecordStateRecordEnd,
};


@interface FXAudioRecordViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) QMUIButton *recordButton;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *trimViewArray;

@property (nonatomic, strong) CADisplayLink *displaylink;

@property (nonatomic, assign) FXRecordState recordState;

@property (nonatomic, assign) CGFloat startOffset;

@property (nonatomic, strong) NSMutableArray *recordCoverViewArray;

@property (nonatomic, assign) NSInteger recordIndex;

@property (nonatomic, strong) FXVideoRollView *rollView;

@end

@implementation FXAudioRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    FXCustomSubTypeTitleView *topView = FXCustomSubTypeTitleView.new;
    topView.title = @"录音";
    topView.closeButtonActionBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };

    topView.doneButtonActionBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRebuildTimelineView object:nil];
    };
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(topView.superview);
        make.height.mas_equalTo(FXCustomSubTypeTitleView.heightOfCustomSubTypeTitleView);
    }];
    
    [self configRecordButton];
    [self configVideoTrimView];
    UIView *lineView = UIView.new;
    lineView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:lineView];
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(20);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.recordButton.mas_top).offset(-20);
    }];
    
    [[FXTimelineManager sharedInstance] prepareAudioRecorder];
    _recordState = FXRecordStatePrepare;
    _recordCoverViewArray = [NSMutableArray new];
}


- (void)configRecordButton
{
    _recordButton = [QMUIButton buttonWithType:UIButtonTypeSystem];
    [_recordButton setTitle:@"录制" forState:UIControlStateNormal];
    [_recordButton setImagePosition:QMUIButtonImagePositionTop];
    [_recordButton setImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
    [self.view addSubview:_recordButton];
    [_recordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottomMargin).offset(-8);
        make.width.mas_equalTo(100);
    }];
    [_recordButton addTarget:self action:@selector(clickRecordButton) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setButtonRecordingState:(NSString *)title
                      state:(FXRecordState)state
{
    if (state == FXRecordStatePrepare) {
        [_recordButton setTitle:title forState:UIControlStateNormal];
        [_recordButton setImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
    }
    else if (state == FXRecordStateRecordEnd){
        [_recordButton setTitle:title forState:UIControlStateNormal];
        [_recordButton setImage:[UIImage imageNamed:@"重录"] forState:UIControlStateNormal];
    }
    else if (state == FXRecordStateRecording){
        [_recordButton setTitle:title forState:UIControlStateNormal];
        [_recordButton setImage:[UIImage imageNamed:@"录音中"] forState:UIControlStateNormal];
    }
}

- (void)configVideoTrimView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 140);
    [self.view addSubview:_scrollView];
    [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(140);
        make.centerY.mas_equalTo(self.view.mas_centerY);
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
}


#pragma mark

- (void)clickRecordButton
{
    if (_recordState == FXRecordStatePrepare) {
        CGFloat offsetX = self.scrollView.contentOffset.x;
        _startOffset = offsetX;
        CGFloat timePercent = offsetX/(_scrollView.contentSize.width - kScreenWidth);
        Float64 totalTime = CMTimeGetSeconds([FXTimelineManager sharedInstance].timelineDescribe.duration);
        [[FXTimelineManager sharedInstance] startRecordAtTime:CMTimeMake(totalTime * timePercent, 600)];
        _scrollView.scrollEnabled = NO;
        _recordState = FXRecordStateRecording;
        [self startDisplayLink];
        [self setButtonRecordingState:@"" state:_recordState];
    }
    else if (_recordState == FXRecordStateRecording)
    {
        _scrollView.scrollEnabled = YES;
        [self stopDisplayLink];
        _recordState = FXRecordStateRecordEnd;
        [[FXTimelineManager sharedInstance] stopRecord:_recordIndex];
        _recordIndex++;
        [self setButtonRecordingState:@"重录" state:_recordState];
    }
    else if (_recordState == FXRecordStateRecordEnd)
    {
        //重录
        [self setButtonRecordingState:@"录音" state:_recordState];
    }
}

- (void)startDisplayLink
{
    if (!_displaylink) {
        _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink)];
        [_displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)handleDisplayLink
{
    Float64 totalTime = CMTimeGetSeconds([FXTimelineManager sharedInstance].timelineDescribe.duration);
    CGFloat timeWidth = (_scrollView.contentSize.width - kScreenWidth)/totalTime;
    NSTimeInterval time = [[FXTimelineManager sharedInstance] currentRecordTime];
    [self setButtonRecordingState:[FXFunctionHelp timeFormatted:time] state:_recordState];
    CGFloat offsetX = time*timeWidth + _startOffset;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    BOOL found = NO;
    for (UIView *coverView in self.recordCoverViewArray) {
        if (coverView.tag == _recordIndex) {
            coverView.frame = CGRectMake(_startOffset + kScreenWidth/2, 20, time*timeWidth, 60);
            found = YES;
            break;;
        }
    }
    if (!found) {
        UIView *recordCoverView = UIView.new;
        recordCoverView.tag = _recordIndex;
        recordCoverView.backgroundColor = [UIColor colorWithRed:245.0/255 green:65.0/255 blue:132.0/255 alpha:0.5];
        [_scrollView addSubview:recordCoverView];
        [self.recordCoverViewArray addObject:recordCoverView];
        recordCoverView.frame = CGRectMake(_startOffset + kScreenWidth/2, 20, time*timeWidth, 60);
    }
}

- (void)stopDisplayLink
{
    [_displaylink invalidate];
    _displaylink = nil;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _recordState = FXRecordStatePrepare;
    [self setButtonRecordingState:@"录音" state:_recordState];
}

@end
