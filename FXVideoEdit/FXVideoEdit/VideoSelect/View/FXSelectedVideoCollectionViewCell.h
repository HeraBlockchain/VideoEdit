//
//  FXSelectedVideoCollectionViewCell.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoAssetDataModel.h"
#import <UIKit/UIKit.h>
@class FXSelectedVideoCollectionViewCell;
NS_ASSUME_NONNULL_BEGIN

@protocol FXSelectedVideoCollectionViewCellDelegate <NSObject>

- (void)clickDeleteButtonInSelectedVideoCollectionViewCell:(FXSelectedVideoCollectionViewCell *)cell;

@end

@interface FXSelectedVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) FXVideoAssetDataModel *dataModel;

@property (nonatomic, weak, nullable) id<FXSelectedVideoCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END