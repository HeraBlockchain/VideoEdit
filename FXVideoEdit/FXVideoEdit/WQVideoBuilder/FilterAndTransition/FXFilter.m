//
//  FXFilter.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXFilter.h"

@interface FXFilter ()

@property (nonatomic, strong) CIFilter *filter;

@end

@implementation FXFilter

+ (instancetype)initWithTransType:(FXTransType)type {
    FXFilter *transition = [[FXFilter alloc] init];
    transition.filter = [FXTransitionDescribe filterWithType:type];
    [transition.filter setDefaults];
    return transition;
}


- (CIImage *)imageFilterEffectWithType:(FXFilterDescribeType)type
                           sourceImage:(CIImage *)image
{
    CIFilter *filter = [FXFilterDescribe filterWithType:type];
    if (!filter) {
        return image;
    }
    [filter setValue:image forKey:@"inputImage"];
    return filter.outputImage;
}


- (void)setForgroundImage:(CIImage *)forgroundImage {
    _forgroundImage = forgroundImage;
    [self.filter setValue:forgroundImage forKey:@"inputImage"];
}

- (void)setBackgroundImage:(CIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self.filter setValue:backgroundImage forKey:@"inputTargetImage"];
}

- (void)setInputTime:(NSNumber *)inputTime {
    _inputTime = inputTime;
    [self.filter setValue:self.inputTime forKey:@"inputTime"];
}

- (CIImage *)outputImage {
    return self.filter.outputImage;
}

@end
