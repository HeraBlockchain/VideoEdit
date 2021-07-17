//
//  FXVideoEditViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/2.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoEditViewController.h"
#import "FXAlertController.h"
#import "FXAudioSelectListViewController.h"
#import "FXMainComposition.h"
#import "FXMainCompositionBuilder.h"
#import "FXPictureSizeChangeViewController.h"
#import "FXPlayerViewController.h"
#import "FXTimelineManager.h"
#import "FXVideoControl.h"
#import "FXVideoItem.h"
#import "FXVideoModeifyParameterChooseTransitionSubTypeViewController.h"
#import "FXVideoModeifyParameterCropSubTypeViewController.h"
#import "FXVideoModeifyParameterFilterSubTypeViewController.h"
#import "FXVideoModeifyParameterSortSubTypeViewController.h"
#import "FXVideoModeifyParameterSubtitleSubTypeViewController.h"
#import "FXVideoModeifyParameterTransitionSubTypeViewController.h"
#import "FXVideoModeifyParameterVariableSpeedSubTypeViewController.h"
#import "FXVideoModeifyParametersViewController.h"
#import "FXVideoSelectViewController.h"
#import "FXVolumeChangeViewController.h"
#import "FXAudioRecordViewController.h"
#import "FXTitleInputView.h"
#import "FXTimelineItemViewModel.h"
#import "FXTitleDescribe.h"
#import "FXVideoPreviewViewController.h"
#import "FXPreviewComposition.h"


@interface FXVideoEditViewController () <FXPlayerViewControllerDelegate, FXVideoModeifyParametersViewControllerDelegate, FXVideoPreviewViewControllerDelegate>

@property (nonatomic, strong) FXPlayerViewController *playerViewController;

@property (nonatomic, strong) FXVideoControl *videoControl;

@property (nonatomic, strong) FXVideoModeifyParametersViewController *videoModeifyParametersViewController;

@property (nonatomic, strong) NSArray<AVAsset *> *avassets;

@property (nonatomic, assign) Float64 currentPercent;

@property (nonatomic, strong) UIButton *volumeButton;

@property (nonatomic, strong) UIButton *pictureSizeButton;

@property (nonatomic, strong) FXTimelineManager *timelineManager;

@property (nonatomic, strong) NSIndexPath *operateIndex;

@property (nonatomic, strong) FXTitleDescribe *selectedTitleDescribe;

@property (nonatomic, strong) CADisplayLink* dlink;

@property (nonatomic, strong) AVAssetExportSession *exporter;


//preview
@property (nonatomic, strong) FXVideoPreviewViewController *previewController;

@end

@implementation FXVideoEditViewController

