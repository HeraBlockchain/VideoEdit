//
//  FXCustomSubTypeTitleView.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXCustomSubTypeTitleView : UIView

@property (nonatomic, copy, nullable) NSString *title;

@property (nonatomic, copy, nullable) void (^closeButtonActionBlock)(void);

@property (nonatomic, copy, nullable) void (^doneButtonActionBlock)(void);

@property (nonatomic, assign, readonly, class) CGFloat heightOfCustomSubTypeTitleView;

@end

NS_ASSUME_NONNULL_END