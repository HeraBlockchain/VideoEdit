//
//  FXNormalCropMaskView.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/11.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXNormalCropMaskView : UIView

@property (nonatomic, assign, readonly) UIEdgeInsets edgeInsets;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, copy) void (^MoveBlock)(CGFloat percent);

@end

NS_ASSUME_NONNULL_END
