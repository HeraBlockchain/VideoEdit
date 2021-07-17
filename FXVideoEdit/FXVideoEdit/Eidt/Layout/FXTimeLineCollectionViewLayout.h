//
//  FXTimeLineCollectionViewLayout.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/4.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FXTimeLineCollectionViewLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol FXTimeLineCollectionViewLayoutDelegate <NSObject>

- (CGFloat)timeLineCollectionViewLayout:(FXTimeLineCollectionViewLayout *)timeLineCollectionViewLayout leadingForItemAtSection:(NSInteger)section;

- (CGFloat)timeLineCollectionViewLayout:(FXTimeLineCollectionViewLayout *)timeLineCollectionViewLayout positionForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)timeLineCollectionViewLayout:(FXTimeLineCollectionViewLayout *)timeLineCollectionViewLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)timeLineCollectionViewLayout:(FXTimeLineCollectionViewLayout *)timeLineCollectionViewLayout spaceForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FXTimeLineCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<FXTimeLineCollectionViewLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
