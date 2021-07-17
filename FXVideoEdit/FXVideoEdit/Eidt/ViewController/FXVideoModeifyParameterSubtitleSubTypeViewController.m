//
//  FXVideoModeifyParameterSubtitleSubTypeViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterSubtitleSubTypeViewController.h"
#import "FXCustomSubTypeTitleView.h"
#import "FXFontManager.h"
#import "FXVideoModeifyParameterFontCollectionViewCell.h"
#import <YYKit/YYKit.h>
#import "FXVideoRollView.h"

@interface FXVideoModeifyParameterSubtitleSubTypeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray<NSString *> *fontNames;

@property (nonatomic, strong) NSArray<NSNumber *> *colors;

@property (nonatomic, strong) UICollectionView *fontCollectionView;

@property (nonatomic, strong) UICollectionView *colorCollectionView;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) QMUIButton *styleButton;

@property (nonatomic, strong) QMUIButton *durationButton;

@property (nonatomic, strong) FXVideoRollView *rollView;

@end

@implementation FXVideoModeifyParameterSubtitleSubTypeViewController

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    {
        FXCustomSubTypeTitleView *topView = FXCustomSubTypeTitleView.new;
        topView.title = @"字幕";
        topView.closeButtonActionBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

        topView.doneButtonActionBlock = ^{
            if (weakSelf.fontCollectionView.indexPathsForSelectedItems.count > 0 && weakSelf.colorCollectionView.indexPathsForSelectedItems.count > 0) {
                UIFont *font = [(FXVideoModeifyParameterFontCollectionViewCell *)[weakSelf.fontCollectionView cellForItemAtIndexPath:weakSelf.fontCollectionView.indexPathsForSelectedItems.firstObject] font];
                font = [font fontWithSize:IS_IPAD ? 20 : 14];
                UIColor *color = [[UIColor colorWithRGBA:weakSelf.colors[weakSelf.colorCollectionView.indexPathsForSelectedItems.firstObject.row].unsignedIntValue] colorWithAlphaComponent:weakSelf.slider.value];
                if (weakSelf.clickDoneBlock) {
                    weakSelf.clickDoneBlock(font, color);
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
        _fontNames = FXFontManager.shareFontManager.fontNames.copy;
    }

    {
        _colors = @[@(0xFFFFFFFF), @(0xCBCBCBFF), @(0x818181FF), @(0x666666FF), @(0x353535FF), @(0x000000FF), @(0xFCE2B1FF), @(0xF6C98EFF), @(0xEF9F4CFF), @(0xE77826FF), @(0xCC681AFF), @(0x9A591CFF), @(0xF7B5C1FF), @(0xEE8CA7FF), @(0xE4556CFF), @(0xD82349FF), @(0xBD2043FF), @(0x8D2337FF), @(0xFCFB85FF), @(0xFFF73EFF), @(0xFFDB4DFF), @(0xF3AA1EFF), @(0xD48517FF), @(0x9B731BFF)];
    }

    {
        _backView = UIView.new;
        [self.view addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backView.superview);
            make.left.equalTo(_backView.superview).offset(IS_IPAD ? 20 : 16);
            make.top.equalTo(_backView.superview).offset(FXCustomSubTypeTitleView.heightOfCustomSubTypeTitleView + 30);
            make.bottom.equalTo(_backView.superview).offset(IS_IPAD ? -150 : -100);
        }];
    }

    {
        UIView *leftView = UIView.new;
        [_backView addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(leftView.superview);
            make.width.mas_equalTo(IS_IPAD ? 90 : 50);
        }];

        NSArray<NSString *> *titles = @[@"字体", @"透明度", @"颜色"];
        __block UILabel *lastLabel = nil;
        [titles enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            UILabel *label = UILabel.new;
            label.text = obj;
            label.font = [UIFont systemFontOfSize:IS_IPAD ? 18 : 12];
            label.textColor = UIColor.whiteColor;
            [leftView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.centerX.equalTo(label.superview);
                make.height.equalTo(label.superview).multipliedBy(1.0 / titles.count);
                if (lastLabel) {
                    make.top.equalTo(lastLabel.mas_bottom);
                } else {
                    make.topMargin.equalTo(label.superview);
                }
            }];

            lastLabel = label;
        }];
    }

    {
        UIView *rightView = UIView.new;
        [_backView addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(rightView.superview);
            make.left.equalTo(rightView.superview).offset(IS_IPAD ? 90 : 50);
        }];

        {
            UICollectionViewFlowLayout *collectionViewFlowLayout = UICollectionViewFlowLayout.new;
            collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            _fontCollectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
            _fontCollectionView.dataSource = self;
            _fontCollectionView.delegate = self;
            _fontCollectionView.showsHorizontalScrollIndicator = NO;
            Class cellClass = FXVideoModeifyParameterFontCollectionViewCell.class;
            [_fontCollectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
            [rightView addSubview:_fontCollectionView];
            [_fontCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(_fontCollectionView.superview);
                make.height.equalTo(_fontCollectionView.superview).multipliedBy(1.0 / 3);
            }];
        }

        {
            _slider = [UISlider new];
            _slider.minimumValue = 0.0;
            _slider.maximumValue = 1.0;
            _slider.value = 1.0;
            _slider.minimumTrackTintColor = [UIColor colorWithRGBA:0xF54184FF];
            _slider.maximumTrackTintColor = [UIColor colorWithRGBA:0x707070FF];
            [_slider addBlockForControlEvents:UIControlEventValueChanged
                                        block:^(UISlider *_Nonnull sender) {
                                            if (weakSelf.alphaChangeBlock) {
                                                weakSelf.alphaChangeBlock(sender.value);
                                            }
                                        }];
            [_slider setThumbImage:[UIImage imageNamed:@"VariableSpeedThumbImage"] forState:UIControlStateNormal];
            [rightView addSubview:_slider];
            [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(_slider.superview);
                make.width.mas_equalTo(IS_IPAD ? 300 : 167);
            }];
        }

        {
            UICollectionViewFlowLayout *collectionViewFlowLayout = UICollectionViewFlowLayout.new;
            collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            _colorCollectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
            _colorCollectionView.dataSource = self;
            _colorCollectionView.delegate = self;
            _colorCollectionView.showsHorizontalScrollIndicator = NO;
            Class cellClass = UICollectionViewCell.class;
            [_colorCollectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
            [rightView addSubview:_colorCollectionView];
            [_colorCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(_colorCollectionView.superview);
                make.height.equalTo(_fontCollectionView.superview).multipliedBy(1.0 / 3);
            }];
        }
    }

    {
        _styleButton = QMUIButton.new;
        _styleButton.spacingBetweenImageAndTitle = IS_IPAD ? 8 : 5;
        _styleButton.imagePosition = QMUIButtonImagePositionTop;
        [_styleButton setTitle:@"样式" forState:UIControlStateNormal];
        [_styleButton setImage:[UIImage imageNamed:@"字幕样式"] forState:UIControlStateNormal];
        _styleButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 12 : 12];
        _styleButton.tintColorAdjustsTitleAndImage = [UIColor colorWithRGBA:0xF54184FF];
        [_styleButton addBlockForControlEvents:UIControlEventTouchUpInside
                                         block:^(QMUIButton *_Nonnull sender) {
                                             weakSelf.styleButton.tintColorAdjustsTitleAndImage = [UIColor colorWithRGBA:0xF54184FF];
                                             weakSelf.durationButton.tintColorAdjustsTitleAndImage = UIColor.whiteColor;
            [weakSelf changeToStyleView];
                                             NSLog(@"点击样式按钮");
                                         }];
        [self.view addSubview:_styleButton];
        [_styleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_styleButton.superview).offset(IS_IPAD ? 23 : 20);
            make.bottom.equalTo(_styleButton.superview.mas_bottomMargin).offset(IS_IPAD ? -17 : -6);
        }];
    }

    {
        _durationButton = QMUIButton.new;
        _durationButton.spacingBetweenImageAndTitle = IS_IPAD ? 8 : 5;
        _durationButton.imagePosition = QMUIButtonImagePositionTop;
        [_durationButton setImage:[UIImage imageNamed:@"字幕持续时间"] forState:UIControlStateNormal];
        [_durationButton setTitle:@"持续时长" forState:UIControlStateNormal];
        _durationButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 12 : 12];
        _durationButton.tintColorAdjustsTitleAndImage = UIColor.whiteColor;
        [_durationButton addBlockForControlEvents:UIControlEventTouchUpInside
                                            block:^(QMUIButton *_Nonnull sender) {
                                                weakSelf.durationButton.tintColorAdjustsTitleAndImage = [UIColor colorWithRGBA:0xF54184FF];
                                                weakSelf.styleButton.tintColorAdjustsTitleAndImage = UIColor.whiteColor;
            [weakSelf changeToDurationEditView];
                                                NSLog(@"点击持续时长按钮");
                                            }];
        [self.view addSubview:_durationButton];
        [_durationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_styleButton.mas_right).offset(IS_IPAD ? 23 : 16);
            make.bottom.equalTo(_styleButton);
        }];
    }
}
#pragma mark -

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView == _fontCollectionView ? _fontNames.count : _colors.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _fontCollectionView) {
        FXVideoModeifyParameterFontCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(FXVideoModeifyParameterFontCollectionViewCell.class) forIndexPath:indexPath];
        cell.cellData = _fontNames[indexPath.row];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithRGBA:[_colors[indexPath.row] unsignedIntValue]];
        return cell;
    }
}
#pragma mark -

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_colorCollectionView == collectionView) {
        if (_selectColorBlock) {
            UIColor *color = [UIColor colorWithRGBA:_colors[indexPath.row].unsignedIntValue];
            color = [color colorWithAlphaComponent:_slider.value];
            _selectColorBlock(color);
        }
    }
    else if (_fontCollectionView == collectionView) {
        if (_selectFontBlock) {
            NSString *name = _fontNames[indexPath.row];
            _selectFontBlock(name);
        }
    }
}
#pragma mark -

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _fontCollectionView) {
        return CGSizeMake(IS_IPAD ? 89 : 58, IS_IPAD ? 31 : 20);
    } else {
        return CGSizeMake(IS_IPAD ? 25 : 16, IS_IPAD ? 40 : 26);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == _fontCollectionView) {
        return IS_IPAD ? 16 : 4;
    } else {
        return 0.0;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGSize size = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    return UIEdgeInsetsMake((collectionView.bounds.size.height - size.height) / 2, 0, (collectionView.bounds.size.height - size.height) / 2, 0);
}
#pragma mark -

- (void)changeToDurationEditView
{
    if (!_rollView) {
        self.rollView = [[FXVideoRollView alloc] initWithTitle:_titleDescribe];
    }
    self.rollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.rollView];
    [self.rollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(50);
        make.bottom.mas_equalTo(self.durationButton.mas_top).offset(-10);
    }];
}

- (void)changeToStyleView
{
    [self.rollView removeFromSuperview];
    self.rollView = nil;
}

@end
