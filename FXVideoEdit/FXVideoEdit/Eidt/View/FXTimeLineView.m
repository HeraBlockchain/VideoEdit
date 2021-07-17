//
//  FXTimeLineView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLineView.h"
#import "FXAudioDescribe.h"
#import "FXFunctionHelp.h"
#import "FXNVideoItemCollectionViewCell.h"
#import "FXTimeLIneDataSource.h"
#import "FXTimeLineCollectionViewCell.h"
#import "FXTimeLineCollectionViewLayout.h"
#import "FXTimeLineColloectionViewConfiguration.h"
#import "FXTimelineItemViewModel.h"
#import "FXTimelineManager.h"
#import "FXVideoCollectionView.h"

@interface FXTimeLineView () <FXTimeLineCollectionViewLayoutDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *trackArray;

@property (nonatomic, assign) CGFloat lengthTimeScale;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

@property (nonatomic, assign) Float64 currentPercent;

@property (nonatomic, strong) FXTimeLineColloectionViewConfiguration *colloectionViewConfiguration;

@property (nonatomic, assign) BOOL dragging;

@end

@implementation FXTimeLineView

#pragma mark 对外
- (void)seekToTimePercent:(double)percent {
    UICollectionView *collectionView = _colloectionViewConfiguration.collectionView;
    CGFloat offset = (collectionView.contentSize.width) * percent;
    offset -= collectionView.contentInset.left;
    [_colloectionViewConfiguration.collectionView setContentOffset:CGPointMake(offset, 0)];
}

- (void)addPlentySourceVideoAsset:(NSArray<FXVideoItem *> *)videoItemArray {
    [[FXTimelineManager sharedInstance] addSourceVideos:videoItemArray];
    [self p_saveAndFresh];
    [self p_resetSeletedIndexPaths];
}

- (void)addSourceVideoAsset:(FXVideoItem *)videoItem {
    [self addSourceVideoAsset:videoItem index:self.currentSelectedIndex];
}

- (void)addSourceVideoAsset:(FXVideoItem *)videoItem index:(NSUInteger)index {
    [[FXTimelineManager sharedInstance] addSourceAtIndex:index videoAsset:videoItem];
    [self p_saveAndFresh];
    [self p_resetSeletedIndexPaths];
}

- (void)addPipVideo:(FXVideoItem *)videoItem {
    Float64 totalTime = CMTimeGetSeconds([FXTimelineManager sharedInstance].timelineDescribe.duration);
    CMTime currentTime = CMTimeMakeWithSeconds(_currentPercent * totalTime, 600);
    [[FXTimelineManager sharedInstance] addPipVideoAtTime:currentTime video:videoItem];
    [self p_saveAndFresh];
    [self p_resetSeletedIndexPaths];
}

- (void)undoOperation {
    [[FXTimelineManager sharedInstance] undoOperation];
    [self p_buildTimelineItemModel];
}

- (void)redoOperation {
    [[FXTimelineManager sharedInstance] redoOperation];
    [self p_buildTimelineItemModel];
}

- (void)divideVideo {
    if (![FXTimelineManager sharedInstance].timelineDescribe) {
        return;
    }
    Float64 totalTime = CMTimeGetSeconds([FXTimelineManager sharedInstance].timelineDescribe.duration);
    CMTime currentTime = CMTimeMakeWithSeconds(_currentPercent * totalTime, 600);
    [[FXTimelineManager sharedInstance] divideVideoAtTime:currentTime atIndex:self.currentSelectedIndex];
    [self p_saveAndFresh];
    [self p_setSelectedVideoIndex:self.currentSelectedIndex + 1];
}

- (void)rotateVideo {
    [[FXTimelineManager sharedInstance] rotateVideoAngle:self.currentSelectedIndex];
    [self p_saveAndFresh];
}

- (void)changeVideoRate:(CGFloat)rate {
    [[FXTimelineManager sharedInstance] changeVideoScale:rate atIndex:self.currentSelectedIndex];
    [self p_saveAndFresh];
}

