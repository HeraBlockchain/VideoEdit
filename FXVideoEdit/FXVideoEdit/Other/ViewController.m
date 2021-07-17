//
//  ViewController.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/15.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "ViewController.h"
#import "ECPrivacyCheckGatherTool.h"
#import "ECPrivacyCheckMicrophone.h"
#import "FXAlertController.h"
#import "FXAudioSelectListViewController.h"
#import "FXVideoEditViewController.h"
#import "FXVideoSelectViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.blackColor;
}
- (IBAction)requestPhotoPrivacy:(id)sender {
    [ECPrivacyCheckGatherTool requestPhotosAuthorizationWithCompletionHandler:^(BOOL granted) {
        if (granted) {
            [SVProgressHUD showInfoWithStatus:@"已获取照片权限"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"用户禁用该APP使用照片权限"];
        }
    }];
}
- (IBAction)requestMicroPrivacy:(id)sender {
    [ECPrivacyCheckMicrophone requestMicrophoneAuthorizationWithCompletionHandler:^(BOOL granted) {
        if (granted) {
            [SVProgressHUD showInfoWithStatus:@"已获取麦克风权限"];
        } else {
            [SVProgressHUD showInfoWithStatus:@"用户禁用该APP使用麦克风权限"];
        }
    }];
}

- (IBAction)startEditVideo:(id)sender {
//    FXMainViewController *selectVC = [FXMainViewController new];
//    [self.navigationController pushViewController:selectVC animated:YES];
    [self clickBarButtonItem];
}

#pragma mark UI回调
- (void)clickBarButtonItem{
    __weak typeof(self) weakSelf = self;

    int type = 0;

    if (type == 0) {
        
        FXVideoSelectViewController *controller = [FXVideoSelectViewController videoSelectViewControllerWithAllowMaxSelectedNumber:10
                                                                                                                         nextBlock:^(NSArray<AVAsset *> *_Nonnull avassets) {
                                                                                                                             [weakSelf.navigationController popToViewController:weakSelf animated:NO];
                                                                                                                             [weakSelf.navigationController pushViewController:[FXVideoEditViewController videoEditViewControllerWithAVAssets:avassets] animated:YES];
                                                                                                                         }];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (type == 1) {
        FXAlertController *controller = [FXAlertController alertControllerWithTitle:@"title"
            message:@"message"
            leftButtonTitle:@"左边"
            leftButtonActionBlock:^(FXAlertController *_Nonnull alertController) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }
            rightButtonTitle:@"右边"
            rightButtonActionBlock:^(FXAlertController *_Nonnull alertController) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];

        [self presentViewController:controller animated:YES completion:nil];
    } else if (type == 2) {
        FXAlertController *controller = [FXAlertController alertControllerWithTitle:@"title"
            textFieldPlaceholder:@"textFieldPlaceholder"
            leftButtonTitle:@"左边"
            leftButtonActionBlock:^(FXAlertController *_Nonnull alertController) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }
            rightButtonTitle:@"右边"
            rightButtonActionBlock:^(FXAlertController *_Nonnull alertController) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];

        [self presentViewController:controller animated:YES completion:nil];
    } else if (type == 3) {
        [self.navigationController pushViewController:FXAudioSelectListViewController.new animated:YES];
    } else if (type == 4) {
        [self.navigationController pushViewController:FXVideoEditViewController.new animated:YES];
    }
}
#pragma mark -
@end
