//
//  FXVideoModeifyParameterCropSubTypeViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/11.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterCropSubTypeViewController.h"
#import "FXCustomSubTypeTitleView.h"
#import "FXNVideoTrimView.h"
#import "FXNormalCropMaskView.h"
#import "FXVideoDescribe.h"
#import "FXTimelineItemViewModel.h"
#import "FXTimelineManager.h"
#import "FXTimeRulerView.h"

@interface FXVideoModeifyParameterCropSubTypeViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *normalCropView;

@property (nonatomic, strong) UIView *advancedCropView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) QMUIButton *normalButton;

@property (nonatomic, strong) QMUIButton *advancedButton;

@property (nonatomic, strong) QMUIButton *selectedButton;

@property (nonatomic, strong) FXNormalCropMaskView *normalCropMaskView;

@property (nonatomic, strong) FXVideoDescribe *videoDescribe;

@property (nonatomic, strong) FXNVideoTrimView *normalVideoTrimView;

@property (nonatomic, strong) FXNVideoTrimView *advanceVideoTrimView;

@property (nonatomic, strong) FXTimeRulerView *rulerView;

@property (nonatomic, strong) UIView *coverView;

@end

@implementation FXVideoModeifyParameterCropSubTypeViewController

#pragma mark 对外
+ (FXVideoModeifyParameterCropSubTypeViewController *)videoModeifyParameterCropSubTypeViewControllerWithVideoDescribe:(FXVideoDescribe *)videoDescribe {
    FXVideoModeifyParameterCropSubTypeViewController *controller = FXVideoModeifyParameterCropSubTypeViewController.new;
    controller.videoDescribe = videoDescribe;
    return controller;
}
#pragma mark -

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    {
        FXCustomSubTypeTitleView *topView = FXCustomSubTypeTitleView.new;
        topView.title = @"裁剪";
        topView.closeButtonActionBlock = ^{
            if (weakSelf.doneBlock) {
                weakSelf.doneBlock(0,0);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

        topView.doneButtonActionBlock = ^{
            if (weakSelf.selectedButton == weakSelf.normalButton) {
                if (weakSelf.doneBlock) {
                    weakSelf.doneBlock(weakSelf.normalCropMaskView.left / weakSelf.normalVideoTrimView.bounds.size.width, weakSelf.normalCropMaskView.right / weakSelf.normalVideoTrimView.bounds.size.width);
                }
            } else {
                if (weakSelf.doneBlock) {
                    weakSelf.doneBlock(0, 0);
                }
                NSLog(@"点击高级裁剪确认按钮");
            }
        };
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(topView.superview);
            make.height.mas_equalTo(FXCustomSubTypeTitleView.heightOfCustomSubTypeTitleView);
        }];
    }

    {
        _advancedCropView = UIView.new;
        _advancedCropView.hidden = YES;
        _advancedCropView.backgroundColor = UIColor.clearColor;
        [self.view addSubview:_advancedCropView];
        [_advancedCropView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_advancedCropView.superview);
            make.top.equalTo(_advancedCropView.superview).offset(FXCustomSubTypeTitleView.heightOfCustomSubTypeTitleView);
            make.bottom.equalTo(_advancedCropView.superview).offset(-120);
        }];
    }

    {
        _normalCropView = UIView.new;
        [self.view addSubview:_normalCropView];
        [_normalCropView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_advancedCropView);
        }];

        _normalVideoTrimView = FXNVideoTrimView.new;
        FXVideoItem *item = _videoDescribe.videoItem;
        [_normalVideoTrimView setDelegate:item timeRange:_videoDescribe.sourceRange];
        [_normalCropView addSubview:_normalVideoTrimView];
        [_normalVideoTrimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_normalVideoTrimView.superview);
            make.width.equalTo(_normalVideoTrimView.superview).offset(IS_IPAD ? -86 : -86);
            make.height.mas_equalTo(IS_IPAD ? 56 : 56);
        }];

        _normalCropMaskView = FXNormalCropMaskView.new;
        [_normalCropView addSubview:_normalCropMaskView];
        [_normalCropMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_normalVideoTrimView).insets(UIEdgeInsetsMake(_normalCropMaskView.edgeInsets.top * -1, _normalCropMaskView.edgeInsets.left * -1, _normalCropMaskView.edgeInsets.bottom * -1, _normalCropMaskView.edgeInsets.right * -1));
        }];
        _normalCropMaskView.MoveBlock = ^(CGFloat percent) {
            if (weakSelf.MoveBlock) {
                weakSelf.MoveBlock(percent);
            }
        };
    }

    {
        _normalButton = QMUIButton.new;
        _normalButton.adjustsTitleTintColorAutomatically = YES;
        _normalButton.tintColor = UIColor.whiteColor;
        [_normalButton setTitle:@"普通" forState:UIControlStateNormal];
        _normalButton.imagePosition = QMUIButtonImagePositionBottom;
        [_normalButton setImage:[[UIImage imageNamed:@"CropIndexButton"] sd_tintedImageWithColor:UIColor.blackColor] forState:UIControlStateNormal];
        _normalButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 18 : 12];
        [_normalButton addBlockForControlEvents:UIControlEventTouchUpInside
                                          block:^(QMUIButton *_Nonnull sender) {
                                              weakSelf.selectedButton = sender;
                                              weakSelf.normalCropView.hidden = NO;
                                              weakSelf.advancedCropView.hidden = YES;
            [weakSelf.advancedCropView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                          }];

        [self.view addSubview:_normalButton];
        [_normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_normalButton.superview).offset(IS_IPAD ? 20 : 16);
            make.centerY.equalTo(_normalButton.superview.mas_bottomMargin).offset(IS_IPAD ? -50 : -40);
        }];
    }

    {
        _advancedButton = QMUIButton.new;
        _advancedButton.adjustsTitleTintColorAutomatically = YES;
        _advancedButton.tintColor = UIColor.whiteColor;
        [_advancedButton setTitle:@"高级" forState:UIControlStateNormal];
        _advancedButton.imagePosition = QMUIButtonImagePositionBottom;
        [_advancedButton setImage:[[UIImage imageNamed:@"CropIndexButton"] sd_tintedImageWithColor:UIColor.blackColor] forState:UIControlStateNormal];
        _advancedButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 18 : 12];
        [_advancedButton addBlockForControlEvents:UIControlEventTouchUpInside
                                            block:^(QMUIButton *_Nonnull sender) {
                                                weakSelf.selectedButton = sender;
                                                weakSelf.normalCropView.hidden = YES;
                                                weakSelf.advancedCropView.hidden = NO;
            [weakSelf configAdvanceCropView];
                                            }];
        [self.view addSubview:_advancedButton];
        [_advancedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_normalButton.mas_right).offset(IS_IPAD ? 24 : 16);
            make.centerY.equalTo(_normalButton);
        }];
    }

    {
        //tiem:8 iPhone 16:iPad
    }

    {
        self.selectedButton = _normalButton;
    }
}
#pragma mark -

