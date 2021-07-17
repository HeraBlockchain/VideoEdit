//
//  FXVideoAssetDataModel.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoAssetDataModel.h"
#import "FXVideoAssetManager.h"

@interface FXVideoAssetDataModel ()

@property (nonatomic, strong, nullable) UIImage *thumbnailImage;

@property (nonatomic, assign) FXPhotoLoadStatus thumbnailImageLoadStatus;

@property (nonatomic, assign) FXPhotoLoadStatus originalDataLoadStatus;

@end

@implementation FXVideoAssetDataModel

#pragma mark 对外

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super init];
    if (self) {
        _asset = asset;
        _thumbnailImageLoadStatus = FXPhotoLoadStatusNoLoadStatus;
        _requestID = PHInvalidImageRequestID;
        _originalDataLoadStatus = FXPhotoLoadStatusNoLoadStatus;
    }

    return self;
}

- (void)loadThumbnailImageWithSize:(CGSize)size {
    if (_thumbnailImageLoadStatus == FXPhotoLoadStatusNoLoadStatus || _thumbnailImageLoadStatus == FXPhotoLoadStatusLoadErrorStatus) {
        _thumbnailImageLoadStatus = FXPhotoLoadStatusLoadingStatus;
        __weak typeof(self) weakSelf = self;
        [FXVideoAssetManager loadThumbImageWith:self
                                           size:size
                                          block:^(UIImage *_Nullable image) {
                                              weakSelf.thumbnailImage = image ? [UIImage imageWithCGImage:image.CGImage scale:UIScreen.mainScreen.scale orientation:image.imageOrientation] : nil;
                                              weakSelf.thumbnailImageLoadStatus = weakSelf.thumbnailImage ? FXPhotoLoadStatusLoadedStatus : FXPhotoLoadStatusLoadErrorStatus;
                                          }];
    }
}

- (void)loadOriginalData {
    if (self.originalDataLoadStatus == FXPhotoLoadStatusNoLoadStatus || self.originalDataLoadStatus == FXPhotoLoadStatusLoadErrorStatus) {
        self.originalDataLoadStatus = FXPhotoLoadStatusLoadingStatus;
        __weak typeof(self) weakSelf = self;
        [FXVideoAssetManager loadVideoDataWith:self block:^(AVAsset * _Nullable asset) {
            self.avasset = asset;
            weakSelf.originalDataLoadStatus = self.avasset ? FXPhotoLoadStatusLoadedStatus :FXPhotoLoadStatusLoadErrorStatus;
        }];
    }
}

- (void)cancelLoadOriginalData {
    if (_originalDataLoadStatus == FXPhotoLoadStatusLoadingStatus) {
        [FXVideoAssetManager cancelLoadOriginalDataWith:self];
        self.originalDataLoadStatus = FXPhotoLoadStatusNoLoadStatus;
    }
}

@end
