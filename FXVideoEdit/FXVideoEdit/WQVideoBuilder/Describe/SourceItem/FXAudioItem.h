//
//  FXAudioItem.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXMediaItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXAudioItem : FXMediaItem

@property (nonatomic, strong) AVAssetTrack *audioTrack;

@end

NS_ASSUME_NONNULL_END