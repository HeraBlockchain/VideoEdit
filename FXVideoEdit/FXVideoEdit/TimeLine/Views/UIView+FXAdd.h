//
//  UIView+FXAdd.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FXAdd)
/**
 * Returns the UIImage representation of this view.
 */
- (UIImage *)toImage;

/**
 * Returns a UIImageView representation of this view.  The image view's initial frame
 * is set to the frame as the view.
 */
- (UIImageView *)toImageView;

@end