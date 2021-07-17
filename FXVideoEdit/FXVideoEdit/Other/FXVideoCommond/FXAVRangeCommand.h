//
//  FXAVRangeCommand.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVCommand.h"

@interface FXAVRangeCommand : FXAVCommand

- (void)performWithTimeRange:(CMTimeRange)range;

@end