//
//  FXSelectedVideoListView.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoAssetDataModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXSelectedVideoListView : UIView

@property (nonatomic, copy, nullable) void (^deletedDataModelBlock)(FXVideoAssetDataModel *dataModel);

@property (nonatomic, copy, nullable) void (^reorderedDataModeslBlock)(NSArray<FXVideoAssetDataModel *> *dataModels);

@property (nonatomic, assign, readonly, class) CGFloat heightOfSelectedVideoListView;

- (void)addOneVideoAssetDataModel:(FXVideoAssetDataModel *)dataModel;

- (void)removeOneVideoAssetDataModel:(FXVideoAssetDataModel *)dataModel;

@end

NS_ASSUME_NONNULL_END