#pragma mark 对外
+ (FXVideoEditViewController *)videoEditViewControllerWithAVAssets:(NSArray<AVAsset *> *)avassets {
    FXVideoEditViewController *controller = FXVideoEditViewController.new;
    controller.avassets = avassets.copy;
    return controller;
}
#pragma mark -

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;

    {
        _timelineManager = FXTimelineManager.sharedInstance;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    {
        _playerViewController = FXPlayerViewController.new;
        _playerViewController.delegate = self;
        [self addChildViewController:_playerViewController];
        [self.view addSubview:_playerViewController.view];
        [_playerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            UIView *superview = weakSelf.playerViewController.view.superview;
            make.left.right.equalTo(superview);
            make.top.equalTo(superview.mas_topMargin);
            make.bottom.equalTo(superview.mas_centerY);
        }];
        [_playerViewController didMoveToParentViewController:self];
    }

    {
        _volumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_volumeButton addBlockForControlEvents:UIControlEventTouchUpInside
                                          block:^(id _Nonnull sender) {
                                              [weakSelf p_showPopViewControllerForChangeVolume];
                                          }];
        [_volumeButton setImage:[UIImage imageNamed:@"音量"] forState:UIControlStateNormal];
        [self.view insertSubview:_volumeButton aboveSubview:_playerViewController.view];
        [_volumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.volumeButton.superview).offset(IS_IPAD ? 20 : 16);
            make.bottom.equalTo(weakSelf.playerViewController.view).offset(IS_IPAD ? -16 : -8);
        }];
    }

    {
        _pictureSizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pictureSizeButton addBlockForControlEvents:UIControlEventTouchUpInside
                                               block:^(id _Nonnull sender) {
                                                   [weakSelf p_showPopViewControllerForChangePictureSize];
                                               }];
        [_pictureSizeButton setImage:[UIImage imageNamed:@"画幅"] forState:UIControlStateNormal];
        [self.view insertSubview:_pictureSizeButton aboveSubview:_playerViewController.view];
        [_pictureSizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.pictureSizeButton.superview).offset(IS_IPAD ? -20 : -16);
            make.centerY.equalTo(weakSelf.volumeButton);
        }];
    }

    {
        _videoControl = FXVideoControl.new;
        _videoControl.centerButtonActionBlock = ^(FXVideoControl *_Nonnull control) {
            [weakSelf.playerViewController play];
            NSLog(@"点击了播放按钮");
        };
        _videoControl.undoButtonActionBlock = ^(FXVideoControl *_Nonnull control) {
            [weakSelf.videoModeifyParametersViewController undoOperation];
            NSLog(@"点击了撤销按钮");
        };
        _videoControl.redoButtonActionBlock = ^(FXVideoControl *_Nonnull control) {
            [weakSelf.videoModeifyParametersViewController redoOperation];
            NSLog(@"点击了重做按钮");
        };
        [self.view addSubview:_videoControl];
        [_videoControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.videoControl.superview);
            make.top.equalTo(weakSelf.playerViewController.view.mas_bottom);
            make.height.mas_equalTo(IS_IPAD ? 57 : 33);
        }];
    }

    {
        _videoModeifyParametersViewController = FXVideoModeifyParametersViewController.new;
        _videoModeifyParametersViewController.delegate = self;
        [self addChildViewController:_videoModeifyParametersViewController];
        [self.view addSubview:_videoModeifyParametersViewController.view];
        [_videoModeifyParametersViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            UIView *superview = weakSelf.videoModeifyParametersViewController.view.superview;
            make.left.right.equalTo(superview);
            make.top.equalTo(weakSelf.videoControl.mas_bottom);
            make.bottom.equalTo(superview.mas_bottomMargin);
        }];
        [_videoModeifyParametersViewController didMoveToParentViewController:self];
    }

    {
        UIBarButtonItem *exportitem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(p_exportVideo)];
        self.navigationItem.rightBarButtonItem = exportitem;
    }

    {
        [self p_loadoriginalVideos];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rebuildTimelineView) name:KNotificationRebuildTimelineView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleEditNotification:) name:KNotificationTitleLabelEdit object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleViewSelectNotification:) name:KNotificationTitleCoverViewSelected object:nil];
}
#pragma mark -

- (void)rebuildTimelineView
{
    [self.videoModeifyParametersViewController rebuildTimelineView];
    [self p_refreshEditOperationButtonState];
    [self p_prepareTimelineForPlayback];
}

- (void)titleEditNotification:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    FXTitleInputView *titleInputView = dic[@"EditTitle"];
    [self.view addSubview:titleInputView];
    [titleInputView inputViewShow];
}

- (void)titleViewSelectNotification:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    FXTimeLineTitleModel *titleModel = dic[@"titleModel"];
    FXTitleDescribe *titleDescribe = titleModel.titleDescribe;
    CMTime centerTime = CMTimeAdd(titleDescribe.startTime, CMTimeMultiplyByFloat64(titleDescribe.duration, 0.5));
    Float64 current = CMTimeGetSeconds(centerTime);
    CGFloat centerPercent = current/CMTimeGetSeconds(_timelineManager.timelineDescribe.duration);
    _currentPercent = centerPercent;
    [_videoModeifyParametersViewController seekToTimePercent:_currentPercent];
    [_playerViewController seekVideoToPercent:_currentPercent];
    [self p_countShowTime];
    _selectedTitleDescribe = titleDescribe;
}

#pragma mark -
- (void)dealloc {
    [_playerViewController stopPlayback];
    [_timelineManager clearAllData];
}
#pragma mark -

#pragma mark <FXPlayerViewControllerDelegate>
- (void)videoPlayToTime:(Float64)currentPercent {
    _currentPercent = currentPercent;
    [_videoModeifyParametersViewController seekToTimePercent:currentPercent];
    [self p_countShowTime];
}
#pragma mark -

