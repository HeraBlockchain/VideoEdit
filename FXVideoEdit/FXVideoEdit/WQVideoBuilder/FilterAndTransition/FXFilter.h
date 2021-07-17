//
//  FXFilter.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXFilterDescribe.h"
#import "FXTransitionDescribe.h"

@interface FXFilter : NSObject

@property (nonatomic, strong, nonnull) CIImage *forgroundImage; ///< the forground image from which you want to transition
@property (nonatomic, strong, nonnull) CIImage *backgroundImage; ///< the background image to which you want to transition.

@property (nonatomic, assign, nonnull) NSNumber *inputTime; ///< min(max(2*(time - 0.25), 0), 1)

@property (nonatomic, readonly, nullable) CIImage *outputImage;

+ (instancetype)initWithTransType:(FXTransType)type;

- (CIImage *)imageFilterEffectWithType:(FXFilterDescribeType)type
                           sourceImage:(CIImage *)image;

@end
