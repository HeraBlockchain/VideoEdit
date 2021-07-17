//
//  FXVideoModeifyParameterChooseTransitionSubTypeViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterChooseTransitionSubTypeViewController.h"
#import <QMUIKit/QMUIKit.h>

@interface FXVideoModeifyParameterChooseTransitionSubTypeViewController ()

@end

@implementation FXVideoModeifyParameterChooseTransitionSubTypeViewController

#pragma mark UIViewCotnroller
- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    {
        QMUIButton *addNewVideoButton = QMUIButton.new;
        addNewVideoButton.layer.cornerRadius = 2;
        addNewVideoButton.layer.masksToBounds = YES;
        addNewVideoButton.backgroundColor = [UIColor colorWithRGBA:0x181818FF];
        addNewVideoButton.imagePosition = QMUIButtonImagePositionTop;
        addNewVideoButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 10 : 10];
        [addNewVideoButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        addNewVideoButton.spacingBetweenImageAndTitle = IS_IPAD ? 9 : 6;
        [addNewVideoButton setTitle:@"添加视频" forState:UIControlStateNormal];
        [addNewVideoButton setImage:[UIImage imageNamed:@"添加视频"] forState:UIControlStateNormal];
        addNewVideoButton.contentEdgeInsets = IS_IPAD ? UIEdgeInsetsMake(7, 15, 10, 15) : UIEdgeInsetsMake(8, 5, 7, 8);
        [addNewVideoButton addBlockForControlEvents:UIControlEventTouchUpInside
                                              block:^(id _Nonnull sender) {
                                                  if (weakSelf.addNewVideoBlock) {
                                                      weakSelf.addNewVideoBlock();
                                                  }
                                              }];
        [self.view addSubview:addNewVideoButton];
        [addNewVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addNewVideoButton.superview);
            make.right.equalTo(addNewVideoButton.superview.mas_centerX).offset(-20);
        }];
    }

    {
        QMUIButton *addTransitionButton = QMUIButton.new;
        addTransitionButton.layer.cornerRadius = 2;
        addTransitionButton.layer.masksToBounds = YES;
        addTransitionButton.backgroundColor = [UIColor colorWithRGBA:0x181818FF];
        addTransitionButton.imagePosition = QMUIButtonImagePositionTop;
        addTransitionButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 10 : 10];
        [addTransitionButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        addTransitionButton.spacingBetweenImageAndTitle = IS_IPAD ? 9 : 6;
        [addTransitionButton setTitle:@"添加转场" forState:UIControlStateNormal];
        [addTransitionButton setImage:[UIImage imageNamed:@"添加转场"] forState:UIControlStateNormal];
        addTransitionButton.contentEdgeInsets = IS_IPAD ? UIEdgeInsetsMake(7, 15, 10, 15) : UIEdgeInsetsMake(8, 5, 7, 8);
        [addTransitionButton addBlockForControlEvents:UIControlEventTouchUpInside
                                                block:^(id _Nonnull sender) {
                                                    if (weakSelf.addTransitionBlock) {
                                                        weakSelf.addTransitionBlock();
                                                    }
                                                }];
        [self.view addSubview:addTransitionButton];
        [addTransitionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(addTransitionButton.superview);
            make.left.equalTo(addTransitionButton.superview.mas_centerX).offset(20);
        }];
    }

    {
        [self.view addGestureRecognizer:[UITapGestureRecognizer.alloc initWithActionBlock:^(id _Nonnull sender) {
                       [weakSelf dismissViewControllerAnimated:YES completion:nil];
                   }]];
    }
}
#pragma mark -

@end