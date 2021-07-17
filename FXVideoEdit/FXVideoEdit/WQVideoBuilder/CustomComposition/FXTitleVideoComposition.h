//
//  FXTitleVideoComposition.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/15.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXTitleDescribe.h"

@class FXPlayerViewController;

@interface FXTitleVideoComposition : NSObject

@property (nonatomic, strong) NSArray<FXTitleDescribe *> *titleDescribeArray;

@property (nonatomic, assign) CMTime playTime;

- (instancetype)initWithTitle:(NSArray *)titleDesArray;

- (void)setHoldViewController:(FXPlayerViewController *)holdViewController;

- (void)videoPlayToTime:(CMTime)time;

- (void)seekVideoToTime:(CMTime)time;

@end
