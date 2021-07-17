//
//  FXVideoAssetDataModel.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PHImageManager.h>
@class PHAsset;

/**
 相册内容加载状态
 */
typedef NS_ENUM(u_int8_t, FXPhotoLoadStatus) {
    /**
     没有加载过。
     */
    FXPhotoLoadStatusNoLoadStatus = 0,
    /**
     加载中。
     */
    FXPhotoLoadStatusLoadingStatus,
    /**
     已经加载完全。
     */
    FXPhotoLoadStatusLoadedStatus,
    /**
     加载失败。
     */
    FXPhotoLoadStatusLoadErrorStatus
};

NS_ASSUME_NONNULL_BEGIN

@interface FXVideoAssetDataModel : NSObject

@property (nonatomic, strong, readonly) PHAsset *asset;

/**
 资源请求ID。
 */
@property (nonatomic, assign) PHImageRequestID requestID;

/**
 缩略图。
 */
@property (nonatomic, strong, readonly, nullable) UIImage *thumbnailImage;

/**
 缩略图加载状态。
 */
@property (nonatomic, assign, readonly) FXPhotoLoadStatus thumbnailImageLoadStatus;

@property (nonatomic, strong, nullable) AVAsset *avasset;

/**
资源原始数据加载状态。
*/
@property (nonatomic, assign, readonly) FXPhotoLoadStatus originalDataLoadStatus;

- (instancetype)initWithAsset:(PHAsset *)asset NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

- (void)loadThumbnailImageWithSize:(CGSize)szie;

- (void)loadOriginalData;

- (void)cancelLoadOriginalData;

@end

NS_ASSUME_NONNULL_END
