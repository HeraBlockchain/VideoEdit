//
//  FXVideoModeifyParameterBottomToolView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterBottomToolView.h"
#import "UIView+Yoga.h"

@implementation FXVideoModeifyParameterBottomToolView

#pragma mark 对外
- (void)setItmes:(NSArray<UIView *> *)itmes {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    __weak typeof(self) weakSelf = self;
    [itmes enumerateObjectsUsingBlock:^(UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [weakSelf addSubview:obj];
    }];

    [self setNeedsLayout];
}
#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            self.backgroundColor = UIColor.clearColor;
        }

        {
            [self configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                layout.isEnabled = YES;
                layout.flexDirection = YGFlexDirectionRow;
                layout.justifyContent = YGJustifyCenter;
                layout.alignItems = YGAlignCenter;
                layout.width = YGPercentValue(100);
                layout.height = YGPercentValue(100);
            }];
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.yoga applyLayoutPreservingOrigin:YES];
}
#pragma mark -

@end