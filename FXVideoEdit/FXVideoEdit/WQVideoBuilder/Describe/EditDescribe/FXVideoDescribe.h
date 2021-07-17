//
//  FXVideoDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXDescribe.h"
#import "FXVideoItem.h"
#import "FXFilterDescribe.h"

typedef NS_ENUM(NSUInteger, FXRotation) {
    FXRotationNone,
    FXRotation90,
    FXRotation180,
    FXRotation270,
};

@interface FXVideoDescribe : FXDescribe

@property (nonatomic, assign) NSInteger videoIndex;

@property (nonatomic, assign) BOOL reverse;

@property (nonatomic, readonly) FXRotation rotate;

@property (nonatomic, strong) FXVideoItem *videoItem;

@property (nonatomic, assign) BOOL mute;

@property (nonatomic, assign) FXFilterDescribeType filterType;

@property (nonatomic, assign) CMPersistentTrackID trackID;

- (void)rotaToNextAnale;

- (UIImage *)coverImage;

- (FXVideoDescribe *)copyVideoDescribe;

@end
