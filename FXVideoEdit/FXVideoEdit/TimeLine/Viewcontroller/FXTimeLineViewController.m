//
//  FXTimeLineViewController.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/27.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLineViewController.h"
#import "FXAudioDescribe.h"
#import "FXAudioItem.h"
#import "FXFunctionHelp.h"
#import "FXPIPVideoDescribe.h"
#import "FXSourceItem.h"
#import "FXTimeLIneCollectionViewLayout.h"
#import "FXTimeLIneDataSource.h"
#import "FXTimelineDescribe.h"
#import "FXTimelineItemViewModel.h"
#import "FXTimelineManager.h"
#import "FXTransitionDescribe.h"
#import "FXVideoCollectionView.h"
#import "FXVideoDescribe.h"
#import "FXVideoTransition.h"

@interface FXTimeLineViewController () <FXTimeLIneDataSourceDelegate>

@property (strong, nonatomic) FXTimeLIneDataSource *dataSource;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (nonatomic, assign) CGFloat lengthTimeScale;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

@property (nonatomic, assign) Float64 currentPercent;

@end

@implementation FXTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentSelectedIndex = 0;
    self.view.backgroundColor = UIColorMakeWithRGBA(24, 24, 24, 1.0);
    [self configCollectionView];
}

- (void)configCollectionView {
    _lengthTimeScale = [FXTimelineManager sharedInstance].timelineDescribe.lengthTimeScale;

    FXTimeLIneCollectionViewLayout *layout = [[FXTimeLIneCollectionViewLayout alloc] init];
    self.collectionView = [[FXVideoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    self.dataSource = [FXTimeLIneDataSource dataSourceWithCollectionView:self.collectionView];
    self.dataSource.delegate = self;
    [self.collectionView setDelegate:self.dataSource];
    [self.collectionView setDataSource:self.dataSource];

    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_lineView];
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(1);
    }];
}

- (void)buildTimelineItemModel {
    [self.dataSource resetTimeline];
    NSMutableArray *videoTrackArray = [self.dataSource.timelineItems objectOrNilAtIndex:1];
    NSInteger index = 0;

    FXTransitionDescribe *trans = [[FXTimelineManager sharedInstance].timelineDescribe.transitionArray objectOrNilAtIndex:0];
    FXTimelineItemViewModel *transmodelStart = [[FXTimelineItemViewModel alloc] initWithDescribe:trans];
    [videoTrackArray addObject:transmodelStart];

    for (FXVideoDescribe *describe in [FXTimelineManager sharedInstance].timelineDescribe.videoArray) {
        FXTimelineItemViewModel *model = [[FXTimelineItemViewModel alloc] initWithDescribe:describe];
        [videoTrackArray addObject:model];

        FXTransitionDescribe *trans = [[FXTimelineManager sharedInstance].timelineDescribe.transitionArray objectOrNilAtIndex:index + 1];
        FXTimelineItemViewModel *transmodel = [[FXTimelineItemViewModel alloc] initWithDescribe:trans];
        [videoTrackArray addObject:transmodel];
        index++;
    }
    NSMutableArray *pipVideoTrackArray = [self.dataSource.timelineItems objectOrNilAtIndex:0];
    for (FXPIPVideoDescribe *describe in [FXTimelineManager sharedInstance].timelineDescribe.pipVideoArray) {
        FXTimelineItemViewModel *model = [[FXTimelineItemViewModel alloc] initWithDescribe:describe];
        [pipVideoTrackArray addObject:model];
    }
    [self.collectionView reloadData];
}

#pragma - mark edit function

- (void)addSourceVideoAsset:(FXVideoItem *)videoItem {
    [[FXTimelineManager sharedInstance] addSourceAtIndex:_currentSelectedIndex videoAsset:videoItem];
    [self saveAndFresh];
}

- (void)addPipVideo:(FXVideoItem *)videoItem {
    Float64 totalTime = CMTimeGetSeconds([FXTimelineManager sharedInstance].timelineDescribe.duration);
    CMTime currentTime = CMTimeMakeWithSeconds(_currentPercent * totalTime, 600);
    [[FXTimelineManager sharedInstance] addPipVideoAtTime:currentTime video:videoItem];
    [self saveAndFresh];
}

- (void)divideVideo {
    if (![FXTimelineManager sharedInstance].timelineDescribe) {
        return;
    }
    Float64 totalTime = CMTimeGetSeconds([FXTimelineManager sharedInstance].timelineDescribe.duration);
    CMTime currentTime = CMTimeMakeWithSeconds(_currentPercent * totalTime, 600);
    [[FXTimelineManager sharedInstance] divideVideoAtTime:currentTime atIndex:_currentSelectedIndex];
    [self saveAndFresh];
    [self setSelectedVideoIndex:_currentSelectedIndex + 1];
}

- (void)rotateVideo {
    [[FXTimelineManager sharedInstance] rotateVideoAngle:_currentSelectedIndex];
    [self saveAndFresh];
}

- (void)changeVideoRate:(CGFloat)rate {
    [[FXTimelineManager sharedInstance] changeVideoScale:rate atIndex:_currentSelectedIndex];
    [self saveAndFresh];
}

- (void)removeVideo {
    [[FXTimelineManager sharedInstance] removeVideoItemAtIndex:_currentSelectedIndex];
    [self saveAndFresh];
}

- (void)moveVideoItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [[FXTimelineManager sharedInstance] moveVideoItemFromIndex:fromIndex toIndex:toIndex];
    [self onlyRefresh];
}

- (void)cancelMoveOperation {
    [[FXTimelineManager sharedInstance] resetOperation];
    [self buildTimelineItemModel];
}

- (void)confirmMoveOperation {
    [self saveAndFresh];
}

- (void)undoOperation {
    [[FXTimelineManager sharedInstance] undoOperation];
    [self buildTimelineItemModel];
}

- (void)redoOperation {
    [[FXTimelineManager sharedInstance] redoOperation];
    [self buildTimelineItemModel];
}

- (void)saveAndFresh {
    [self buildTimelineItemModel];
    [[FXTimelineManager sharedInstance] saveHistoryData];
}

- (void)onlyRefresh {
    [self buildTimelineItemModel];
}

- (void)setSelectedVideoIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index * 2 + 1 inSection:1];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)seekToTimePercent:(double)percent {
    CGFloat offset = (self.collectionView.contentSize.width - kScreenWidth) * percent;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
}

#pragma mark FXTimeLIneDataSourceDelegate

- (void)scrollViewDidScrollPercent:(Float64)percent {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollPercent:)]) {
        [_delegate scrollViewDidScrollPercent:percent];
        _currentPercent = percent;
    }
}

- (void)scrollVideoWillDrag {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollVideoWillDrag)]) {
        [_delegate scrollVideoWillDrag];
    }
}

- (void)timelineSelectedIndex:(NSInteger)index {
    if (_currentSelectedIndex != index) {
        [FXFunctionHelp playShake];
    }
    _currentSelectedIndex = index;
}

- (void)pipVideoMoveToPosition:(CGFloat)position timeline:(FXTimelineItemViewModel *)timelineItem {
    [timelineItem updateTimelineItem:position];
    [self saveAndFresh];
}

- (void)clickTransitionButtonAtIndex:(FXTransitionDescribe *)describe {
    if (_delegate && [_delegate respondsToSelector:@selector(clickTransitionButtonAtIndex:)]) {
        [_delegate clickTransitionButtonAtIndex:describe];
    }
}

#pragma mark

@end