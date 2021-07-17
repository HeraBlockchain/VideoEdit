//
//  FXFilterDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/9.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXDescribe.h"

typedef NS_ENUM(NSUInteger, FXFilterDescribeType) {
    FXFilterDescribeTypeNone,
    FXFilterDescribeTypeChrome,
    FXFilterDescribeTypeFade,
    FXFilterDescribeTypeInstant,
    FXFilterDescribeTypeMono,
    FXFilterDescribeTypeNoir,
    FXFilterDescribeTypeprocess,
    FXFilterDescribeTypeTonal,
    FXFilterDescribeTypeTransfer,
};

@interface FXFilterDescribe : FXDescribe

+ (CIFilter *)filterWithType:(FXFilterDescribeType)filterType;

+(NSString *)filterNameWithType:(FXFilterDescribeType)type;


@end
