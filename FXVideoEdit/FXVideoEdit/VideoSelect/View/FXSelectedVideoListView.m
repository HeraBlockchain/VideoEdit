//
//  FXSelectedVideoListView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXSelectedVideoListView.h"
#import "FXSelectedVideoCollectionViewCell.h"

@interface FXSelectedVideoListView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FXSelectedVideoCollectionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray<FXVideoAssetDataModel *> *cellDatas;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, assign) BOOL reordering;

@end

@implementation FXSelectedVideoListView

#pragma mark 对外
- (void)addOneVideoAssetDataModel:(FXVideoAssetDataModel *)dataModel {
    NSUInteger index = [_cellDatas indexOfObject:dataModel];
    if (index == NSNotFound) {
        [_cellDatas addObject:dataModel];
        [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_cellDatas.count - 1 inSection:0]]];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_cellDatas.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

- (void)removeOneVideoAssetDataModel:(FXVideoAssetDataModel *)dataModel {
    [_cellDatas removeObject:dataModel];
    [_collectionView reloadData];
}

+ (CGFloat)heightOfSelectedVideoListView {
    return IS_IPAD ? 110 + 8 + 35 + 5 : 50 + 8 + 25 + 5;
}

#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            _reordering = NO;
            _cellDatas = NSMutableArray.new;
            self.backgroundColor = UIColor.blackColor;
        }

        __weak typeof(self) weakSelf = self;
        {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.minimumLineSpacing = IS_IPAD ? 10 : 8;
            CGFloat side = IS_IPAD ? 110 : 50;
            flowLayout.itemSize = CGSizeMake(side, side);
            flowLayout.sectionInset = UIEdgeInsetsZero;

            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            _collectionView.backgroundColor = UIColor.blackColor;
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            Class cellClass = FXSelectedVideoCollectionViewCell.class;
            [_collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
            [self addSubview:_collectionView];
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.collectionView.superview).offset(IS_IPAD ? 20 : 16);
                make.right.equalTo(weakSelf.collectionView.superview).offset(IS_IPAD ? -20 : -16);
                make.bottom.equalTo(weakSelf.collectionView.superview).offset(-5);
                make.height.mas_equalTo(IS_IPAD ? 110 : 50);
            }];
        }

        {
            UILabel *label = UILabel.new;
            label.text = @"拖动调整顺序";
            label.textColor = [UIColor colorWithRGBA:0x999DA4FF];
            label.font = [UIFont systemFontOfSize:IS_IPAD ? 20 : 10];
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.collectionView);
                make.bottom.equalTo(weakSelf.collectionView.mas_top).offset(-8);
            }];
        }

        {
            _longPressGestureRecognizer = [UILongPressGestureRecognizer.alloc initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
            [_collectionView addGestureRecognizer:_longPressGestureRecognizer];
        }
    }

    return self;
}
#pragma mark -

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FXSelectedVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(FXSelectedVideoCollectionViewCell.class) forIndexPath:indexPath];
    cell.dataModel = _cellDatas[indexPath.row];
    cell.delegate = self;
    return cell;
}
#pragma mark -

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    [_cellDatas exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    [collectionView reloadData];
    if (_reorderedDataModeslBlock) {
        _reorderedDataModeslBlock(_cellDatas.copy);
    }
}
#pragma mark -

#pragma mark <FXSelectedVideoCollectionViewCellDelegate>
- (void)clickDeleteButtonInSelectedVideoCollectionViewCell:(FXSelectedVideoCollectionViewCell *)cell {
    FXVideoAssetDataModel *data = cell.dataModel;
    [self removeOneVideoAssetDataModel:data];
    if (_deletedDataModelBlock) {
        _deletedDataModelBlock(data);
    }
}
#pragma mark -

#pragma mark 手势处理
- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (_longPressGestureRecognizer == longPressGestureRecognizer) {
        switch (longPressGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan: {
                {
                    NSIndexPath *selectIndexPath = [_collectionView indexPathForItemAtPoint:[longPressGestureRecognizer locationInView:_collectionView]];
                    if (selectIndexPath) {
                        _reordering = YES;
                        [_collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                    }
                }
                break;
            }
            case UIGestureRecognizerStateChanged:
                if (_reordering) {
                    [_collectionView updateInteractiveMovementTargetPosition:[longPressGestureRecognizer locationInView:_longPressGestureRecognizer.view]];
                }
                break;
            case UIGestureRecognizerStateEnded:
                if (_reordering) {
                    [_collectionView endInteractiveMovement];
                }
                _reordering = NO;
                break;
            default:
                [_collectionView cancelInteractiveMovement];
                break;
        }
    }
}
#pragma mark -

@end