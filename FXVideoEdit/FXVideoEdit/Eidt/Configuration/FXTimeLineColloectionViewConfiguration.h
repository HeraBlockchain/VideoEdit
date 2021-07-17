//
//  FXTimeLineColloectionViewConfiguration.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/7.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXTimeLineColloectionViewConfiguration : NSObject

@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> delegate;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (instancetype)initWithColloectionView:(UICollectionView *)collectionView NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, strong, readonly) NSMutableArray<NSMutableArray *> *cellDatas;

- (void)resetTimeline;

- (void)clearTimeline;

@end

NS_ASSUME_NONNULL_END