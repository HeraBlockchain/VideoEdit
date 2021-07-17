//
//  FXVideoModeifyParameterTypeView.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterTypeView.h"
#import "UIView+Yoga.h"

@interface FXVideoModeifyParameterTypeView ()

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, assign) FXVideoModeifyParameterType type;

@end

@implementation FXVideoModeifyParameterTypeView

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        {
            [self configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                layout.isEnabled = YES;
                layout.width = YGPercentValue(100);
                layout.height = YGPercentValue(100);
                layout.flexDirection = YGFlexDirectionRow;
                layout.justifyContent = YGJustifySpaceAround;
                layout.alignItems = YGAlignCenter;
            }];
        }

        {
            //14 20;
            NSMutableArray<UIButton *> *buttons = NSMutableArray.new;
            UIButton *button = nil;

            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = FXVideoModeifyParameterEditType;
            [buttons addObject:button];
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = FXVideoModeifyParameterSpecialEffectsType;
            [buttons addObject:button];
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = FXVideoModeifyParameterAudioType;
            [buttons addObject:button];
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = FXVideoModeifyParameterSubtitleType;
            [buttons addObject:button];

            NSDictionary *titles = @{@(FXVideoModeifyParameterEditType): @"剪辑",
                                     @(FXVideoModeifyParameterSpecialEffectsType): @"特效",
                                     @(FXVideoModeifyParameterAudioType): @"音频",
                                     @(FXVideoModeifyParameterSubtitleType): @"字幕"};
            NSDictionary *normalImageNames = @{@(FXVideoModeifyParameterEditType): @"剪辑",
                                               @(FXVideoModeifyParameterSpecialEffectsType): @"特效",
                                               @(FXVideoModeifyParameterAudioType): @"音频",
                                               @(FXVideoModeifyParameterSubtitleType): @"字幕"};
            NSDictionary *selectedImageNames = @{@(FXVideoModeifyParameterEditType): @"剪辑-选中",
                                                 @(FXVideoModeifyParameterSubtitleType): @"字幕-选中"};

            __weak typeof(self) weakSelf = self;
            [buttons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSString *title = titles[@(obj.tag)];
                [obj setTitle:title forState:UIControlStateNormal];
                NSString *normalImageName = normalImageNames[@(obj.tag)];
                UIImage *normalImage = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                UIImage *selectedImage = nil;
                NSString *selectedImageName = selectedImageNames[@(obj.tag)];
                if (selectedImageName) {
                    selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                } else {
                    selectedImage = [[normalImage sd_tintedImageWithColor:[UIColor colorWithRGBA:0xF54184FF]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                }
                [obj setImage:normalImage forState:UIControlStateNormal];
                [obj setImage:selectedImage forState:UIControlStateSelected];
                [obj setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                [obj setTitleColor:[UIColor colorWithRGBA:0xF54184FF] forState:UIControlStateSelected];
                [obj setTintColor:[obj titleColorForState:obj.state]];
                obj.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 20 : 14];
                [obj addBlockForControlEvents:UIControlEventTouchUpInside
                                        block:^(UIButton *_Nonnull sender) {
                                            weakSelf.selectedButton = sender;
                                            if (weakSelf.clickButtonActionBlock) {
                                                weakSelf.clickButtonActionBlock(weakSelf);
                                            }
                                        }];

                [obj configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                    layout.isEnabled = YES;
                    layout.height = YGPercentValue(100);
                    layout.width = YGPercentValue(20);
                }];

                [weakSelf addSubview:obj];
            }];

            self.selectedButton = buttons.firstObject;
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.yoga applyLayoutPreservingOrigin:YES];
}
#pragma mark -

#pragma mark setter
- (void)setSelectedButton:(UIButton *)selectedButton {
    _selectedButton.tintColor = UIColor.whiteColor;
    _selectedButton.selected = NO;
    _selectedButton.backgroundColor = UIColor.clearColor;
    _selectedButton = selectedButton;
    _selectedButton.selected = YES;
    self.type = selectedButton.tag;
    _selectedButton.backgroundColor = [UIColor colorWithRGBA:0x181818FF];
}
#pragma mark -

@end