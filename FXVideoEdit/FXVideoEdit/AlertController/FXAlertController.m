//
//  FXAlertController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAlertController.h"

@interface FXAlertController ()

@property (nonatomic, copy) NSString *alertTitle;

@property (nonatomic, copy) NSString *alertmessage;

@property (nonatomic, copy) NSString *leftButtonTitle;

@property (nonatomic, copy) NSString *rightButtonTitle;

@property (nonatomic, copy) void (^leftButtonActionBlock)(FXAlertController *);

@property (nonatomic, copy) void (^rightButtonActionBlock)(FXAlertController *);

@property (nonatomic, strong) QMUITextField *textField;

@end

@implementation FXAlertController

#pragma mark 对外
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message leftButtonTitle:(NSString *)leftButtonTitle leftButtonActionBlock:(void (^)(FXAlertController *))leftButtonActionBlock rightButtonTitle:(NSString *)rightButtonTitle rightButtonActionBlock:(void (^)(FXAlertController *))rightButtonActionBlock {
    FXAlertController *controller = FXAlertController.new;
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.alertTitle = title;
    controller.alertmessage = message;
    controller.leftButtonTitle = leftButtonTitle;
    controller.leftButtonActionBlock = leftButtonActionBlock;
    controller.rightButtonTitle = rightButtonTitle;
    controller.rightButtonActionBlock = rightButtonActionBlock;
    return controller;
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title textFieldPlaceholder:(nullable NSString *)textFieldPlaceholder leftButtonTitle:(NSString *)leftButtonTitle leftButtonActionBlock:(void (^)(FXAlertController *alertController))leftButtonActionBlock rightButtonTitle:(NSString *)rightButtonTitle rightButtonActionBlock:(void (^)(FXAlertController *alertController))rightButtonActionBlock {
    FXAlertController *controller = FXAlertController.new;
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.alertTitle = title;
    controller.textField = [QMUITextField new];
    controller.textField.placeholderColor = UIColor.grayColor;
    UIEdgeInsets textInsets = controller.textField.textInsets;
    textInsets.left += 10;
    controller.textField.textInsets = textInsets;
    controller.textField.font = [UIFont systemFontOfSize:IS_IPAD ? 28 : 16];
    controller.textField.borderStyle = UITextBorderStyleNone;
    controller.textField.placeholder = textFieldPlaceholder;
    controller.leftButtonTitle = leftButtonTitle;
    controller.leftButtonActionBlock = leftButtonActionBlock;
    controller.rightButtonTitle = rightButtonTitle;
    controller.rightButtonActionBlock = rightButtonActionBlock;
    return controller;
}

#pragma mark -

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    {
        self.view.backgroundColor = [UIColor colorWithRGBA:0x0000004D];
    }

    __weak typeof(self) weakSelf = self;

    UIView *backView = UIView.new;
    {
        backView.layer.cornerRadius = IS_IPAD ? 8 : 4;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView.superview);
            make.bottom.equalTo(backView.superview.mas_centerY);
            make.width.mas_equalTo(IS_IPAD ? 490 : 266);
            make.height.mas_equalTo(IS_IPAD ? 278 : 151);
        }];
    }

    UILabel *titleLabel = UILabel.new;
    {
        titleLabel.text = _alertTitle;
        titleLabel.textColor = [UIColor colorWithRGBA:0x161824FF];
        titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 28 : 16];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(titleLabel.superview);
            make.top.equalTo(titleLabel.superview).offset(IS_IPAD ? 23 : 15);
        }];
    }

    if (_textField) {
        _textField.backgroundColor = [UIColor colorWithRGBA:0xF6F7F8FF];
        [backView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.textField.superview);
            make.width.equalTo(weakSelf.textField.superview).offset(-64);
            make.height.mas_equalTo(IS_IPAD ? 69 : 36);
            make.top.equalTo(titleLabel.mas_bottom).offset(IS_IPAD ? 22 : 13);
        }];
    } else {
        {
            UILabel *messageLabel = UILabel.new;
            messageLabel.text = _alertmessage;
            messageLabel.textColor = [UIColor colorWithRGBA:0x161824FF];
            messageLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 28 : 16];
            messageLabel.adjustsFontSizeToFitWidth = YES;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:messageLabel];
            [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.width.equalTo(messageLabel.superview);
                make.top.equalTo(titleLabel.mas_bottom).offset(IS_IPAD ? 37 : 20);
            }];
        }
    }

    {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton addBlockForControlEvents:UIControlEventTouchUpInside
                                       block:^(id _Nonnull sender) {
                                           if (weakSelf.leftButtonActionBlock) {
                                               weakSelf.leftButtonActionBlock(weakSelf);
                                           }
                                       }];
        leftButton.backgroundColor = [UIColor colorWithRGBA:0xF6F7F8FF];
        leftButton.layer.cornerRadius = 4;
        leftButton.layer.masksToBounds = YES;
        [leftButton setTitle:_leftButtonTitle forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor colorWithRGBA:0x161824FF] forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 28 : 16];
        [backView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(IS_IPAD ? 158 : 86);
            make.height.mas_equalTo(IS_IPAD ? 62 : 34);
            make.centerX.equalTo(leftButton.superview).multipliedBy(0.5);
            make.bottom.equalTo(leftButton.superview).offset(IS_IPAD ? -37 : -20);
        }];
    }

    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addBlockForControlEvents:UIControlEventTouchUpInside
                                        block:^(id _Nonnull sender) {
                                            if (weakSelf.rightButtonActionBlock) {
                                                weakSelf.rightButtonActionBlock(weakSelf);
                                            }
                                        }];
        rightButton.backgroundColor = [UIColor colorWithRGBA:0xF54184FF];
        rightButton.layer.cornerRadius = 4;
        rightButton.layer.masksToBounds = YES;
        [rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRGBA:0x161824FF] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 28 : 16];
        [backView addSubview:rightButton];

        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(IS_IPAD ? 158 : 86);
            make.height.mas_equalTo(IS_IPAD ? 62 : 34);
            make.centerX.equalTo(rightButton.superview).multipliedBy(1.5);
            make.bottom.equalTo(rightButton.superview).offset(IS_IPAD ? -37 : -20);
        }];
    }
}
#pragma mark -

@end
