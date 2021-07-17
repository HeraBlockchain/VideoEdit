//
//  FXTimelineManager+resource.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager.h"

@interface FXTimelineManager (resource)

- (void)addSource:(FXSourceItem *)item type:(FXDescribeType)type;

- (FXSourceItem *)sourceItemWithtype:(FXDescribeType)type sourceUrl:(NSString *)url;

@end