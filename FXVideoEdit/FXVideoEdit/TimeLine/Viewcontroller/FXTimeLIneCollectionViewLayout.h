//
//  FXTimeLIneCollectionViewLayout.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICollectionViewDelegateTimelineLayout <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView willDeleteItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didMoveMediaItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView didAdjustToWidth:(CGFloat)width forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didAdjustToPosition:(CGPoint)point forItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView canAdjustToPosition:(CGPoint)point forItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGPoint)collectionView:(UICollectionView *)collectionView positionForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView scrollEnable:(BOOL)scrollEnable;

@end

@interface FXTimeLIneCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets trackInsets;

@property (nonatomic) CGFloat trackHeight;

@end