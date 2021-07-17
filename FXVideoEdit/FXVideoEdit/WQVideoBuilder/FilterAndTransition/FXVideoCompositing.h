//
//  FXVideoCompositing.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/30.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface FXVideoCompositing : NSObject <AVVideoCompositing>

@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *sourcePixelBufferAttributes;

@property (nonatomic, strong) NSDictionary<NSString *, id> *_Nullable requiredPixelBufferAttributesForRenderContext;

@end