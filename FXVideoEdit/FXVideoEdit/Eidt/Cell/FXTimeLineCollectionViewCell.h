//
//  FXTimeLineCollectionViewCell.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/4.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXTimeLineCollectionViewCell : UICollectionViewCell {
      @protected
    UIButton *_leftAddButton;
    UIButton *_rightAddButton;
}

- (CGRect)leftAddButtonFrameInView:(UIView *)view;
- (CGRect)rightAddButtonFrameInView:(UIView *)view;
- (void)setLeftButtonOffset:(CGFloat)leftOffset rightButtonOffset:(CGFloat)rightButtonOffset;
- (void)layoutAddButton;
@end

NS_ASSUME_NONNULL_END
