//
//  FXVideoModeifyParametersViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParametersViewController.h"
#import "FXTimeLineView.h"
#import "FXVideoModeifyParameterBottomToolView.h"
#import "FXVideoModeifyParameterTypeView.h"
#import "UIView+Yoga.h"

@interface FXVideoModeifyParametersViewController () <FXTimeLineViewDelegate>

@property (nonatomic, strong) FXVideoModeifyParameterTypeView *videoModeifyParameterTypeView;

@property (nonatomic, strong) FXTimeLineView *timeLineView;

@property (nonatomic, strong) FXVideoModeifyParameterBottomToolView *bottomView;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray<UIView *> *> *bottomItmesCache;

@end

@implementation FXVideoModeifyParametersViewController

#pragma mark 对外
- (void)addPlentySourceVideoAsset:(NSArray<FXVideoItem *> *)videoItemArray {
    [_timeLineView addPlentySourceVideoAsset:videoItemArray];
}

- (void)addSourceVideoAsset:(FXVideoItem *)videoItem {
    [_timeLineView addSourceVideoAsset:videoItem];
}

- (void)addSourceVideoAsset:(FXVideoItem *)videoItem index:(NSUInteger)index {
    [_timeLineView addSourceVideoAsset:videoItem index:index];
}

- (void)addPipVideo:(FXVideoItem *)videoItem {
    [_timeLineView addPipVideo:videoItem];
}

- (void)seekToTimePercent:(double)percent {
    [_timeLineView seekToTimePercent:percent];
}

- (void)divideVideo {
    [_timeLineView divideVideo];
}

- (void)rotateVideo {
    [_timeLineView rotateVideo];
}

- (void)changeVideoRate:(CGFloat)rate {
    [_timeLineView changeVideoRate:rate];
}

- (void)removeVideo {
    [_timeLineView removeVideo];
}

- (void)undoOperation
{
    [_timeLineView undoOperation];
}

- (void)redoOperation
{
    [_timeLineView redoOperation];
}

- (void)rebuildTimelineView
{
    [_timeLineView rebuildTimelineView];
}
- (NSArray<NSIndexPath *> *)selectedIndexPaths {
    return _timeLineView.selectedIndexPaths;
}

#pragma mark -

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    {
        self.definesPresentationContext = YES;
        _bottomItmesCache = NSMutableDictionary.dictionary;
    }

    __weak typeof(self) weakSelf = self;
    {
        _videoModeifyParameterTypeView = [FXVideoModeifyParameterTypeView new];
        _videoModeifyParameterTypeView.clickButtonActionBlock = ^(FXVideoModeifyParameterTypeView *_Nonnull selfView) {
            [weakSelf p_resetBottomViewItmes];
        };
        [self.view addSubview:_videoModeifyParameterTypeView];
        [_videoModeifyParameterTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.videoModeifyParameterTypeView.superview);
            make.height.mas_equalTo(IS_IPAD ? 60 : 36);
        }];
    }

    {
        _bottomView = [FXVideoModeifyParameterBottomToolView new];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.bottomView.superview);
            make.bottom.equalTo(weakSelf.bottomView.superview.mas_bottomMargin);
            make.height.mas_equalTo(IS_IPAD ? 112 : 62);
        }];

        [self p_resetBottomViewItmes];
    }

    {
        _timeLineView = FXTimeLineView.new;
        _timeLineView.delegate = self;
        [self.view addSubview:_timeLineView];
        [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.timeLineView.superview);
            make.top.equalTo(weakSelf.videoModeifyParameterTypeView.mas_bottom);
            make.bottom.equalTo(weakSelf.bottomView.mas_top);
        }];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rebuildTimelineView) name:KNotificationRebuildTimelineView object:nil];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
#pragma mark -

#pragma mark <FXTimeLineViewDelegate>
- (void)scrollVideoWillDragInTimeLineView:(FXTimeLineView *)timeLineView {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollVideoWillDragInvideoModeifyParametersViewController:)]) {
        [_delegate scrollVideoWillDragInvideoModeifyParametersViewController:self];
    }
}

- (void)timeLineView:(FXTimeLineView *)timeLineView scrollViewDragScrollPercent:(Float64)percent {
    if (_delegate && [_delegate respondsToSelector:@selector(videoModeifyParametersViewController:scrollViewDidScrollPercent:)]) {
        [_delegate videoModeifyParametersViewController:self scrollViewDidScrollPercent:percent];
    }
}

- (void)timeLineView:(FXTimeLineView *)timeLineView clickConnectionButtonAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (_delegate && [_delegate respondsToSelector:@selector(videoModeifyParametersViewController:clickConnectionButtonAtIndexPaths:)]) {
        [_delegate videoModeifyParametersViewController:self clickConnectionButtonAtIndexPaths:indexPaths];
    }
}

- (void)timeLineView:(FXTimeLineView *)timeLineView clickBeginButtonAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(videoModeifyParametersViewController:clickConnectionButtonAtIndexPaths:)]) {
        [_delegate videoModeifyParametersViewController:self clickBeginButtonAtIndexPath:indexPath];
    }
}

- (void)timeLineView:(FXTimeLineView *)timeLineView clickEndButtonAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(videoModeifyParametersViewController:clickConnectionButtonAtIndexPaths:)]) {
        [_delegate videoModeifyParametersViewController:self clickEndButtonAtIndexPath:indexPath];
    }
}
#pragma mark -

#pragma mark 逻辑
- (void)p_resetBottomViewItmes {
    [_bottomView setItmes:[self p_itmesForType:_videoModeifyParameterTypeView.type]];
}

