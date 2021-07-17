//
//  FXTimelineItem.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

//资源的描述，不可变且唯一，子类也是不可变

@interface FXSourceItem : NSObject

@property (nonatomic) CMTimeRange timeRange;

@end