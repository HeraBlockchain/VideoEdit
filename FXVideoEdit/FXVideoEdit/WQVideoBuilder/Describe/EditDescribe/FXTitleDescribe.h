//
//  FXTitleDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/15.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXDescribe.h"

@interface FXTitleDescribe : FXDescribe

@property (nonatomic, assign) NSInteger titleIndex;

@property (nonatomic, assign) CGFloat rotateAngle;

@property (nonatomic, assign) CGFloat centerXP; //相对主视频的位置比例

@property (nonatomic, assign) CGFloat centerYP; //相对主视频的位置比例

@property (nonatomic, assign) CGFloat widthPercent; //相对主视频的大小比例

@property (nonatomic, assign) CGFloat widthHeightPercent; //相对主视频的大小比例


@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) CGFloat alpha;

@property (nonatomic, copy) NSString *color;

@property (nonatomic, copy) NSString *fountName;

- (UIFont *)titleFont;

@end
