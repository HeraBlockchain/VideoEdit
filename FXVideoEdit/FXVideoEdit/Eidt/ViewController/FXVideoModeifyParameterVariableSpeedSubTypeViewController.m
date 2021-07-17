//
//  FXVideoModeifyParameterVariableSpeedSubTypeViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterVariableSpeedSubTypeViewController.h"
#import "FXCustomSubTypeTitleView.h"
#import "FXVariableSpeedSlider.h"

@interface FXVideoModeifyParameterVariableSpeedSubTypeViewController ()

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) NSArray<UILabel *> *labels;

@property (nonatomic, strong) UILabel *selectedLabel;

@end

@implementation FXVideoModeifyParameterVariableSpeedSubTypeViewController

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    {
        FXCustomSubTypeTitleView *topView = FXCustomSubTypeTitleView.new;
        topView.title = @"变速";
        topView.closeButtonActionBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

        topView.doneButtonActionBlock = ^{
            if (weakSelf.variableSpeedBlock) {
                switch ([weakSelf.labels indexOfObjectIdenticalTo:self.selectedLabel]) {
                    case 0:
                        weakSelf.variableSpeedBlock(0.25);
                        break;
                    case 1:
                        weakSelf.variableSpeedBlock(0.5);
                        break;
                    case 2:
                        weakSelf.variableSpeedBlock(1.0);
                        break;
                    case 3:
                        weakSelf.variableSpeedBlock(1.5);
                        break;
                    case 4:
                        weakSelf.variableSpeedBlock(2.0);
                        break;
                    default:
                        break;
                }
            }
        };
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(topView.superview);
            make.height.mas_equalTo(FXCustomSubTypeTitleView.heightOfCustomSubTypeTitleView);
        }];
    }

    {
        _slider = FXVariableSpeedSlider.new;
        [_slider addBlockForControlEvents:UIControlEventTouchUpInside
                                    block:^(FXVariableSpeedSlider *_Nonnull sender) {
                                        [weakSelf p_updateSelectedLabel];
                                        sender.value = [weakSelf.labels indexOfObjectIdenticalTo:weakSelf.selectedLabel] * 100;
                                    }];
        [_slider addBlockForControlEvents:UIControlEventValueChanged
                                    block:^(id _Nonnull sender) {
                                        [weakSelf p_updateSelectedLabel];
                                    }];
        _slider.minimumValue = 0;
        _slider.maximumValue = 400;
        _slider.value = 200;
        [_slider setThumbImage:[UIImage imageNamed:@"VariableSpeedThumbImage"] forState:UIControlStateNormal];
        _slider.minimumTrackTintColor = UIColor.whiteColor;
        _slider.maximumTrackTintColor = UIColor.whiteColor;
        [self.view addSubview:_slider];
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.slider.superview);
            make.width.equalTo(weakSelf.slider.superview).offset(IS_IPAD ? -334 : -110);
            make.centerY.equalTo(weakSelf.slider.superview);
        }];
    }

    {
        _labels = @[
            UILabel.new,
            UILabel.new,
            UILabel.new,
            UILabel.new,
            UILabel.new,
        ];

        NSArray<NSString *> *titles = @[@"0.25X", @"0.5X", @"1X", @"1.5X", @"2X"];
        [_labels enumerateObjectsUsingBlock:^(UILabel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.text = titles[idx];
            obj.font = [UIFont systemFontOfSize:IS_IPAD ? 20 : 15];
            obj.textColor = UIColor.whiteColor;
            obj.textAlignment = NSTextAlignmentCenter;
            [weakSelf.view addSubview:obj];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.slider.mas_bottom).offset(10);
                make.width.equalTo(weakSelf.slider).multipliedBy(0.25);
                if (idx == 0) {
                    make.centerX.equalTo(weakSelf.slider.mas_left);
                } else {
                    make.left.equalTo(weakSelf.labels[idx - 1].mas_right);
                }
            }];
        }];

        self.selectedLabel = _labels[2];
    }
}
#pragma mark -

#pragma mark 逻辑
- (void)p_updateSelectedLabel {
    NSUInteger index = (_slider.value + 50) / 100;
    self.selectedLabel = _labels[index];
}
#pragma mark -

#pragma mark setter
- (void)setSelectedLabel:(UILabel *)selectedLabel {
    _selectedLabel.textColor = UIColor.whiteColor;
    _selectedLabel = selectedLabel;
    _selectedLabel.textColor = [UIColor colorWithRGBA:0xF54184FF];
}
#pragma mark -

@end