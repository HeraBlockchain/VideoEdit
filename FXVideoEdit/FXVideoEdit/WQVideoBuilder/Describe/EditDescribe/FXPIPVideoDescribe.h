//
//  FXPIPVideoDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioItem.h"
#import "FXDescribe.h"
#import "FXVideoItem.h"

@interface FXPIPVideoDescribe : FXDescribe

@property (nonatomic, assign) NSInteger videoIndex;

@property (nonatomic, assign) CGFloat rotateAngle;

@property (nonatomic, strong) FXVideoItem *videoItem;

@property (nonatomic, strong) FXAudioItem *audioItem;

@property (nonatomic, assign) CGFloat centerXP; //相对主视频的位置比例

@property (nonatomic, assign) CGFloat centerYP; //相对主视频的位置比例

@property (nonatomic, assign) CGFloat widthPercent; //相对主视频的大小比例

@property (nonatomic, assign) CGFloat scaleSize;  //相对默认大小的缩放比例

@property (nonatomic, assign) CGFloat volume;


@end
