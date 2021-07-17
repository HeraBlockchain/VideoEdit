//
//  FXViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXViewController : UIViewController

- (void)showDesc:(NSString *)desc;

- (void)showError:(NSError *)error;

- (void)showErrorDesc:(NSString *)errorDesc;

@end

NS_ASSUME_NONNULL_END