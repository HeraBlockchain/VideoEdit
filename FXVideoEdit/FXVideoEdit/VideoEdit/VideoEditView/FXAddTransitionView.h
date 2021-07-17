//
//  FXAddTransitionView.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/26.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AddTransitionCancelBlock)(void);
typedef void (^AddTransitionConfirmSortBlock)(void);
typedef void (^AddTransitionButtonBlock)(void);

@interface FXAddTransitionView : UIView

@property (nonatomic, copy) AddTransitionCancelBlock cancelBlock;

@property (nonatomic, copy) AddTransitionConfirmSortBlock confitmBlock;
@property (nonatomic, copy) AddTransitionButtonBlock buttonBlock;
@end