#pragma mark setter
- (void)setSelectedButton:(QMUIButton *)selectedButton {
    _selectedButton.tintColor = UIColor.whiteColor;
    [_selectedButton setImage:[[UIImage imageNamed:@"CropIndexButton"] sd_tintedImageWithColor:UIColor.blackColor] forState:UIControlStateNormal];
    _selectedButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 18 : 12];
    _selectedButton = selectedButton;
    _selectedButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 24 : 14];
    _selectedButton.tintColor = [UIColor colorWithRGBA:0xF54184FF];
    [_selectedButton setImage:[[UIImage imageNamed:@"CropIndexButton"] sd_tintedImageWithColor:[UIColor colorWithRGBA:0xF54184FF]] forState:UIControlStateNormal];
}
#pragma mark -

- (void)configAdvanceCropView
{
       _scrollView = [[UIScrollView alloc] init];
       _scrollView.delegate = self;
       _scrollView.showsVerticalScrollIndicator = NO;
       _scrollView.contentSize = CGSizeMake(kScreenWidth, 140);
       [self.advancedCropView addSubview:_scrollView];
       [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.left.right.mas_equalTo(self.advancedCropView);
           make.height.mas_equalTo(140);
           make.centerY.mas_equalTo(self.advancedCropView.mas_centerY);
       }];
       FXTimelineItemViewModel *model = [[FXTimelineItemViewModel alloc] initWithDescribe:_videoDescribe widthScale:120];
       model.trackType = FXTrackTypeVideo;
       CGFloat width = kScreenWidth;
       CGFloat startOffset = kScreenWidth/2;
    
       FXVideoItem *item = _videoDescribe.videoItem;
       _advanceVideoTrimView = [FXNVideoTrimView.alloc initWithFrame:CGRectMake(startOffset + model.positionInTimeline,40, model.widthInTimeline, 60)];
       [_advanceVideoTrimView setDelegate:item timeRange:_videoDescribe.sourceRange];
       [_scrollView addSubview:_advanceVideoTrimView];
       width+=model.widthInTimeline;
    
       _scrollView.contentSize = CGSizeMake(width, 140);
       
       UIView *lineView = UIView.new;
       lineView.backgroundColor = UIColor.whiteColor;
     [self.advancedCropView addSubview:lineView];
       [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(self.advancedCropView).offset(20);
           make.width.mas_equalTo(1);
           make.centerX.mas_equalTo(self.advancedCropView.mas_centerX);
           make.bottom.mas_equalTo(self.advancedCropView).offset(-20);
       }];
    _coverView = UIView.new;
    _coverView.layer.borderColor = [UIColor redColor].CGColor;
    _coverView.layer.borderWidth = 1.0;
    _coverView.layer.masksToBounds = YES;
    _coverView.backgroundColor = [UIColor clearColor];
    [_advanceVideoTrimView addSubview:_coverView];
    _coverView.frame = _advanceVideoTrimView.bounds;
    [_coverView setNeedsDisplay];
    CGRect rect = _advanceVideoTrimView.frame;
    rect.origin.y = 0;
    rect.size.height = 15;
    _rulerView = [[FXTimeRulerView alloc] initWithFrame:rect widthPerSecond:120 themeColor:UIColor.whiteColor totalTime:CMTimeGetSeconds(_videoDescribe.duration)];
    [self.scrollView addSubview:_rulerView];
    
    [self addMoveButton];
}