#pragma mark 加载视频逻辑
- (void)p_loadoriginalVideos {
    __block NSInteger count = 0;
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray *tempArray = [NSMutableArray new];
    [SVProgressHUD showProgress:0 status:@"加载中"];
    for (int i = 0; i < _avassets.count; i++) {
        AVAsset *avasset = [_avassets objectOrNilAtIndex:i];
        if (avasset) {
            FXVideoItem *videoItem = [FXVideoItem.alloc initWithAvAsset:avasset];
            [videoItem prepareWithCompletionBlock:^(BOOL complete) {
                count++;
                [SVProgressHUD showProgress:(float)count/weakSelf.avassets.count status:@"加载中"];
                [tempArray addObject:videoItem];
                if (count == weakSelf.avassets.count) {
                    [SVProgressHUD dismiss];
                    //加载完成
                    [weakSelf.videoModeifyParametersViewController addPlentySourceVideoAsset:tempArray];
                    [weakSelf p_refreshEditOperationButtonState];
                    [weakSelf p_prepareTimelineForPlayback];
                }
            }];
        }
    }
}

- (void)p_refreshEditOperationButtonState {
    _videoControl.undoButtonEnabled = _timelineManager.canundo;
    _videoControl.redoButtonEnabled = _timelineManager.canRedo;
}

- (void)p_prepareTimelineForPlayback {
    FXTimelineDescribe *timeline = _timelineManager.timelineDescribe;
    FXMainCompositionBuilder *builder = [[FXMainCompositionBuilder alloc] initWithTimeline:timeline];
    [_playerViewController changeMainComposition:[builder buildComposition]];

    __weak typeof(self) weakSelf = self;
    [_playerViewController.mainComposition.composition loadValuesAsynchronouslyForKeys:@[@"duration"]
                                                                     completionHandler:^{
                                                                         [weakSelf p_countShowTime];
                                                                     }];
}

- (void)p_countShowTime {
    CMTime duration = _playerViewController.mainComposition.composition.duration;
    Float64 seconds = CMTimeGetSeconds(duration);
    [_videoControl setDuration:MAX(0, seconds * _currentPercent) totalDuration:seconds];
}

- (void)p_showPopViewControllerForChangeVolume {
    FXVolumeChangeViewController *viewController = FXVolumeChangeViewController.new;
    viewController.volumeChangeBlock = ^(FXVolumeChangeType type, CGFloat volume) {
        if (type == FXMainVolumeChangeType) {
            [[FXTimelineManager sharedInstance] setAudioVolume:volume];
        } else if (type == FXPIPVolumeChangeType) {
            [[FXTimelineManager sharedInstance] setPipAudioVolume:volume];
        }
        NSLog(@"%@的音量修改成:%@", @(type), @(volume));
    };
    viewController.preferredContentSize = CGSizeMake(IS_IPAD ? 500 : self.view.bounds.size.width * 0.8, IS_IPAD ? 215 : 140);
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    viewController.popoverPresentationController.delegate = viewController;
    viewController.popoverPresentationController.sourceView = self.view;
    viewController.popoverPresentationController.sourceRect = [_volumeButton convertRect:_volumeButton.bounds toView:self.view];
    viewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    viewController.popoverPresentationController.canOverlapSourceViewRect = YES;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)p_showPopViewControllerForChangePictureSize {
    FXPictureSizeChangeViewController *viewController = FXPictureSizeChangeViewController.new;
    viewController.choosePictureSizeBlock = ^(FXPictureSize pictureSize) {
        [[FXTimelineManager sharedInstance] setVideoPictureSize:pictureSize];
        [[FXTimelineManager sharedInstance] saveHistoryData];
        [self p_prepareTimelineForPlayback];
        NSLog(@"选中画幅:%@", @(pictureSize));
    };
    viewController.preferredContentSize = CGSizeMake(IS_IPAD ? self.view.bounds.size.width * 0.5 : self.view.bounds.size.width * 0.9, IS_IPAD ? 100 : 80);
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    viewController.popoverPresentationController.delegate = viewController;
    viewController.popoverPresentationController.sourceView = self.view;
    viewController.popoverPresentationController.sourceRect = [_pictureSizeButton convertRect:_pictureSizeButton.bounds toView:self.view];
    viewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    viewController.popoverPresentationController.canOverlapSourceViewRect = YES;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)p_addPipVideo:(AVAsset *)asset {
    FXVideoItem *videoItem = [FXVideoItem.alloc initWithAvAsset:asset];
    __weak typeof(self) weakSelf = self;
    [videoItem prepareWithCompletionBlock:^(BOOL complete) {
        [weakSelf.videoModeifyParametersViewController addPipVideo:videoItem];
        [weakSelf p_refreshEditOperationButtonState];
        [weakSelf p_prepareTimelineForPlayback];
    }];
}

