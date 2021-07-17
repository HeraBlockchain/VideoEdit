//
//  FXSizeHelper.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/11.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXSizeHelper : NSObject

+ (CGAffineTransform)transformFromRotate:(NSInteger)degress natureSize:(CGSize)natureSize;

+ (CGAffineTransform)scaleTransformWithNatureSize:(CGSize)natureSize natureTrans:(CGAffineTransform)naturalTransform renderSize:(CGSize)renderSize toRotate:(NSInteger)degress;

+ (CGSize)renderSizeWithAssetTrack:(AVAssetTrack *)track andPerferedSize:(CGSize)videoSize;

/// There are width requirements for either the iOS encoders or the video format itself. Try making your width even or divisible by 4.
+ (CGSize)fixSize:(CGSize)size;

/// 有时候从视频轨道中读取的 transform 会缺少平移信息，所以需要对偏移信息进行补全
+ (CGAffineTransform)createPreferredTransformWithVideoTrack:(AVAssetTrack *)videoTrack;

@end