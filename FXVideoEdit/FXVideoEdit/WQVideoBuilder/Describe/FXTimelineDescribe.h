//
//  FXTimelineDescribe.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FXPictureSize) {
    FXPictureSizeDefult, //原始画幅，以第一个视频为准
    FXPictureSize9X16,
    FXPictureSize3X4,
    FXPictureSize1X1,
    FXPictureSize4X3,
    FXPictureSize16X9,
};

@class FXVideoItem;
@class FXAudioItem;
@class FXAudioDescribe;
@class FXPIPVideoDescribe;
@class FXTransitionDescribe;
@class FXVideoDescribe;
@class FXMusicDescribe;
@class FXRecordDescribe;

@interface FXTimelineDescribe : NSObject

@property (nonatomic, assign) CMTime duration; //总时长

@property (nonatomic, strong) NSMutableArray<FXVideoDescribe *> *videoArray;

@property (nonatomic, strong) NSMutableArray<FXTransitionDescribe *> *transitionArray;

@property (nonatomic, strong) NSMutableArray<FXAudioDescribe *> *audioArray;

@property (nonatomic, strong) NSMutableArray<FXPIPVideoDescribe *> *pipVideoArray;

@property (nonatomic, strong) NSMutableArray<FXMusicDescribe *>*musicArray;

@property (nonatomic, strong) NSMutableArray *filterArray;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *overlayArray;

@property (nonatomic, assign) CGFloat lengthTimeScale; //时间轴上宽度/时间的比

@property (nonatomic, assign) CGSize defaultNaturalSize; //第一个视频的尺寸

@property (nonatomic, assign) FXPictureSize pictureSize; //画幅

@property (nonatomic, assign) CGFloat mainVideoVolume;

@property (nonatomic, assign) CGFloat pipVideoVolume;

@end