- (void)p_exportVideo {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    FXTimelineDescribe *timeline = _timelineManager.timelineDescribe;
    FXMainCompositionBuilder *builder = [[FXMainCompositionBuilder alloc] initWithTimeline:timeline];
    FXMainComposition *mainComposition = [builder buildCompositionForExport];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:
                                             [NSString stringWithFormat:@"FinalVideo-%d.mp4", arc4random() % 10000000]];
    _exporter = [mainComposition makeExportable];
    _exporter.outputURL = [NSURL fileURLWithPath:path];
    [self startProgress];
    [_exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        });
        NSLog(@"progress:%.02f", _exporter.progress);
        switch (_exporter.status) {
            case AVAssetExportSessionStatusCompleted:
                [self p_saveVideoToAlbum:[NSURL fileURLWithPath:path]];
                NSLog(@"complete");
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"%@", _exporter.error);
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"progress:%.02f", _exporter.progress);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"cancel");
                break;
            default:
                break;
        }
    }];
}

- (void)p_saveVideoToAlbum:(NSURL *)url {
    [[PHPhotoLibrary sharedPhotoLibrary]
        performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
        }
        completionHandler:^(BOOL success, NSError *_Nullable error) {
            if (success) {
                NSLog(@"save success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"success"
                                                                    message:@"Video Save success"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                });
            } else {
                NSLog(@"%@", error);
            }
        }];
}

- (void)p_showAlertControllerForDeleteSubType {
    __weak typeof(self) weakSelf = self;
    FXAlertController *alertController = [FXAlertController alertControllerWithTitle:@"提示"
        message:@"是否删除视频？"
        leftButtonTitle:@"取消"
        leftButtonActionBlock:^(FXAlertController *_Nonnull alertController) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }
        rightButtonTitle:@"确定"
        rightButtonActionBlock:^(FXAlertController *_Nonnull alertController) {
            [alertController dismissViewControllerAnimated:YES
                                                completion:^{
                                                    NSLog(@"点击了放弃视频编辑");
                                                    [weakSelf.videoModeifyParametersViewController removeVideo];
                                                    [weakSelf p_refreshEditOperationButtonState];
                                                    [weakSelf p_prepareTimelineForPlayback];
                                                }];
        }];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)p_addNewVideoAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    NSLog(@"index=%@", @(indexPath.row));
    FXVideoSelectViewController *controller = [FXVideoSelectViewController videoSelectViewControllerWithAllowMaxSelectedNumber:1
                                                                                                                     nextBlock:^(NSArray<AVAsset *> *_Nonnull avassets) {
                                                                                                                         [weakSelf dismissViewControllerAnimated:YES
                                                                                                                                                      completion:^{
                                                                                                                                                          FXVideoItem *videoItem = [FXVideoItem.alloc initWithAvAsset:avassets.firstObject];
                                                                                                                                                          [videoItem prepareWithCompletionBlock:^(BOOL complete) {
                                                                                                                                                              [weakSelf.videoModeifyParametersViewController addSourceVideoAsset:videoItem index:indexPath.row];
                                                                                                                                                              [weakSelf p_refreshEditOperationButtonState];
                                                                                                                                                              [weakSelf p_prepareTimelineForPlayback];
                                                                                                                                                          }];
                                                                                                                                                      }];
                                                                                                                     }];
    [self presentViewController:[UINavigationController.alloc initWithRootViewController:controller] animated:YES completion:nil];
}

