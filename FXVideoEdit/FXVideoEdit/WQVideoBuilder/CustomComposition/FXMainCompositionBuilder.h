//
//  FXMainCompositionBuilder.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FXTimelineDescribe;
@class FXMainComposition;

@interface FXMainCompositionBuilder : NSObject

- (id)initWithTimeline:(FXTimelineDescribe *)timelineDescribe;

- (FXMainComposition *)buildComposition;

- (FXMainComposition *)buildCompositionForExport;

@end
