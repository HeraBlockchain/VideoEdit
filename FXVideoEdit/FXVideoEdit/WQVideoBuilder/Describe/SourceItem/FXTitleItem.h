//
//  FXTitleItem.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXSourceItem.h"
#import <QuartzCore/QuartzCore.h>

@interface FXTitleItem : FXSourceItem

+ (instancetype)titleItemWithText:(NSString *)text image:(UIImage *)image;

- (instancetype)initWithText:(NSString *)text image:(UIImage *)image;

@property (copy, nonatomic) NSString *identifier;

@property (nonatomic) BOOL animateImage;

@property (nonatomic) BOOL useLargeFont;

- (CALayer *)buildLayer;

@end