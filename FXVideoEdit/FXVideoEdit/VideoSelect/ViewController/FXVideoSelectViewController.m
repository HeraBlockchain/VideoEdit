//
//  FXVideoSelectViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoSelectViewController.h"
#import "FXSelectedVideoListView.h"
#import "FXVideoAssertCollectionViewCell.h"
#import "FXVideoAssetDataModel.h"
#import "FXVideoAssetManager.h"

@interface FXVideoSelectViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<FXVideoAssetDataModel *> *cellDatas;

@property (nonatomic, strong) NSMutableArray<FXVideoAssetDataModel *> *selectedDatas;

@property (nonatomic, strong) FXSelectedVideoListView *selectedVideoListView;

@property (nonatomic, strong) UIButton *nextButtton;

@property (nonatomic, assign) BOOL loadingOriginalDataLoadStatus;

@property (nonatomic, copy) void (^nextBlock)(NSArray<AVAsset *> *);

@property (nonatomic, assign) BOOL clickedNextButton;

@property (nonatomic, assign) NSUInteger allowMaxSelectedNumber;

@end

@implementation FXVideoSelectViewController

#pragma mark 对外
+ (FXVideoSelectViewController *)videoSelectViewControllerWithAllowMaxSelectedNumber:(NSUInteger)allowMaxSelectedNumber nextBlock:(void (^)(NSArray<AVAsset *> *avassets))nextBlock {
    FXVideoSelectViewController *controller = FXVideoSelectViewController.new;
    controller.nextBlock = nextBlock;
    controller.allowMaxSelectedNumber = allowMaxSelectedNumber;
    return controller;
}
#pragma mark -

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    {
        self.view.backgroundColor = UIColor.blackColor;
    }

    __weak typeof(self) weakSelf = self;

    {
        _selectedDatas = [NSMutableArray new];
        _cellDatas = NSMutableArray.new;
        [FXVideoAssetManager loadAllideoAssetWithBlock:^(NSArray<FXVideoAssetDataModel *> *_Nullable assetDataModels) {
            if (assetDataModels) {
                weakSelf.cellDatas = assetDataModels.copy;
                if (weakSelf.viewLoaded) {
                    [weakSelf.collectionView reloadData];
                }
            }
        }];
    }

    {
        _nextButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButtton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _nextButtton.backgroundColor = [UIColor colorWithRGBA:0xF54184FF];
        _nextButtton.layer.cornerRadius = 8;
        _nextButtton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 34 : 16];
        _nextButtton.layer.masksToBounds = YES;
        [_nextButtton setTitle:@"下一步" forState:UIControlStateNormal];
        [self.view addSubview:_nextButtton];
        [_nextButtton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.nextButtton.superview.mas_bottomMargin).offset(-5);
            make.centerX.equalTo(weakSelf.nextButtton.superview);
            make.width.equalTo(weakSelf.nextButtton.superview).offset(IS_IPAD ? -40 : -32);
            make.height.mas_equalTo(IS_IPAD ? 79 : 32);
        }];
    }

    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        CGSize mainScreenSize = UIScreen.mainScreen.bounds.size;
        CGFloat side = MIN(mainScreenSize.width, mainScreenSize.height);
        side = IS_IPAD ? side / 4 : side / 3;
        flowLayout.itemSize = CGSizeMake(side, side);
        UIEdgeInsets sectionInset = IS_IPAD ? UIEdgeInsetsMake(7, 8, 7, 8) : UIEdgeInsetsMake(3, 10, 3, 10);
        sectionInset.bottom += _allowMaxSelectedNumber != 1 ? FXSelectedVideoListView.heightOfSelectedVideoListView : 0;
        flowLayout.sectionInset = sectionInset;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.blackColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        Class cellClass = FXVideoAssertCollectionViewCell.class;
        [_collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.collectionView.superview);
            make.top.equalTo(weakSelf.collectionView.superview.mas_topMargin);
            make.bottom.equalTo(weakSelf.nextButtton.mas_top).offset(-5);
        }];
    }

    {
        _selectedVideoListView = FXSelectedVideoListView.new;
        _selectedVideoListView.hidden = _allowMaxSelectedNumber == 1;
        _selectedVideoListView.deletedDataModelBlock = ^(FXVideoAssetDataModel *_Nonnull dataModel) {
            if ([weakSelf.selectedDatas containsObject:dataModel]) {
                [weakSelf.selectedDatas removeObject:dataModel];
                [dataModel removeObserverBlocksForKeyPath:@"originalDataLoadStatus"];
                [dataModel cancelLoadOriginalData];
                [weakSelf p_updateLoadOriginalDataLoadStatus];
                [weakSelf.collectionView reloadItemsAtIndexPaths:weakSelf.collectionView.indexPathsForVisibleItems];
            }
        };

        _selectedVideoListView.reorderedDataModeslBlock = ^(NSArray<FXVideoAssetDataModel *> *_Nonnull dataModels) {
            [weakSelf.selectedDatas setArray:dataModels];
            [weakSelf.collectionView reloadItemsAtIndexPaths:weakSelf.collectionView.indexPathsForVisibleItems];
        };

        [self.view addSubview:_selectedVideoListView];
        [_selectedVideoListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.selectedVideoListView.superview);
            make.bottom.equalTo(weakSelf.nextButtton.mas_top).offset(-5);
            make.height.mas_equalTo(FXSelectedVideoListView.heightOfSelectedVideoListView);
        }];
    }

    {
        [self addObserverBlockForKeyPath:@"loadingOriginalDataLoadStatus"
                                   block:^(id _Nonnull obj, id _Nullable oldVal, id _Nullable newVal) {
                                       if (weakSelf.clickedNextButton) {
                                           [weakSelf p_callNextBlock];
                                       }
                                   }];
    }
}
#pragma mark -

