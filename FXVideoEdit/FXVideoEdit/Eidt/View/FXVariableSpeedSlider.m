//
//  FXVariableSpeedSlider.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/7.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVariableSpeedSlider.h"

@implementation FXVariableSpeedSlider

#pragma mark UISlider
- (CGRect)trackRectForBounds:(CGRect)bounds {
    UIImage *image = [self thumbImageForState:UIControlStateNormal];
    CGRect result = [super trackRectForBounds:bounds];
    return CGRectInset(result, image.size.width / 2, 0);
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    UIImage *image = [self thumbImageForState:UIControlStateNormal];
    return [super thumbRectForBounds:bounds trackRect:CGRectInset(rect, image.size.width / -2, 0) value:value];
}

#pragma mark -

#pragma mark UIView
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [UIColor.whiteColor setStroke];
    UIImage *image = [self thumbImageForState:UIControlStateNormal];
    for (NSUInteger i = 0; i < 5; ++i) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        bezierPath.lineWidth = 2;
        [bezierPath moveToPoint:CGPointMake((CGRectGetWidth(rect) - image.size.width - 2) / 4 * i + image.size.width / 2 + 1, 0)];
        [bezierPath addLineToPoint:CGPointMake(bezierPath.currentPoint.x, (i == 0 || i == 4) ? CGRectGetMaxY(rect) : CGRectGetMidY(rect))];
        [bezierPath stroke];
    }
}
#pragma mark -

@end