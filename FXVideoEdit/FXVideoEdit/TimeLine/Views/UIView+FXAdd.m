//
//  UIView+FXAdd.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "UIView+FXAdd.h"

@implementation UIView (FXAdd)

- (UIImage *)toImage {
    return [self toImageWithSize:self.bounds.size];
}

- (UIImage *)toImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImageView *)toImageView {
    return [self toImageViewWithSize:self.bounds.size];
}

- (UIImageView *)toImageViewWithSize:(CGSize)size {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self toImageWithSize:size]];
    imageView.frame = CGRectMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), size.width, size.height);
    return imageView;
}

@end