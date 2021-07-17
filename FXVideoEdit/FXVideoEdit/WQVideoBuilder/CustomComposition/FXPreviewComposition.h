//
//  FXPreviewComposition.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/17.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FXVideoDescribe;

@interface FXPreviewComposition : NSObject

- (instancetype)initWithVideo:(FXVideoDescribe *)videoDescribe;

- (AVPlayerItem *)buildForCropPreview;

@end