- (void)p_addTransitionVideoBeginIndexPath:(NSIndexPath *)beginIndexPath endIndexPath:(NSIndexPath *)endIndexPath {
    FXVideoModeifyParameterTransitionSubTypeViewController *controller = FXVideoModeifyParameterTransitionSubTypeViewController.new;
    __weak typeof(self) weakSelf = self;
    controller.transitionSelectedBlock = ^(FXTransType transType) {
        [weakSelf.videoModeifyParametersViewController dismissViewControllerAnimated:YES
                                                                          completion:^{
                                                                              NSLog(@"转场类型:%@", @(transType));
            [weakSelf.timelineManager changeTransitionItemPreIndex:beginIndexPath.row backIndex:endIndexPath.row duration:CMTimeMake(1200, 6000) transType:transType];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRebuildTimelineView object:nil];
            [weakSelf p_refreshEditOperationButtonState];
            [weakSelf p_prepareTimelineForPlayback];
                                                                          }];
    };

    [_videoModeifyParametersViewController presentViewController:controller animated:YES completion:nil];
}

#pragma mark -

#pragma mark <FXVideoModeifyParametersViewController>
- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController scrollViewDidScrollPercent:(Float64)percent {
    if (_playerViewController.isPlaying) {
        return;
    }
    _currentPercent = percent;
    [_playerViewController seekVideoToPercent:percent];
    [self p_countShowTime];
}

- (void)scrollVideoWillDragInvideoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController {
    [_playerViewController stopPlayback];
}

- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController clickConnectionButtonAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths {
    if (indexPaths.count == 2) {
        __weak typeof(self) weakSelf = self;
        FXVideoModeifyParameterChooseTransitionSubTypeViewController *controller = FXVideoModeifyParameterChooseTransitionSubTypeViewController.new;
        controller.addNewVideoBlock = ^{
            [weakSelf.videoModeifyParametersViewController dismissViewControllerAnimated:YES
                                                                              completion:^{
                                                                                  [weakSelf p_addNewVideoAtIndexPath:indexPaths.lastObject];
                                                                              }];
        };
        controller.addTransitionBlock = ^{
            [weakSelf.videoModeifyParametersViewController dismissViewControllerAnimated:YES
                                                                              completion:^{
                                                                                  [weakSelf p_addTransitionVideoBeginIndexPath:indexPaths.firstObject endIndexPath:indexPaths.lastObject];
                                                                              }];
        };
        [_videoModeifyParametersViewController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController clickBeginButtonAtIndexPath:(NSIndexPath *)indexPath {
    [self p_addNewVideoAtIndexPath:indexPath];
}

- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController clickEndButtonAtIndexPath:(NSIndexPath *)indexPath {
    [self p_addNewVideoAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row + 1 inSection:indexPath.section]];
}

- (void)videoModeifyParametersViewController:(FXVideoModeifyParametersViewController *)videoModeifyParametersViewController clickButtonWithType:(FXVideoModeifyParameterType)type subType:(FXVideoModeifyParameterSubType)subType {
    NSLog(@"点击按钮, type:%@, subType:%@", @(type), @(subType));
    __weak typeof(self) weakSelf = self;
    if (type == FXVideoModeifyParameterEditType) {
        if (subType == FXVideoModeifyParameterCropSubType) {
            __block NSIndexPath *indexPath = nil;
            [videoModeifyParametersViewController.selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.section == 1) {
                    indexPath = obj;
                    *stop = YES;
                }
            }];

            if (indexPath) {
                FXVideoDescribe *editVideo = _timelineManager.timelineDescribe.videoArray[indexPath.row];
                [self cropVideo:editVideo];
            }

        } else if (subType == FXVideoModeifyParameterSortSubType) {
            [self sortVideo];
        } else if (subType == FXVideoModeifyParameterSpliteSubType) {
            [videoModeifyParametersViewController divideVideo];
            [weakSelf p_refreshEditOperationButtonState];
            [weakSelf p_prepareTimelineForPlayback];
        } else if (subType == FXVideoModeifyParameterRotationSubType) {
            [videoModeifyParametersViewController rotateVideo];
            [weakSelf p_refreshEditOperationButtonState];
            [weakSelf p_prepareTimelineForPlayback];
        } else if (subType == FXVideoModeifyParameterVariableSpeedSubType) {
            FXVideoModeifyParameterVariableSpeedSubTypeViewController *controller = FXVideoModeifyParameterVariableSpeedSubTypeViewController.new;
            controller.variableSpeedBlock = ^(CGFloat variableSpeed) {
                [weakSelf.videoModeifyParametersViewController dismissViewControllerAnimated:YES
                                                                                  completion:^{
                                                                                      NSLog(@"变速:%@", @(variableSpeed));
                                                                                      [videoModeifyParametersViewController changeVideoRate:variableSpeed];
                                                                                      [weakSelf p_refreshEditOperationButtonState];
                                                                                      [weakSelf p_prepareTimelineForPlayback];
                                                                                  }];
            };
            [_videoModeifyParametersViewController presentViewController:controller animated:YES completion:nil];
        } else if (subType == FXVideoModeifyParameterDeleteSubType) {
            [self p_showAlertControllerForDeleteSubType];
        }
    } else if (type == FXVideoModeifyParameterSpecialEffectsType) {
        if (subType == FXVideoModeifyParameterPictureInPictureSubType) {
            __weak typeof(self) weakSelf = self;
            FXVideoSelectViewController *controller = [FXVideoSelectViewController videoSelectViewControllerWithAllowMaxSelectedNumber:1
                                                                                                                             nextBlock:^(NSArray<AVAsset *> *_Nonnull avassets) {
                                                                                                                                 [weakSelf dismissViewControllerAnimated:YES
                                                                                                                                                              completion:^{
                                                                                                                                                                  NSLog(@"选择了画中画地址视频地址:%@", avassets);
                                                                                                                                                                  [weakSelf p_addPipVideo:avassets.firstObject];
                                                                                                                                                              }];
                                                                                                                             }];
            [self presentViewController:[UINavigationController.alloc initWithRootViewController:controller] animated:YES completion:nil];
        } else if (subType == FXVideoModeifyParameterFilterSubType) {
            FXVideoModeifyParameterFilterSubTypeViewController *controller = FXVideoModeifyParameterFilterSubTypeViewController.new;
            NSArray <NSIndexPath *>*array = self.videoModeifyParametersViewController.selectedIndexPaths;
            NSInteger videoIndex;
            for (NSIndexPath *indexPath in array) {
                if (indexPath.section == 1) {
                    controller.selectedVideoIndex = indexPath.row;
                    videoIndex = controller.selectedVideoIndex;
                }
            }
            controller.filterSelectedBlock = ^(FXFilterDescribeType filterType) {
                [weakSelf.videoModeifyParametersViewController dismissViewControllerAnimated:YES
                                                                                  completion:^{
                                                                                      NSLog(@"选中滤镜:");
                    [[FXTimelineManager sharedInstance] changeFilterTypeAtIndex:videoIndex filter:filterType];
                    [weakSelf p_refreshEditOperationButtonState];
                    [weakSelf p_prepareTimelineForPlayback];
                                                                                  }];
            };
            [_videoModeifyParametersViewController presentViewController:controller animated:YES completion:nil];
        } else if (subType == FXVideoModeifyParameterEditSubType) {
            [weakSelf p_refreshEditOperationButtonState];
            [weakSelf p_prepareTimelineForPlayback];

        } else if (subType == FXVideoModeifyParameterDeleteSubType) {
            [self p_showAlertControllerForDeleteSubType];
        }
    } else if (type == FXVideoModeifyParameterAudioType) {
        if (subType == FXVideoModeifyParameterSoundtrackSubType) {
            [self.navigationController pushViewController:FXAudioSelectListViewController.new animated:YES];
        } else if (subType == FXVideoModeifyParameterDubbingSubType) {
            FXAudioRecordViewController *controller = FXAudioRecordViewController.new;
            [_videoModeifyParametersViewController presentViewController:controller animated:YES completion:nil];
        } else if (subType == FXVideoModeifyParameterEditSubType) {
            
        } else if (subType == FXVideoModeifyParameterDeleteSubType) {
            [self p_showAlertControllerForDeleteSubType];
        }
    } else if (type == FXVideoModeifyParameterSubtitleType) {
        if (subType == FXVideoModeifyParameterSubtitleSubType) {
            FXTitleInputView *titleInputView = [FXTitleInputView new];
            titleInputView.currentPercent = _currentPercent;
            [self.view addSubview:titleInputView];
            [titleInputView inputViewShow];
            [titleInputView setHoldViewController:_playerViewController];

        } else if (subType == FXVideoModeifyParameterEditSubType) {
            FXVideoModeifyParameterSubtitleSubTypeViewController *controller = FXVideoModeifyParameterSubtitleSubTypeViewController.new;
            controller.titleDescribe = _selectedTitleDescribe;
            controller.selectColorBlock = ^(UIColor *_Nonnull color) {
                NSLog(@"选中颜色:%@", color);
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTitleEditDetail object:nil userInfo:@{@"color":color}];
            };
            controller.selectFontBlock = ^(NSString * _Nonnull fontName) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTitleEditDetail object:nil userInfo:@{@"font":fontName}];
            };
            controller.clickDoneBlock = ^(UIFont *_Nonnull font, UIColor *_Nonnull color) {
                NSLog(@"选中颜色:%@ 字体：%@", color, font);
                [weakSelf.videoModeifyParametersViewController dismissViewControllerAnimated:YES completion:nil];
            };

            controller.alphaChangeBlock = ^(CGFloat alpha) {
                NSLog(@"字体透明度:%@", @(alpha));
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTitleEditDetail object:nil userInfo:@{@"alpha":@(alpha)}];
            };

            [_videoModeifyParametersViewController presentViewController:controller animated:YES completion:nil];
            
        } else if (subType == FXVideoModeifyParameterDeleteSubType) {
            [self p_showAlertControllerForDeleteSubType];
        }
    }
}
#pragma mark -

