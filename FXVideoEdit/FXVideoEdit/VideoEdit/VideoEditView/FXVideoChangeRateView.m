//
//  FXVideoChangeRateView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/12.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoChangeRateView.h"

@interface FXVideoChangeRateView ()

@property (weak, nonatomic) IBOutlet UISlider *rateSlider;

@property (nonatomic, assign) CGFloat value;

@end

@implementation FXVideoChangeRateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor clearColor];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FXVideoChangeRateView" owner:self options:nil];
        self = array.firstObject;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setNeedsDisplay];
}

- (IBAction)clickCancelButton:(id)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (IBAction)clickConfirmButton:(id)sender {
    if (_confirmBlock) {
        _confirmBlock(_value);
    }
}
- (IBAction)sliderChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    CGFloat sliderValue = slider.value;
    if (sliderValue >= 0.5) {
        _value = sliderValue;
    } else {
        _value = 0.25 + sliderValue * 2 * 0.25;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat original = 20;
    CGFloat centerY = 168;
    CGFloat perWidth = (SCREEN_WIDTH - 40) / 4;
    for (int i = 0; i < 5; i++) {
        CGContextBeginPath(ctx);
        CGFloat heighOffset = 0;
        if (i == 0 || i == 4) {
            heighOffset = 15;
        }
        CGContextMoveToPoint(ctx, original + i * perWidth, centerY - 15);
        CGContextAddLineToPoint(ctx, original + i * perWidth, centerY + heighOffset);
        // 设置图形的线宽
        CGContextSetLineWidth(ctx, 2.0);
        // 设置图形描边颜色
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        // 根据当前路径，宽度及颜色绘制线
        CGContextStrokePath(ctx);

        UIFont *font = [UIFont systemFontOfSize:11];
        UIColor *textColor = [UIColor whiteColor];
        NSDictionary *stringAttrs = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
        NSAttributedString *attrStr;
        if (i == 0) {
            attrStr = [[NSAttributedString alloc] initWithString:@"0.25X" attributes:stringAttrs];
        } else if (i == 1) {
            attrStr = [[NSAttributedString alloc] initWithString:@"0.5X" attributes:stringAttrs];

        } else if (i == 2) {
            attrStr = [[NSAttributedString alloc] initWithString:@"1X" attributes:stringAttrs];

        } else if (i == 3) {
            attrStr = [[NSAttributedString alloc] initWithString:@"1.5X" attributes:stringAttrs];

        } else if (i == 4) {
            attrStr = [[NSAttributedString alloc] initWithString:@"2X" attributes:stringAttrs];
        }
        [attrStr drawAtPoint:CGPointMake(original - 5 + i * perWidth, centerY + 15)];
    }
}

@end