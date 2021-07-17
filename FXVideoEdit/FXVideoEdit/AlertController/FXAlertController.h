//
//  FXAlertController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXAlertController : UIViewController

@property (nonatomic, strong, readonly, nullable) QMUITextField *textField;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message leftButtonTitle:(NSString *)leftButtonTitle leftButtonActionBlock:(void (^)(FXAlertController *alertController))leftButtonActionBlock rightButtonTitle:(NSString *)rightButtonTitle rightButtonActionBlock:(void (^)(FXAlertController *alertController))rightButtonActionBlock;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title textFieldPlaceholder:(nullable NSString *)textFieldPlaceholder leftButtonTitle:(NSString *)leftButtonTitle leftButtonActionBlock:(void (^)(FXAlertController *alertController))leftButtonActionBlock rightButtonTitle:(NSString *)rightButtonTitle rightButtonActionBlock:(void (^)(FXAlertController *alertController))rightButtonActionBlock;

@end

NS_ASSUME_NONNULL_END