- (void)startProgress
{
    _dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [_dlink setFrameInterval:15];
    [_dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_dlink setPaused:NO];
}

- (void)updateProgress {
    [SVProgressHUD showProgress:_exporter.progress status:NSLocalizedString(@"生成中...", nil)];
    if (_exporter.progress >= 1.0) {
        [_dlink setPaused:true];
        [_dlink invalidate];
        [SVProgressHUD dismiss];
    }
}


#pragma -mark function

- (void)cropVideo:(FXVideoDescribe *)videoDescribe
{
    __weak typeof(self) weakSelf = self;

    _previewController = [[FXVideoPreviewViewController alloc] init];
    _previewController.delegate = self;
    [self addChildViewController:_previewController];
    [self.view addSubview:_previewController.view];
    [_previewController didMoveToParentViewController:self];
    [_previewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superview = weakSelf.previewController.view.superview;
        make.left.right.equalTo(superview);
        make.top.equalTo(superview.mas_topMargin);
        make.bottom.equalTo(superview.mas_centerY);
    }];
    
    FXVideoModeifyParameterCropSubTypeViewController *controller = [FXVideoModeifyParameterCropSubTypeViewController videoModeifyParameterCropSubTypeViewControllerWithVideoDescribe:videoDescribe];
    controller.doneBlock = ^(CGFloat left, CGFloat rigtht) {
        [weakSelf.previewController.view removeFromSuperview];
        [weakSelf.playerViewController didMoveToParentViewController:self];
        [[FXTimelineManager sharedInstance] cropVideo:videoDescribe leftPer:left rightper:rigtht];
        [weakSelf.videoModeifyParametersViewController rebuildTimelineView];
        [weakSelf p_refreshEditOperationButtonState];
        [weakSelf p_prepareTimelineForPlayback];
        [weakSelf.videoModeifyParametersViewController dismissViewControllerAnimated:YES
                                                                          completion:^{
                                                                              NSLog(@"普通裁剪,left:%@, right:%@", @(left), @(rigtht));
                                                                          }];
    };
    controller.MoveBlock = ^(CGFloat percent) {
        [weakSelf.previewController seekVideoToPercent:percent];
    };
    [_videoModeifyParametersViewController presentViewController:controller animated:YES completion:nil];
    
    FXPreviewComposition *previewComposition = [[FXPreviewComposition alloc] initWithVideo:videoDescribe];
    [_previewController changePreviewComposition:previewComposition];

}

- (void)sortVideo
{
    FXVideoModeifyParameterSortSubTypeViewController *controller = [FXVideoModeifyParameterSortSubTypeViewController videoModeifyParameterSortSubTypeViewControllerWithDataModel:_timelineManager.timelineDescribe];
    [_videoModeifyParametersViewController presentViewController:controller animated:YES completion:nil];
}


@end
