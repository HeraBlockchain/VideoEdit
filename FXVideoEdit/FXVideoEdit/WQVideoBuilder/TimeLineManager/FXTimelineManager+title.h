//
//  FXTimelineManager+title.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager.h"

@class FXTitleDescribe;

@interface FXTimelineManager (title)

- (void)addTitleWithTitle:(FXTitleDescribe *)titleDescribe;

- (NSArray *)titleArrayWithVideoDescribe:(FXVideoDescribe *)videoDescribe;

@end