- (void)addMoveButton
{
       _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
       _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [_leftButton setImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
       [_rightButton setImage:[UIImage imageNamed:@"椭圆"] forState:UIControlStateNormal];
       [_scrollView addSubview:_leftButton];
       [_scrollView addSubview:_rightButton];
     _leftButton.frame = CGRectMake(CGRectGetMinX(_advanceVideoTrimView.frame) - 10, CGRectGetMinY(_advanceVideoTrimView.frame) + CGRectGetHeight(_advanceVideoTrimView.frame)/2 - 10, 20, 20);
     _rightButton.frame = CGRectMake(CGRectGetMaxX(_advanceVideoTrimView.frame) + 10, CGRectGetMinY(_advanceVideoTrimView.frame) + CGRectGetHeight(_advanceVideoTrimView.frame)/2 - 10, 20, 20);
       __weak typeof(self) weakSelf = self;
       UIPanGestureRecognizer *panGestureRecognizer = [UIPanGestureRecognizer.alloc initWithActionBlock:^(UIPanGestureRecognizer *_Nonnull sender) {
           CGPoint point = [sender locationInView:weakSelf.scrollView];
           CGFloat start = point.x;
           CGRect buttonleft = weakSelf.leftButton.frame;
           buttonleft.origin.x = start;
           weakSelf.leftButton.frame = buttonleft;
           
           CGFloat width = weakSelf.rightButton.origin.x - weakSelf.leftButton.origin.x;
           
           CGPoint realPoint = [weakSelf.scrollView convertPoint:weakSelf.leftButton.origin toView:weakSelf.advanceVideoTrimView];
           CGRect updateRect = CGRectMake(realPoint.x + 10, CGRectGetMinY(weakSelf.coverView.frame), width, CGRectGetHeight(weakSelf.coverView.frame));
           weakSelf.coverView.frame = updateRect;
           [weakSelf.view layoutIfNeeded];
           if (weakSelf.MoveBlock) {
               weakSelf.MoveBlock(realPoint.x/width);
           }
       }];
       [_leftButton addGestureRecognizer:panGestureRecognizer];
       
       UIPanGestureRecognizer *rightPanGestureRecognizer = [UIPanGestureRecognizer.alloc initWithActionBlock:^(UIPanGestureRecognizer *_Nonnull sender) {
           CGPoint point = [sender locationInView:weakSelf.scrollView];
           CGFloat start = point.x;
           CGRect buttonRight = weakSelf.rightButton.frame;
           buttonRight.origin.x = start;
           weakSelf.rightButton.frame = buttonRight;
           
           CGFloat width = weakSelf.rightButton.origin.x - weakSelf.leftButton.origin.x;
           CGPoint realPoint = [weakSelf.scrollView convertPoint:weakSelf.leftButton.origin toView:weakSelf.advanceVideoTrimView];

           CGRect updateRect = CGRectMake(realPoint.x + 10, CGRectGetMinY(weakSelf.coverView.frame), width, CGRectGetHeight(weakSelf.coverView.frame));
           weakSelf.coverView.frame = updateRect;
           [weakSelf.view layoutIfNeeded];
           if (weakSelf.MoveBlock) {
               weakSelf.MoveBlock(realPoint.x/width);
           }
       }];
       [_rightButton addGestureRecognizer:rightPanGestureRecognizer];
}

@end
