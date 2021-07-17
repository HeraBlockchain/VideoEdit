//
//  FXAudioDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioItem.h"
#import "FXDescribe.h"

@interface FXAudioDescribe : FXDescribe

@property (nonatomic, assign) NSInteger audioIndex;

@property (nonatomic, assign) BOOL reverse;

@property (nonatomic, strong) FXAudioItem *audioItem;

@property (nonatomic, assign) CGFloat volume;

@end