- (void)removeVideo {
    [[FXTimelineManager sharedInstance] removeVideoItemAtIndex:self.currentSelectedIndex];
    [self p_saveAndFresh];
}

- (void)moveVideoItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [[FXTimelineManager sharedInstance] moveVideoItemFromIndex:fromIndex toIndex:toIndex];
    [self p_onlyRefresh];
}

- (void)cancelMoveOperation {
    [[FXTimelineManager sharedInstance] resetOperation];
    [self p_buildTimelineItemModel];
}

- (void)rebuildTimelineView
{
    [self p_saveAndFresh];
}

- (void)confirmMoveOperation {
    [self p_saveAndFresh];
}

- (NSInteger)currentSelectedIndex {
    NSArray *array = [self selectedIndexPaths];
    for (NSIndexPath *index in array) {
        if (index.section == 1) {
            return index.row;
        }
    }
    return 0;
}

- (NSArray<NSIndexPath *> *)selectedIndexPaths {
    return _colloectionViewConfiguration.collectionView.indexPathsForSelectedItems;
}

#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            _lengthTimeScale = [FXTimelineManager sharedInstance].timelineDescribe.lengthTimeScale;
        }
        {
            FXTimeLineCollectionViewLayout *collectionViewLayout = FXTimeLineCollectionViewLayout.new;
            collectionViewLayout.delegate = self;
            UICollectionView *collectionView = [UICollectionView.alloc initWithFrame:self.bounds collectionViewLayout:collectionViewLayout];
            collectionView.allowsMultipleSelection = YES;
            collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _colloectionViewConfiguration = [FXTimeLineColloectionViewConfiguration.alloc initWithColloectionView:collectionView];
            _colloectionViewConfiguration.delegate = self;
            [self addSubview:collectionView];
        }

        {
            [_colloectionViewConfiguration.collectionView addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(handleTapGestureRecognizer:)]];
        }

        {
            __weak typeof(self) weakSelf = self;
            _lineView = UIView.new;
            _lineView.backgroundColor = UIColor.whiteColor;
            [self addSubview:_lineView];
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(weakSelf.lineView.superview);
                make.top.bottom.mas_equalTo(weakSelf.lineView.superview);
                make.width.mas_equalTo(1);
            }];
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat side = self.bounds.size.width / 2;
    if (_colloectionViewConfiguration.collectionView.contentInset.left != side || _colloectionViewConfiguration.collectionView.contentInset.right != side) {
        UIEdgeInsets contentInset = _colloectionViewConfiguration.collectionView.contentInset;
        contentInset.left = side;
        contentInset.right = side;
        _colloectionViewConfiguration.collectionView.contentInset = contentInset;
    }
}
#pragma mark -

#pragma mark 逻辑
- (void)p_saveAndFresh {
    [self p_buildTimelineItemModel];
    [[FXTimelineManager sharedInstance] saveHistoryData];
}

- (void)p_buildTimelineItemModel {
    [_colloectionViewConfiguration resetTimeline];
    NSMutableArray *videoTrackArray = [self.colloectionViewConfiguration.cellDatas objectOrNilAtIndex:1];
    FXTimelineItemViewModel *preModel = nil;
    for (FXVideoDescribe *describe in [FXTimelineManager sharedInstance].timelineDescribe.videoArray) {
        FXTimelineItemViewModel *model = [[FXTimelineItemViewModel alloc] initWithDescribe:describe];
        model.titleDescribeArray = [[FXTimelineManager sharedInstance] titleArrayWithVideoDescribe:describe];
        model.trackType = FXTrackTypeVideo;
        if (preModel) {
            FXVideoDescribe *video = (FXVideoDescribe *)preModel.describe;
            CMTime transTimeDuration = [[FXTimelineManager sharedInstance] videoTransitionDuration:video pre:YES];
            Float64 time = CMTimeGetSeconds(transTimeDuration);
            CGFloat offset = time * LENGTH_TIME_SCALE_MIN + MAIN_VIDEO_SPACE/2;
            preModel.widthInTimeline = preModel.widthInTimeline - offset;
            
            CGFloat startPosition = preModel.widthInTimeline + preModel.positionInTimeline;
            startPosition += MAIN_VIDEO_SPACE;
            model.positionInTimeline = startPosition;
            
            CMTime transDuration = [[FXTimelineManager sharedInstance] videoTransitionDuration:describe pre:NO];
            time = CMTimeGetSeconds(transDuration);
            offset = time * LENGTH_TIME_SCALE_MIN + MAIN_VIDEO_SPACE/2;
            model.widthInTimeline = model.widthInTimeline - offset;
        }
        else{
            model.positionInTimeline = 0;
        }
        preModel = model;
        [videoTrackArray addObject:model];
    }
    NSMutableArray *pipVideoTrackArray = [self.colloectionViewConfiguration.cellDatas objectOrNilAtIndex:0];
    for (FXPIPVideoDescribe *describe in [FXTimelineManager sharedInstance].timelineDescribe.pipVideoArray) {
        FXTimelineItemViewModel *model = [[FXTimelineItemViewModel alloc] initWithDescribe:describe];
        model.trackType = FXTrackTypePip;
        [pipVideoTrackArray addObject:model];
    }
    [_colloectionViewConfiguration.collectionView reloadData];
}

