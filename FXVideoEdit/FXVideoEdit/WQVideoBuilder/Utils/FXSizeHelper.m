//
//  FXSizeHelper.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/11.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXSizeHelper.h"

@implementation FXSizeHelper

+ (CGSize)renderSizeWithAssetTrack:(AVAssetTrack *)track andPerferedSize:(CGSize)videoSize {
    if (!track)
        return CGSizeZero;
    /// 原始的视频 Rect
    CGRect videoRect = CGRectApplyAffineTransform(CGRectMake(0, 0, track.naturalSize.width, track.naturalSize.height), track.preferredTransform);
    // 保护一下 防止 width 和 height 成为负数
    videoRect = CGRectMake(0, 0, ABS(videoRect.size.width), ABS(videoRect.size.height));
    /// 根据 videoRect 的宽高计算是横着的还是竖着的视频
    /// 得出预期会得到一个多大的视频
    BOOL isVertical = videoRect.size.width < videoRect.size.height ? YES : NO;
    CGRect preferredRect = CGRectZero;
    if (isVertical) {
        preferredRect = CGRectMake(0, 0, MIN(videoSize.width, videoSize.height), MAX(videoSize.width, videoSize.height));
    } else {
        preferredRect = CGRectMake(0, 0, MAX(videoSize.width, videoSize.height), MIN(videoSize.width, videoSize.height));
    }
    /// 因为 videoRect 和 prefereedRect 不一定是成比例的
    /// renderSize = videoRect * stretchRate(最大的压缩比)
    // 短边比短边，长边比长边--> 最大的压缩比
    CGFloat minStretchRate = MIN(videoRect.size.height, videoRect.size.width) / MIN(preferredRect.size.height, preferredRect.size.width);
    CGFloat maxStretchRate = MAX(videoRect.size.height, videoRect.size.width) / MAX(preferredRect.size.height, preferredRect.size.width);
    CGFloat stretchRate = MAX(maxStretchRate, minStretchRate);
    CGSize renderSize = CGSizeMake(videoRect.size.width / stretchRate, videoRect.size.height / stretchRate);
    renderSize = [self fixSize:renderSize];
    return renderSize;
}

+ (CGAffineTransform)transformFromRotate:(NSInteger)degress natureSize:(CGSize)natureSize {
    /** 矩阵校正 */
    // x = ax1 + cy1 + tx,y = bx1 + dy2 + ty
    if (degress == 1) {
        return CGAffineTransformMake(0, 1, -1, 0, natureSize.height, 0);
    } else if (degress == 2) {
        return CGAffineTransformMake(-1, 0, 0, -1, natureSize.width, natureSize.height);
    } else if (degress == 3) {
        return CGAffineTransformMake(0, -1, 1, 0, 0, natureSize.width);
    } else {
        return CGAffineTransformIdentity;
    }
}

+ (CGAffineTransform)scaleTransformWithNatureSize:(CGSize)natureSize natureTrans:(CGAffineTransform)naturalTransform renderSize:(CGSize)renderSize toRotate:(NSInteger)degress {
    if (renderSize.height == 0 || renderSize.width == 0)
        return CGAffineTransformIdentity;
    if (degress == 1 || degress == 3) {
        natureSize = CGSizeMake(natureSize.height, natureSize.width);
    }
    CGFloat scale = MIN(renderSize.width / natureSize.width, renderSize.height / natureSize.height);
    // 移至中心点
    CGPoint translate = CGPointMake((renderSize.width - natureSize.width * scale) * 0.5, (renderSize.height - natureSize.height * scale) * 0.5);
    CGAffineTransform preferredTransform = CGAffineTransformMake(naturalTransform.a * scale, naturalTransform.b * scale, naturalTransform.c * scale, naturalTransform.d * scale, naturalTransform.tx * scale + translate.x, naturalTransform.ty * scale + translate.y);
    return preferredTransform;
}

+ (CGSize)fixSize:(CGSize)size {
    return CGSizeMake((ceil(size.width / 4) * 4), (ceil(size.height / 4) * 4));
}

+ (CGAffineTransform)createPreferredTransformWithVideoTrack:(AVAssetTrack *)videoTrack {
    CGSize naturalSize = videoTrack.naturalSize;
    CGAffineTransform preferredTransform = videoTrack.preferredTransform;
    // 假设对于左上角坐标系（X 轴向右，Y 轴向下）的一张图片进行旋转
    // image.size = (110, 50)
    // 图片的左上角在（0，0）锚点是 (0, 0)
    // transform = [0 -1 1 0 0 0]
    // 对图片应用这个 transform ,相当于绕着锚点逆时针旋转了90度
    // 但是这个时候渲染就会出问题……我们需要把图片再向下平移 110，让图片的左上角对准（0，0）

    // 对原始的 Size 进行旋转相当于是对上面的描述的一次模拟，得出 tSize.width/height < 0 说明我们需要把图片进行平移操作
    // transform.tx = tSize.width < 0? -tSize.width:0,
    // transform.ty = tSize.height < 0? -tSize.height:0

    // 没错，上面👆那坨东西都是我的猜想，反正用了下面这坨代码，看上去 bug 已经修复了

    CGSize tSize = CGSizeApplyAffineTransform(naturalSize, preferredTransform);

    preferredTransform = CGAffineTransformMake(preferredTransform.a,
                                               preferredTransform.b,
                                               preferredTransform.c,
                                               preferredTransform.d,
                                               tSize.width < 0 ? -tSize.width : 0,
                                               tSize.height < 0 ? -tSize.height : 0);
    return preferredTransform;
}

@end