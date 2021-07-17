//
//  FXTimeRulerView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/16.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeRulerView.h"

@interface FXTimeRulerView ()

@property (assign, nonatomic) CGFloat widthPerSecond;
@property (strong, nonatomic) UIColor *themeColor;
@property (assign, nonatomic) Float64 timeInterval;

@end

@implementation FXTimeRulerView

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, nil);
    @throw nil;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (instancetype)initWithFrame:(CGRect)frame widthPerSecond:(CGFloat)width themeColor:(UIColor *)color totalTime:(Float64)timeInterval {
    self = [super initWithFrame:frame];
    if (self) {
        _widthPerSecond = width;
        _themeColor = color;
        _timeInterval = timeInterval;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark--- 画大刻度
- (void)drawBigScale:(float)x context:(CGContextRef)ctx {
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);

    CGContextMoveToPoint(ctx, x + 0.5, 13);
    CGContextAddLineToPoint(ctx, x + 0.5, 30);
    // 设置图形的线宽
    CGContextSetLineWidth(ctx, 1.0);
    // 设置图形描边颜色
    CGContextSetStrokeColorWithColor(ctx, self.themeColor.CGColor);
    // 根据当前路径，宽度及颜色绘制线
    CGContextStrokePath(ctx);
}

#pragma mark--- 画小刻度
- (void)drawSmallScale:(float)x context:(CGContextRef)ctx {
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);

    CGContextMoveToPoint(ctx, x + 0.5, 13);
    CGContextAddLineToPoint(ctx, x + 0.5, 20);
    // 设置图形的线宽
    CGContextSetLineWidth(ctx, 1.0);
    // 设置图形描边颜色
    CGContextSetStrokeColorWithColor(ctx, self.themeColor.CGColor);
    // 根据当前路径，宽度及颜色绘制线
    CGContextStrokePath(ctx);
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat widthPerSecond = width / _timeInterval;

    NSInteger timeStep = 0;
    for (CGFloat m = 0; m <= width; m += widthPerSecond) {
        [self drawBigScale:m context:context];
        NSInteger minutes = timeStep / 60;
        NSInteger seconds = timeStep % 60;
        UIFont *font = [UIFont systemFontOfSize:11];
        UIColor *textColor = self.themeColor;
        NSDictionary *stringAttrs = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
        NSAttributedString *attrStr;
        if (minutes > 0) {
            attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds] attributes:stringAttrs];
        } else {
            attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02ld", (long)seconds] attributes:stringAttrs];
        }
        [attrStr drawAtPoint:CGPointMake(m - 7, 0)];
        timeStep++;
    }
    for (CGFloat m = 0; m <= width; m += (widthPerSecond / 4)) {
        [self drawSmallScale:m context:context];
    }
}

#pragma mark - Private methods

- (CGFloat)widthPerSecond {
    return _widthPerSecond ?: 25.0;
}

- (UIColor *)themeColor {
    return _themeColor ?: [UIColor lightGrayColor];
}

@end