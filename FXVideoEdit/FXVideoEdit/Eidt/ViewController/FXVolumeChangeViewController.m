//
//  FXVolumeChangeViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVolumeChangeViewController.h"
#import "UIView+Yoga.h"

@interface FXVolumeChangeViewController ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation FXVolumeChangeViewController

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

    NSArray<NSNumber *> *tags = @[@(FXMainVolumeChangeType), @(FXPIPVolumeChangeType), @(FXDubbingVolumeChangeType), @(FXSoundtrackVolumeChangeType)];

    {
        UIView *leftView = UIView.new;
        [_contentView addSubview:leftView];
        [leftView configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
            layout.isEnabled = YES;
            layout.borderRightWidth = 10;
            layout.width = YGPercentValue(20);
            layout.height = YGPercentValue(100);
        }];

        NSDictionary<NSNumber *, NSString *> *titles = @{@(FXMainVolumeChangeType): @"主视频",
                                                         @(FXPIPVolumeChangeType): @"画中画",
                                                         @(FXDubbingVolumeChangeType): @"配音",
                                                         @(FXSoundtrackVolumeChangeType): @"配乐",
        };

        [tags enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            UILabel *label = UILabel.new;
            label.textColor = UIColor.whiteColor;
            label.font = [UIFont systemFontOfSize:IS_IPAD ? 18 : 13];
            label.text = titles[obj];
            label.textAlignment = NSTextAlignmentRight;
            [label configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                layout.isEnabled = YES;
                layout.width = YGPercentValue(100);
                layout.height = YGPercentValue(100.0 / tags.count);
            }];
            [leftView addSubview:label];
        }];
    }

    {
        UIView *rightView = UIView.new;
        [_contentView addSubview:rightView];
        [rightView configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
            layout.isEnabled = YES;
            layout.borderRightWidth = 10;
            layout.width = YGPercentValue(80);
            layout.height = YGPercentValue(100);
        }];

        [tags enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            UISlider *slider = UISlider.new;
            slider.tag = obj.integerValue;
            slider.minimumValue = 0;
            slider.maximumValue = 100;
            slider.value = slider.maximumValue;
            {
                UILabel *minimum = UILabel.new;
                minimum.textColor = UIColor.whiteColor;
                minimum.font = [UIFont systemFontOfSize:IS_IPAD ? 16 : 8];
                minimum.text = [NSString stringWithFormat:@"%@ ", [NSNumber numberWithInteger:slider.minimumValue]];
                [minimum sizeToFit];
                slider.minimumValueImage = [minimum qmui_snapshotLayerImage];
            }
            {
                UILabel *maximum = UILabel.new;
                maximum.textColor = UIColor.whiteColor;
                maximum.font = [UIFont systemFontOfSize:IS_IPAD ? 16 : 8];
                maximum.text = [NSString stringWithFormat:@" %@", [NSNumber numberWithInteger:slider.maximumValue]];
                [maximum sizeToFit];
                slider.maximumValueImage = [maximum qmui_snapshotLayerImage];
            }

            [slider configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                layout.isEnabled = YES;
                layout.width = YGPercentValue(100);
                layout.height = YGPercentValue(100.0 / tags.count);
            }];

            [slider setThumbImage:[UIImage imageNamed:@"VolumeSliderThumbImage"] forState:UIControlStateNormal];
            slider.minimumTrackTintColor = [UIColor colorWithRGBA:0xF54184FF];
            slider.maximumTrackTintColor = UIColor.whiteColor;

            [slider addBlockForControlEvents:UIControlEventValueChanged
                                       block:^(UISlider *_Nonnull sender) {
                                           if (weakSelf.volumeChangeBlock) {
                                               weakSelf.volumeChangeBlock(sender.tag, sender.value);
                                           }
                                       }];

            [rightView addSubview:slider];
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

@end