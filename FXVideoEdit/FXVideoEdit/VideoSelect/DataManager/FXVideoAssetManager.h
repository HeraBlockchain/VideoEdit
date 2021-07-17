//
//  FXVideoAssetManager.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoAssetDataModel.h"
#import <Foundation/Foundation.h>
@class AVAsset;
NS_ASSUME_NONNULL_BEGIN

@interface FXVideoAssetManager : NSObject

/**
 加载指定相册资源对象回调block。

 @param assetDataModels 资源对象。
 */
typedef void (^FXLoadAssetDataModelsBlock)(NSArray<FXVideoAssetDataModel *> *_Nullable assetDataModels);

/**
 加载指定相册中的资源对象。

 @param block      加载完成后调用,主线程调用。
 */
+ (void)loadAllideoAssetWithBlock:(FXLoadAssetDataModelsBlock)block;

/**
 加载缩略图回调block。

 @param image 缩略图。
 */
typedef void (^FXLoadedThumbImageBlock)(UIImage *_Nullable image);
/**
 加载指定资源的缩略图对象。

 @param asset 指定的资源。
 @param size  需要的缩略图尺寸（物理尺寸）。
 @param block 加载完成后调用,主线程调用。
 */
+ (void)loadThumbImageWith:(FXVideoAssetDataModel *)asset size:(CGSize)size block:(FXLoadedThumbImageBlock)block;

/**
 加载视频数据回调block。

 @param asset AVAsset。
 */
typedef void (^FXLoadedVideoDataBlock)(AVAsset *_Nullable asset);

/**
 加载指定视频资源的数据。

 @param asset 视频资源。
 @param block 加载完成后调用,主线程调用。
 */
+ (void)loadVideoDataWith:(FXVideoAssetDataModel *)asset block:(FXLoadedVideoDataBlock)block;

/**
 取消加载指定资源的原始数据

 @param asset 资源。
 */
+ (void)cancelLoadOriginalDataWith:(FXVideoAssetDataModel *)asset;

@end

NS_ASSUME_NONNULL_END
