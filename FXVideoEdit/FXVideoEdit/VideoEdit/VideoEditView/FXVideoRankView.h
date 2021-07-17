//
//  FXVideoRankView.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/12.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXTimelineDescribe;

typedef void (^CancelBlock)(void);
typedef void (^ConfirmSortBlock)(void);
typedef void (^MoveStepBlock)(NSInteger fromIndex, NSInteger toindex);
typedef void (^DeleteBlock)(NSInteger deleteIndex);

@interface FXVideoRankView : UIView

@property (nonatomic, copy) CancelBlock cancelBlock;

@property (nonatomic, copy) ConfirmSortBlock confirmSortBlock;

@property (nonatomic, copy) MoveStepBlock stepBlock;

@property (nonatomic, copy) DeleteBlock deleteBlock;

@property (nonatomic, strong) FXTimelineDescribe *timelineDescribe;

@end