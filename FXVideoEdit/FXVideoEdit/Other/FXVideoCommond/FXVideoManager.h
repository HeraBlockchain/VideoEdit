//
//  FXVideoManager.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/17.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVAppendVideoCommand.h"
#import "FXAVCommand.h"
#import "FXAVComposition.h"
#import "FXAVLoadVideoCommand.h"
#import <Foundation/Foundation.h>

#import "FXTimeline.h"

enum {
    kCMPersistentTrackID_Video_Invalid = 1000,
    kCMPersistentTrackID_Audio_Invalid = 2000
};

@interface FXVideoManager : NSObject

//当前的操作缓存
@property (nonatomic, strong) FXAVComposition *cacheComposition;

+ (instancetype)sharedInstance;

- (void)clearWorkSpace;

/**
 *  添加一个视频
 */
- (BOOL)appendVideoByAsset:(AVAsset *)videoAsset;

+ (int32_t)persistentTrackIDWithType:(AVMediaType)type;

@end