- (void)p_setSelectedVideoIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index * 2 + 1 inSection:1];
    [_colloectionViewConfiguration.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)p_onlyRefresh {
    [self p_buildTimelineItemModel];
}

- (NSIndexPath *)p_indexPathForSelectedWithTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint pointInCollectionView = [tapGestureRecognizer locationInView:_colloectionViewConfiguration.collectionView];
    return [_colloectionViewConfiguration.collectionView indexPathForItemAtPoint:pointInCollectionView];
}

- (NSArray<NSIndexPath *> *)p_indexPathsWithTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer left:(BOOL)left right:(BOOL)right {
    CGPoint pointInTimeLineView = [tapGestureRecognizer locationInView:self];
    __weak typeof(self) weakSelf = self;
    NSMutableArray<NSIndexPath *> *indexPaths = NSMutableArray.new;
    [_colloectionViewConfiguration.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:FXTimeLineCollectionViewCell.class]) {
            FXTimeLineCollectionViewCell *timeLineCollectionViewCell = (FXTimeLineCollectionViewCell *)obj;
            if ((left && CGRectContainsPoint([timeLineCollectionViewCell leftAddButtonFrameInView:weakSelf], pointInTimeLineView)) || (right && CGRectContainsPoint([timeLineCollectionViewCell rightAddButtonFrameInView:weakSelf], pointInTimeLineView))) {
                NSIndexPath *indexPath = [weakSelf.colloectionViewConfiguration.collectionView indexPathForCell:obj];
                if (indexPath) {
                    [indexPaths addObject:indexPath];
                }
            }
        }
    }];

    [indexPaths sortUsingComparator:^NSComparisonResult(NSIndexPath *_Nonnull obj1, NSIndexPath *_Nonnull obj2) {
        return [@(obj1.row) compare:@(obj2.row)];
    }];

    return indexPaths;
}

- (void)p_calculationCurrentPercentWithScrollView {
    UICollectionView *collectionView = _colloectionViewConfiguration.collectionView;
    CGFloat offset = collectionView.contentOffset.x;
    offset += collectionView.contentInset.left;
    _currentPercent = MAX(MIN(1, offset / collectionView.contentSize.width), 0.0);
}

- (nullable NSIndexPath *)p_selectedIndexPathAtSection:(NSInteger)section {
    __block NSIndexPath *indexPath = nil;
    [_colloectionViewConfiguration.collectionView.indexPathsForSelectedItems enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.section == section) {
            indexPath = obj;
            *stop = YES;
        }
    }];

    return indexPath;
}

- (NSArray<NSIndexPath *> *)p_cellIndexPathsAtMidline {
    NSMutableArray<NSIndexPath *> *indexPaths = NSMutableArray.new;
    UICollectionView *collectionView = _colloectionViewConfiguration.collectionView;
    for (CGFloat y = collectionView.bounds.size.height / 8; y < collectionView.bounds.size.height; y += collectionView.bounds.size.height / 4) {
        CGPoint point = CGPointMake(collectionView.contentOffset.x + collectionView.contentInset.left, y);
        NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:point];
        if (indexPath) {
            NSLog(@"point=%@ indexPath=%@-%@", NSStringFromCGPoint(point), @(indexPath.section), @(indexPath.row));
            [indexPaths addObject:indexPath];
        }
    }
    return indexPaths.copy;
}

