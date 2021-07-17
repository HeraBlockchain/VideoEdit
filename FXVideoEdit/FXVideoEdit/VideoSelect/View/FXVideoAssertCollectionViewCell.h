//
//  FXVideoAssertCollectionViewCell.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoAssetDataModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoAssertCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, nullable) FXVideoAssetDataModel *dataModel;

@property (nonatomic, assign) BOOL needShowSelectedIndex;

@property (nonatomic, assign) NSUInteger selectedIndex;

+ (UIEdgeInsets)imageViewEdgeInsets;

@end

NS_ASSUME_NONNULL_END