#pragma mark NSObject
- (void)dealloc {
    for (FXVideoAssetDataModel *dataModel in _selectedDatas) {
        [dataModel removeObserverBlocksForKeyPath:@"originalDataLoadStatus"];
    }

    [self removeObserverBlocksForKeyPath:@"loadingOriginalDataLoadStatus"];
}
#pragma mark -

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FXVideoAssetDataModel *dataModel = _cellDatas[indexPath.row];
    CGSize imageSize = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout itemSize];
    UIEdgeInsets imageViewEdgeInsets = FXVideoAssertCollectionViewCell.imageViewEdgeInsets;
    imageSize.width -= (imageViewEdgeInsets.left + imageViewEdgeInsets.right);
    imageSize.height -= (imageViewEdgeInsets.top + imageViewEdgeInsets.bottom);
    [dataModel loadThumbnailImageWithSize:imageSize];
    FXVideoAssertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(FXVideoAssertCollectionViewCell.class) forIndexPath:indexPath];
    cell.needShowSelectedIndex = _allowMaxSelectedNumber != 1;
    cell.dataModel = dataModel;
    cell.selectedIndex = [_selectedDatas indexOfObject:dataModel];
    return cell;
}
#pragma mark -

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_allowMaxSelectedNumber > 0) {
        if (_allowMaxSelectedNumber > 1) {
            BOOL shouldSelectItem = _selectedDatas.count < _allowMaxSelectedNumber;
            if (!shouldSelectItem) {
                [self showErrorDesc:[NSString stringWithFormat:@"最多选择%@个", @(_allowMaxSelectedNumber)]];
                return shouldSelectItem;
            } else {
                return shouldSelectItem;
            }
        } else {
            return YES;
        }

    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    FXVideoAssetDataModel *dataModel = _cellDatas[indexPath.row];
    if ([_selectedDatas containsObject:dataModel]) {
        [_selectedDatas removeObject:dataModel];
        [dataModel removeObserverBlocksForKeyPath:@"originalDataLoadStatus"];
        [_selectedVideoListView removeOneVideoAssetDataModel:dataModel];
        [dataModel cancelLoadOriginalData];
        [self p_updateLoadOriginalDataLoadStatus];
    } else {
        if (_allowMaxSelectedNumber == 1) {
            FXVideoAssetDataModel *oldData = _selectedDatas.firstObject;
            if (oldData) {
                [_selectedDatas removeObject:oldData];
                [oldData removeObserverBlocksForKeyPath:@"originalDataLoadStatus"];
                [_selectedVideoListView removeOneVideoAssetDataModel:oldData];
                [oldData cancelLoadOriginalData];
            }
        }

        [_selectedDatas addObject:dataModel];
        [_selectedVideoListView addOneVideoAssetDataModel:dataModel];
        __weak typeof(self) weakSelf = self;
        [dataModel addObserverBlockForKeyPath:@"originalDataLoadStatus"
                                        block:^(id _Nonnull obj, id _Nullable oldVal, id _Nullable newVal) {
                                            [weakSelf p_updateLoadOriginalDataLoadStatus];
                                        }];
        [dataModel loadOriginalData];
        [self p_updateLoadOriginalDataLoadStatus];
    }

    [collectionView reloadItemsAtIndexPaths:collectionView.indexPathsForVisibleItems];
}
#pragma mark -

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat side = collectionView.bounds.size.width;
    UICollectionViewFlowLayout *collectionViewFlowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    side -= (collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right);
    side /= IS_IPAD ? 4 : 3;
    return CGSizeMake(side, side);
}
#pragma mark -

#pragma mark 逻辑
- (void)p_updateLoadOriginalDataLoadStatus {
    NSUInteger index = NSNotFound;
    index = [_selectedDatas indexOfObjectPassingTest:^BOOL(FXVideoAssetDataModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        *stop = obj.originalDataLoadStatus == FXPhotoLoadStatusLoadingStatus;
        return *stop;
    }];

    self.loadingOriginalDataLoadStatus = index != NSNotFound;
    NSLog(@"是否有正在加载中的:%@", self.loadingOriginalDataLoadStatus ? @"YES" : @"NO");
}

- (void)p_callNextBlock {
    NSMutableArray<AVAsset *> *result = NSMutableArray.new;
    [_selectedDatas enumerateObjectsUsingBlock:^(FXVideoAssetDataModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.avasset) {
            [result addObject:obj.avasset];
        }
    }];
    _nextBlock(result);
}

#pragma mark -

#pragma mark UI回调
- (void)clickButton:(UIButton *)sender {
    if (!self.loadingOriginalDataLoadStatus) {
        [self p_callNextBlock];
    } else {
        _clickedNextButton = YES;
        self.view.userInteractionEnabled = NO;
    }
}
#pragma mark -

@end
