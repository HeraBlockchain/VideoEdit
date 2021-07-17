//
//  FXRecordDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXDescribe.h"
#import "FXAudioItem.h"

@interface FXRecordDescribe : FXDescribe

@property (nonatomic, assign) NSInteger recordIndex;

@property (nonatomic, assign) CGFloat volume;

@property (nonatomic, strong) FXAudioItem *audioItem;

@end
