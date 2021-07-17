//
//  FXTimeLineColloectionViewConfiguration.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/7.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLineColloectionViewConfiguration.h"
#import "FXNPIPVideoItemCollectionViewCell.h"
#import "FXNVideoItemCollectionViewCell.h"
#import "FXTimelineItemViewModel.h"

@interface FXTimeLineColloectionViewConfiguration () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@end

@implementation FXTimeLineColloectionViewConfiguration

#pragma mark 对外
- (instancetype)initWithColloectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        {
            _collectionView = collectionView;
            _collectionView.dataSource = self;
            _collectionView.delegate = self;
            Class cellClass = FXNVideoItemCollectionViewCell.class;
            [_collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
            cellClass = FXNPIPVideoItemCollectionViewCell.class;
            [_collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
            cellClass = FXTimeLineCollectionViewCell.class;
            [_collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];

            _collectionView.dataSource = self;
            _collectionView.delegate = self;
        }

        {
            _cellDatas = NSMutableArray.new;
        }
    }

    return self;
}

- (void)resetTimeline {
    [_cellDatas setArray:@[@[].mutableCopy, @[].mutableCopy, @[].mutableCopy, @[].mutableCopy]];
    [_collectionView reloadData];
}

- (void)clearTimeline {
    [_cellDatas removeAllObjects];
    [_collectionView reloadData];
}
#pragma mark -

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _cellDatas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellDatas[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FXTimelineItemViewModel *model = self.cellDatas[indexPath.section][indexPath.row];
    Class cellClass = FXTimeLineCollectionViewCell.class;
    if (indexPath.section == 0) {
        cellClass = FXNPIPVideoItemCollectionViewCell.class;
    } else if (indexPath.section == 1) {
        cellClass = FXNVideoItemCollectionViewCell.class;
    } else if (indexPath.section == 2 || indexPath.section == 3) {
        cellClass = FXTimeLineCollectionViewCell.class;
    }

    FXTimeLineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    {
        CGFloat leftOffset = 0;
        if (indexPath.item != 0) {
            leftOffset = IS_IPAD ? -2.5 : -1.5;
        }
        CGFloat rithtOffset = 0;
        if (indexPath.item != [collectionView numberOfItemsInSection:indexPath.section] - 1) {
            rithtOffset = IS_IPAD ? 2.5 : 1.5;
        }
        [cell setLeftButtonOffset:leftOffset rightButtonOffset:rithtOffset];
    }

    if ([cell isKindOfClass:FXNVideoItemCollectionViewCell.class]) {
        [(FXNVideoItemCollectionViewCell *)cell setItemModel:model];
    } else if ([cell isKindOfClass:FXNPIPVideoItemCollectionViewCell.class]) {
        [(FXNPIPVideoItemCollectionViewCell *)cell setCellData:model];
    }

    return cell;
}
#pragma mark -

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击cell");
}
#pragma mark -

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        [_delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        [_delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        [_delegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        [_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        [_delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}
#pragma mark -

@end