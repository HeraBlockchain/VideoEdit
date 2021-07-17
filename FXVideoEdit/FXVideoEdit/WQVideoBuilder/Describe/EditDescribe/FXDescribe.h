//
//  FXDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>

typedef NS_ENUM(NSUInteger, FXDescribeType) {
    FXDescribeTypeNone,
    FXDescribeTypeVideo,
    FXDescribeTypeAudio,
    FXDescribeTypeTransition,
    FXDescribeTypeTitle,
    FXDescribeTypePip,
    FXDescribeTypeMusic,
    FXDescribeTypeRecord
};

@interface FXDescribe : NSObject

@property (nonatomic, assign) CMTime startTime;

@property (nonatomic, assign) CMTime duration;

@property (nonatomic, assign) CMTimeRange sourceRange;

@property (nonatomic, assign) CGFloat scale; //变速的倍速

@property (nonatomic, assign) FXDescribeType desType;

- (NSDictionary *)objectDictionary;

- (void)setObjectWithDic:(NSDictionary *)dic;

@end
