//
//  FXVideoManager.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/17.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoManager.h"

@interface FXVideoManager ()

//存放操作步骤
@property (nonatomic, strong) NSMutableArray<FXTimeline *> *timeLineArray;

//保存每步的操作步骤，用来做撤销操作
@property (nonatomic, strong) NSMutableArray<FXAVComposition *> *workSpaceArray;

@property (nonatomic, assign) int32_t trackIndex;

@end

@implementation FXVideoManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)clearWorkSpace {
    _cacheComposition = nil;
    [_workSpaceArray removeAllObjects];
}

#pragma mark 视频操作

/**
 *  添加一个视频
 */
- (BOOL)appendVideoByAsset:(AVAsset *)videoAsset {
    if (![self checkVideo:videoAsset]) {
        return NO;
    }
    if (self.cacheComposition) {
        //已经有操作了，添加视频
        FXAVAppendVideoCommand *appendCommand = [[FXAVAppendVideoCommand alloc] initWithComposition:self.cacheComposition];
        [appendCommand performWithAsset:self.cacheComposition.mutableComposition appendAsset:videoAsset];
    } else {
        self.cacheComposition = [FXAVComposition new];
        FXAVLoadVideoCommand *command = [[FXAVLoadVideoCommand alloc] initWithComposition:self.cacheComposition];
        [command performWithAsset:videoAsset];
    }

    return YES;
}

#pragma mark functions

- (void)AVEditorNotification:(NSNotification *)notification {
}

- (BOOL)checkVideo:(AVAsset *)videoAsset {
    if (!videoAsset || !videoAsset.playable) {
        return NO;
    }
    return YES;
}

+ (int32_t)persistentTrackIDWithType:(AVMediaType)type {
    FXVideoManager *manager = [FXVideoManager sharedInstance];
    manager.trackIndex++;
    if (type == AVMediaTypeVideo) {
        return manager.trackIndex + kCMPersistentTrackID_Video_Invalid;
    }
    return manager.trackIndex + kCMPersistentTrackID_Audio_Invalid;
}

@end