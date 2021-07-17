//
//  FXVideoChangeRateView.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/12.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CancelBlock)(void);
typedef void (^ConfirmBlock)(CGFloat scale);

@interface FXVideoChangeRateView : UIView

@property (nonatomic, copy) CancelBlock cancelBlock;

@property (nonatomic, copy) ConfirmBlock confirmBlock;

@end