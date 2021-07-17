//
//  FXTransitionViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterTransitionSubTypeViewController.h"
#import "FXCustomSubTypeTitleView.h"
#import "FXVideoModeifyParameterTransitionCollectionViewCell.h"

@interface FXVideoModeifyParameterTransitionSubTypeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray<NSNumber *> *cellDatas;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FXVideoModeifyParameterTransitionSubTypeViewController

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    {
        FXCustomSubTypeTitleView *topView = FXCustomSubTypeTitleView.new;
        topView.title = @"转场";
        topView.closeButtonActionBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

        topView.doneButtonActionBlock = ^{
            NSIndexPath *indexPath = weakSelf.collectionView.indexPathsForSelectedItems.firstObject;
            if (indexPath) {
                FXTransType type = [weakSelf.cellDatas[indexPath.row] unsignedIntegerValue];
                weakSelf.transitionSelectedBlock(type);
            }
        };
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(topView.superview);
            make.height.mas_equalTo(FXCustomSubTypeTitleView.heightOfCustomSubTypeTitleView);
        }];
    }

    {
        _cellDatas = @[@(FXTransTypeNone), @(FXTransTypeAccordionFoldTransition), @(FXTransTypeBarsSwipeTransition), @(FXTransTypeCopyMachineTransition), @(FXTransTypeDisintegrateWithMaskTransition), @(FXTransTypeDissolveTransition), @(FXTransTypeFlashTransition), @(FXTransTypeModTransition), @(FXTransTypePageCurlTransition), @(FXTransTypePageCurlWithShadowTransition), @(FXTransTypeRippleTransition), @(FXTransTypeSwipeTransition)];
    }

    {
        _collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:UICollectionViewFlowLayout.new];
        Class cellClass = FXVideoModeifyParameterTransitionCollectionViewCell.class;
        [_collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_collectionView.superview);
            make.top.equalTo(_collectionView.superview).offset(FXCustomSubTypeTitleView.heightOfCustomSubTypeTitleView);
        }];
    }
}
#pragma mark -

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellDatas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FXVideoModeifyParameterTransitionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(FXVideoModeifyParameterTransitionCollectionViewCell.class) forIndexPath:indexPath];
    cell.type = [_cellDatas[indexPath.row] unsignedIntegerValue];
    return cell;
}
#pragma mark -

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = collectionView.bounds.size;
    UIEdgeInsets insetForSection = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    size.width -= (insetForSection.left + insetForSection.right);
    size.height -= (insetForSection.top + insetForSection.bottom);
    NSUInteger LinesCount = 3;
    NSUInteger aLine = 6;
    size.width -= (aLine - 1) * ([self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section]);
    size.height -= (LinesCount - 1) * ([self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:indexPath.section]);

    CGFloat side = MIN(size.width / aLine - 1, size.height / LinesCount);
    return CGSizeMake(side, side);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return IS_IPAD ? UIEdgeInsetsMake(11, 20, 10, 20) : UIEdgeInsetsMake(63, 16, 40, 16);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return IS_IPAD ? 20 : 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return IS_IPAD ? 11 : 11;
}
#pragma mark -

@end