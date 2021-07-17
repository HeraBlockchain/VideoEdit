//
//  FXVideoAssetManager.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoAssetManager.h"

@import Photos;

@interface FXVideoAssetManager ()

@property (nonatomic, strong) PHImageManager *imageManager;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation FXVideoAssetManager

#pragma mark 对外
+ (void)loadAllideoAssetWithBlock:(FXLoadAssetDataModelsBlock)block {
    [PHPhotoLibrary.sharedPhotoLibrary
        performChanges:^{
            [FXVideoAssetManager.p_sharePhotoAssetManager p_loadAllVideoAssetWithBlock:block];
        }
        completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusNotDetermined) { //没有作出选择。
                    [PHPhotoLibrary
                        requestAuthorization:^(PHAuthorizationStatus status) {
                            if (status == PHAuthorizationStatusAuthorized) {
                                [FXVideoAssetManager.p_sharePhotoAssetManager p_loadAllVideoAssetWithBlock:block];
                            } else { //用户拒绝访问相册数据。
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    block(nil);
                                });
                            }
                        }];
                } else { //用户拒绝访问相册数据。
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(nil);
                    });
                }
            }
        }];
}

+ (void)loadThumbImageWith:(FXVideoAssetDataModel *)asset size:(CGSize)size block:(FXLoadedThumbImageBlock)block {
    FXVideoAssetManager *manager = FXVideoAssetManager.p_sharePhotoAssetManager;
    [manager.operationQueue addOperationWithBlock:^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.networkAccessAllowed = YES;
        options.synchronous = YES;
        [manager.imageManager requestImageForAsset:asset.asset
                                        targetSize:size
                                       contentMode:PHImageContentModeAspectFill
                                           options:options
                                     resultHandler:^(UIImage *_Nullable result, NSDictionary *_Nullable info) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             block(result);
                                         });
                                     }];
    }];
}

+ (void)loadVideoDataWith:(FXVideoAssetDataModel *)asset block:(FXLoadedVideoDataBlock)block {
//    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@.mp4", asset.asset.localIdentifier.md5String, NSUUID.UUID.UUIDString, @(arc4random())];
//    NSString *outputPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"VideoAssets"] stringByAppendingPathComponent:fileName];
//    [NSFileManager.defaultManager removeItemAtPath:outputPath error:NULL];
//    [NSFileManager.defaultManager createDirectoryAtPath:outputPath.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:NULL];
    PHVideoRequestOptions *options = PHVideoRequestOptions.new;
    options.networkAccessAllowed = YES;
    options.version = PHVideoRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    FXVideoAssetManager *manager = FXVideoAssetManager.p_sharePhotoAssetManager;
    asset.requestID = [manager.imageManager requestAVAssetForVideo:asset.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(asset);
        });
    }];
}

+ (void)cancelLoadOriginalDataWith:(FXVideoAssetDataModel *)asset {
    PHImageRequestID requestID = asset.requestID;
    if (requestID != PHInvalidImageRequestID) {
        FXVideoAssetManager *manager = FXVideoAssetManager.p_sharePhotoAssetManager;
        [manager.imageManager cancelImageRequest:requestID];
    }
}

#pragma mark -

#pragma mark NSObject
- (instancetype)init {
    self = [super init];
    if (self) {
        _imageManager = [PHImageManager defaultManager];
        _operationQueue = [NSOperationQueue new];
        _operationQueue.maxConcurrentOperationCount = 4;
        _operationQueue.name = @"FXVideoAssetManager";
    }

    return self;
}
#pragma mark -

#pragma mark 逻辑
+ (FXVideoAssetManager *)p_sharePhotoAssetManager {
    static FXVideoAssetManager *shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FXVideoAssetManager alloc] init];
    });
    return shareManager;
}

- (void)p_loadAllVideoAssetWithBlock:(FXLoadAssetDataModelsBlock)block {
    PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    NSMutableArray<PHAssetCollection *> *array = [NSMutableArray
        arrayWithCapacity:smartAlbums.count];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumSlomoVideos || obj.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos) {
            [array addObject:obj];
        }
    }];

    NSMutableDictionary *cache = NSMutableDictionary.dictionary;
    NSMutableArray<FXVideoAssetDataModel *> *result = NSMutableArray.new;
    __weak typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(PHAssetCollection *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSArray<PHAsset *> *assets = [weakSelf p_assetWithAssetCollection:obj];
        [assets enumerateObjectsUsingBlock:^(PHAsset *_Nonnull obj2, NSUInteger idx2, BOOL *_Nonnull stop2) {
            if (!cache[obj2.localIdentifier]) {
                FXVideoAssetDataModel *dataModel = [FXVideoAssetDataModel.alloc initWithAsset:obj2];
                cache[obj2.localIdentifier] = dataModel;
                [result addObject:dataModel];
            }
        }];
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        block(result);
    });
}

- (NSArray<PHAsset *> *)p_assetWithAssetCollection:(PHAssetCollection *)assetCollection {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.includeHiddenAssets = NO;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO];
    options.sortDescriptors = @[sortDescriptor];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType==%@", @(PHAssetMediaTypeVideo)];
    PHFetchResult<PHAsset *> *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    NSMutableArray<PHAsset *> *result = [NSMutableArray arrayWithCapacity:assetsFetchResult.count];
    [assetsFetchResult enumerateObjectsUsingBlock:^(PHAsset *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [result addObject:obj];
    }];
    return result;
}
#pragma mark -

@end
