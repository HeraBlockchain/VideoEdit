//
//  FXTitleVideoComposition.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/15.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTitleVideoComposition.h"
#import "HFDraggableView.h"
#import "FXPlayerViewController.h"
#import "FXTitleInputView.h"
#import "FXTimelineItemViewModel.h"

@interface FXTitleVideoComposition () <HFDraggableViewDelegate>

@property (nonatomic, strong) FXPlayerViewController *holdViewController;

@property (nonatomic, assign) CGRect holdFrame;

@property (nonatomic, strong) NSMutableDictionary *draggableViewDictionary;

@end


@implementation FXTitleVideoComposition

- (instancetype)initWithTitle:(NSArray *)titleDesArray
{
    self = [super init];
    if (self) {
        _titleDescribeArray = titleDesArray;
        _draggableViewDictionary = [NSMutableDictionary new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleViewSelectNotification:) name:KNotificationTitleCoverViewSelected object:nil];
    }
    return self;
}

- (void)setHoldViewController:(FXPlayerViewController *)holdViewController
{
    _holdViewController = holdViewController;
    [self preparedTitleView];
}

- (void)videoPlayToTime:(CMTime)time
{
    [self titleViewlayout:time];
}

- (void)seekVideoToTime:(CMTime)time
{
    [self titleViewlayout:time];
}

- (void)titleViewlayout:(CMTime)time
{
    for (FXTitleDescribe *titleDescribe in self.titleDescribeArray) {
        CMTimeRange range = CMTimeRangeMake(titleDescribe.startTime, titleDescribe.duration);
        HFDraggableView *draggableView = [self.draggableViewDictionary objectForKey:@(titleDescribe.titleIndex)];
        if (CMTimeRangeContainsTime(range, time)) {
            if (draggableView.hidden) {
                draggableView.hidden = NO;
            }
        }
        else{
            draggableView.hidden = YES;
            [draggableView setActive:NO];
        }
    }
}

- (void)preparedTitleView
{
    CGRect rect = _holdViewController.playbackView.frame;
    for (FXTitleDescribe *titleDescribe in self.titleDescribeArray) {
        CGFloat width = rect.size.width * titleDescribe.widthPercent;
        CGFloat height = width/titleDescribe.widthHeightPercent;
        CGFloat originalX = rect.size.width * titleDescribe.centerXP - width/2;
        CGFloat originalY = rect.size.height * titleDescribe.centerYP - height/2;
        CGRect dragRect = CGRectMake(originalX, originalY, width, height);
        
        HFDraggableView *draggableView = [[HFDraggableView alloc] initWithFrame:dragRect];
        draggableView.angle = titleDescribe.rotateAngle;
        draggableView.delegate = self;
        draggableView.superRect = rect;
        draggableView.tag = titleDescribe.titleIndex;
        draggableView.hidden = YES;
        draggableView.freeSize = YES;
        draggableView.textlabel.text = titleDescribe.text;

        [self.draggableViewDictionary setObject:draggableView forKey:@(titleDescribe.titleIndex)];
        [self.holdViewController.playbackView addSubview:draggableView];
    }
}

- (void)draggableViewChangeFinish:(HFDraggableView *)draggableView {
    CGRect bounds = draggableView.bounds;
    CGPoint center = draggableView.center;
    CGRect holdRect = _holdViewController.playbackView.frame;
    for (FXTitleDescribe *titleDescribe in self.titleDescribeArray) {
        if (titleDescribe.titleIndex == draggableView.tag) {
            titleDescribe.centerXP = center.x / holdRect.size.width;
            titleDescribe.centerYP = center.y / holdRect.size.height;
            titleDescribe.widthPercent = bounds.size.width/holdRect.size.height;
            titleDescribe.widthHeightPercent = bounds.size.width/bounds.size.height;
            titleDescribe.rotateAngle = draggableView.angle;
        }
    }
}

- (void)draggableViewTapAgain:(HFDraggableView *)draggableView;
{
    for (FXTitleDescribe *titleDescribe in self.titleDescribeArray) {
        if (titleDescribe.titleIndex == draggableView.tag) {
            FXTitleInputView *titleInputView = [[FXTitleInputView alloc] initWithDraggableView:draggableView titleDescribe:titleDescribe];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTitleLabelEdit object:nil userInfo:@{@"EditTitle":titleInputView}];
            return;
        }
    }
}

- (void)titleViewSelectNotification:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    FXTimeLineTitleModel *titleModel = dic[@"titleModel"];
    FXTitleDescribe *titleDescribe = titleModel.titleDescribe;
    HFDraggableView *draggableView = [self.draggableViewDictionary objectForKey:@(titleDescribe.titleIndex)];
    [HFDraggableView setActiveView:draggableView];
}


@end