- (NSArray<UIView *> *)p_itmesForType:(FXVideoModeifyParameterType)type {
    NSArray<UIView *> *itmes = _bottomItmesCache[@(type)];
    if (!itmes) {
        NSMutableArray<QMUIButton *> *result = NSMutableArray.new;
        NSArray<NSNumber *> *tags;
        if (type == FXVideoModeifyParameterEditType) {
            tags = @[@(FXVideoModeifyParameterCropSubType), @(FXVideoModeifyParameterSortSubType), @(FXVideoModeifyParameterSpliteSubType), @(FXVideoModeifyParameterRotationSubType), @(FXVideoModeifyParameterVariableSpeedSubType), @(FXVideoModeifyParameterDeleteSubType)];
        } else if (type == FXVideoModeifyParameterSpecialEffectsType) {
            tags = @[@(FXVideoModeifyParameterPictureInPictureSubType), @(FXVideoModeifyParameterFilterSubType), @(FXVideoModeifyParameterEditSubType), @(FXVideoModeifyParameterDeleteSubType)];
        } else if (type == FXVideoModeifyParameterAudioType) {
            tags = @[@(FXVideoModeifyParameterSoundtrackSubType), @(FXVideoModeifyParameterDubbingSubType), @(FXVideoModeifyParameterEditSubType), @(FXVideoModeifyParameterDeleteSubType)];
        } else if (type == FXVideoModeifyParameterSubtitleType) {
            tags = @[@(FXVideoModeifyParameterPlaceholderSubType), @(FXVideoModeifyParameterSubtitleSubType), @(FXVideoModeifyParameterEditSubType), @(FXVideoModeifyParameterDeleteSubType)];
        } else {
            tags = @[];
        }

        [tags enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            QMUIButton *button = QMUIButton.new;
            button.tag = obj.integerValue;
            [result addObject:button];
        }];

        NSDictionary<NSNumber *, NSString *> *titles = @{
            @(FXVideoModeifyParameterPlaceholderSubType): @"占位",
            @(FXVideoModeifyParameterCropSubType): @"裁剪",
            @(FXVideoModeifyParameterSortSubType): @"排序",
            @(FXVideoModeifyParameterSpliteSubType): @"分割",
            @(FXVideoModeifyParameterRotationSubType): @"旋转",
            @(FXVideoModeifyParameterVariableSpeedSubType): @"变速",
            @(FXVideoModeifyParameterDeleteSubType): @"删除",
            @(FXVideoModeifyParameterPictureInPictureSubType): @"画中画",
            @(FXVideoModeifyParameterFilterSubType): @"滤镜",
            @(FXVideoModeifyParameterEditSubType): @"编辑",
            @(FXVideoModeifyParameterSoundtrackSubType): @"配乐",
            @(FXVideoModeifyParameterDubbingSubType): @"配音",
            @(FXVideoModeifyParameterSubtitleSubType): @"字幕",
        };

        NSDictionary<NSNumber *, NSString *> *imageNames = @{
            @(FXVideoModeifyParameterPlaceholderSubType): @"占位",
            @(FXVideoModeifyParameterCropSubType): @"裁剪",
            @(FXVideoModeifyParameterSortSubType): @"排序",
            @(FXVideoModeifyParameterSpliteSubType): @"分割",
            @(FXVideoModeifyParameterRotationSubType): @"旋转",
            @(FXVideoModeifyParameterVariableSpeedSubType): @"变速",
            @(FXVideoModeifyParameterDeleteSubType): @"删除",
            @(FXVideoModeifyParameterPictureInPictureSubType): @"画中画",
            @(FXVideoModeifyParameterFilterSubType): @"滤镜",
            @(FXVideoModeifyParameterEditSubType): @"编辑",
            @(FXVideoModeifyParameterSoundtrackSubType): @"配乐",
            @(FXVideoModeifyParameterDubbingSubType): @"配音",
            @(FXVideoModeifyParameterSubtitleSubType): @"字幕-2",
        };

        __weak typeof(self) weakSelf = self;
        [result enumerateObjectsUsingBlock:^(QMUIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.hidden = obj.tag == FXVideoModeifyParameterPlaceholderSubType;
            [obj setTitle:titles[@(obj.tag)] forState:UIControlStateNormal];
            UIImage *image = [UIImage imageNamed:imageNames[@(obj.tag)]];
            [obj setImage:image forState:UIControlStateNormal];
            obj.imagePosition = QMUIButtonImagePositionTop;
            obj.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 12 : 8];
            [obj setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            obj.spacingBetweenImageAndTitle = IS_IPAD ? 8 : 4;
            [obj addBlockForControlEvents:UIControlEventTouchUpInside
                                    block:^(UIButton *_Nonnull sender) {
                                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoModeifyParametersViewController:clickButtonWithType:subType:)]) {
                                            [weakSelf.delegate videoModeifyParametersViewController:weakSelf clickButtonWithType:type subType:sender.tag];
                                        }
                                    }];

            [obj configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                layout.isEnabled = YES;
                layout.height = YGPercentValue(100);
                layout.width = YGPercentValue(100.0 / 6.0);
            }];
        }];

        NSMutableArray<UIView *> *temp = result.mutableCopy;
        if (type != FXVideoModeifyParameterEditType) {
            UIView *lineView = UIView.new;
            lineView.backgroundColor = [UIColor colorWithRGBA:0x999DA4FF];
            [lineView configureLayoutWithBlock:^(YGLayout *_Nonnull layout) {
                layout.isEnabled = YES;
                layout.height = YGPointValue(IS_IPAD ? 40 : 30);
                layout.width = YGPointValue(1);
            }];

            [temp insertObject:lineView atIndex:temp.count / 2];
        }
        itmes = temp.copy;
        _bottomItmesCache[@(type)] = itmes;
    }
    return itmes;
}
#pragma mark -

@end
