//
//  FXPictureSizeChangeViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXPictureSizeChangeViewController.h"

#import "UIView+Yoga.h"

@interface FXPictureSizeChangeViewController ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *seletedButton;

@end

@implementation FXPictureSizeChangeViewController

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    {
        self.view.backgroundColor = UIColor.clearColor;
    }

    __weak typeof(self) weakSelf = self;
    {
        _contentView = UIView.new;
        [_contentView configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
            layout.isEnabled = YES;
            layout.flexDirection = YGFlexDirectionRow;
            layout.justifyContent = YGJustifyCenter;
            layout.alignItems = YGAlignCenter;
            layout.width = YGPercentValue(100);
            layout.height = YGPercentValue(100);
        }];
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView.superview).insets(UIEdgeInsetsMake(10, 5, 20, 5));
        }];
    }

    {
        NSDictionary<NSNumber *, NSString *> *titles = @{@(FXPictureSizeDefult): @"原始",
                                                         @(FXPictureSize9X16): @"9:16",
                                                         @(FXPictureSize3X4): @"3:4",
                                                         @(FXPictureSize1X1): @"1:1",
                                                         @(FXPictureSize4X3): @"4:3",
                                                         @(FXPictureSize16X9): @"16:9",
        };
        NSDictionary<NSNumber *, NSString *> *imageNames = @{@(FXPictureSizeDefult): @"原始",
                                                             @(FXPictureSize9X16): @"9_16",
                                                             @(FXPictureSize3X4): @"3_4",
                                                             @(FXPictureSize1X1): @"1_1",
                                                             @(FXPictureSize4X3): @"4_3",
                                                             @(FXPictureSize16X9): @"16_9",
        };

        NSArray<NSNumber *> *tags = @[@(FXPictureSizeDefult), @(FXPictureSize9X16), @(FXPictureSize3X4), @(FXPictureSize1X1), @(FXPictureSize4X3), @(FXPictureSize16X9)];

        [tags enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            QMUIButton *button = QMUIButton.new;
            button.tag = obj.integerValue;
            [button setTitle:titles[obj] forState:UIControlStateNormal];
            UIImage *image = [UIImage imageNamed:imageNames[obj]];
            [button setImage:image forState:UIControlStateNormal];
            image = [image sd_tintedImageWithColor:[UIColor colorWithRGBA:0xF54184FF]];
            [button setImage:image forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithRGBA:0xF54184FF] forState:UIControlStateSelected];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.imagePosition = QMUIButtonImagePositionTop;
            button.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 16 : 14];
            button.spacingBetweenImageAndTitle = IS_IPAD ? 4 : 2;
            [button addBlockForControlEvents:UIControlEventTouchUpInside
                                       block:^(UIButton *_Nonnull sender) {
                                           weakSelf.seletedButton = sender;
                                           if (weakSelf.choosePictureSizeBlock) {
                                               weakSelf.choosePictureSizeBlock(sender.tag);
                                           }
                                       }];

            [button configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                layout.isEnabled = YES;
                layout.height = YGPercentValue(100);
                layout.width = YGPercentValue(100.0 / tags.count);
            }];

            [weakSelf.contentView addSubview:button];
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_contentView.yoga applyLayoutPreservingOrigin:YES];
}
#pragma mark -

#pragma mark <UIPopoverPresentationControllerDelegate>
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
#pragma mark -

#pragma mark setter
- (void)setSeletedButton:(UIButton *)seletedButton {
    _seletedButton.selected = NO;
    _seletedButton = seletedButton;
    _seletedButton.selected = YES;
}
#pragma mark -

@end