- (void)p_resetSeletedIndexPaths {
    __weak typeof(self) weakSelf = self;
    [[self p_cellIndexPathsAtMidline] enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [weakSelf p_selectedIndex:obj];
    }];
}

- (void)p_selectedIndex:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndexPath = [self p_selectedIndexPathAtSection:indexPath.section];
    if (oldIndexPath && oldIndexPath == indexPath) {
        return;
    }

    if (oldIndexPath) {
        [_colloectionViewConfiguration.collectionView deselectItemAtIndexPath:oldIndexPath animated:YES];
    }

    [_colloectionViewConfiguration.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [_colloectionViewConfiguration.collectionView.delegate collectionView:_colloectionViewConfiguration.collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark -

#pragma mark <FXTimeLineCollectionViewLayoutDelegate>
- (CGFloat)timeLineCollectionViewLayout:(FXTimeLineCollectionViewLayout *)timeLineCollectionViewLayout positionForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    FXTimelineItemViewModel *model = self.colloectionViewConfiguration.cellDatas[indexPath.section][indexPath.row];
    return model.positionInTimeline;
}


- (CGFloat)timeLineCollectionViewLayout:(FXTimeLineCollectionViewLayout *)timeLineCollectionViewLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    FXTimelineItemViewModel *model = self.colloectionViewConfiguration.cellDatas[indexPath.section][indexPath.row];
    return model.widthInTimeline;
}

- (CGFloat)timeLineCollectionViewLayout:(FXTimeLineCollectionViewLayout *)timeLineCollectionViewLayout spaceForItemAtIndexPath:(NSIndexPath *)indexPath {
    FXTimelineItemViewModel *model = self.colloectionViewConfiguration.cellDatas[indexPath.section][indexPath.row];
    if (model.trackType == FXTrackTypeVideo) {
        return MAIN_VIDEO_SPACE;
    }
    return 0;
}
#pragma mark -

#pragma mark 手势处理
- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.view == _colloectionViewConfiguration.collectionView) {
        {
            NSArray<NSIndexPath *> *indexPaths = [self p_indexPathsWithTapGestureRecognizer:tapGestureRecognizer left:YES right:YES];
            if (indexPaths.count == 2) {
                [_delegate timeLineView:self clickConnectionButtonAtIndexPaths:indexPaths];
            } else if (indexPaths.count == 1) {
                if ([self p_indexPathsWithTapGestureRecognizer:tapGestureRecognizer left:YES right:NO].firstObject) {
                    [_delegate timeLineView:self clickBeginButtonAtIndexPath:indexPaths.firstObject];
                } else if ([self p_indexPathsWithTapGestureRecognizer:tapGestureRecognizer left:NO right:YES].firstObject) {
                    [_delegate timeLineView:self clickEndButtonAtIndexPath:indexPaths.firstObject];
                }
            } else {
                NSIndexPath *indexPath = [self p_indexPathForSelectedWithTapGestureRecognizer:tapGestureRecognizer];
                if (indexPath) {
                    [self p_selectedIndex:indexPath];
                }
            }
        }
    }
}
#pragma mark -

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_dragging) {
        [self p_calculationCurrentPercentWithScrollView];
        if (_delegate && [_delegate respondsToSelector:@selector(timeLineView:scrollViewDragScrollPercent:)]) {
            [_delegate timeLineView:self scrollViewDragScrollPercent:_currentPercent];
        }
    }

    [self p_resetSeletedIndexPaths];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragging = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollVideoWillDragInTimeLineView:)]) {
        [_delegate scrollVideoWillDragInTimeLineView:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        _dragging = YES;
    } else {
        _dragging = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _dragging = NO;
}
#pragma mark -

@end
