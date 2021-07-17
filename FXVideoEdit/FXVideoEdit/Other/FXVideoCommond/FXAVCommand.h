//
//  FXAVCommand.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVComposition.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FXVideoCommandType) {
    //视频轨道
    FXVideoCommandTypeLoad, //初次加载视频
    FXVideoCommandTypeAppendVideo, //拼接一个视频
    FXVideoCommandTypeChangeRate, //调整播放速度
    FXVideoCommandTypeExchangeVideo, //交换两个视频片段的位置
    FXVideoCommandTypeVideoDivision, //将主视频轨道上的视频片段分割成两段视频
    FXVideoCommandTypeVideoDelete, //删除视频片段
    FXVideoCommandTypeTrimVideo, //视频裁剪
    FXVideoCommandTypeRotateVideo, //视频旋转
    FXVideoCommandTypeCropVideo, //视频大小裁剪
    FXVideoCommandTypeSizePicture, //调整画幅
    FXVideoCommandTypeAddWatermark, //添加水印
    FXVideoCommandTypeVideoTransitions, //视频转场
    FXVideoCommandTypeVideoFilter, //视频滤镜

    //画中画轨道
    FXVideoCommandTypePictureInPictureAdd, //画中画
    FXVideoCommandTypePictureInPictureTrim,
    FXVideoCommandTypePictureInPictureMute,

    //音频轨道
    FXVideoCommandTypeAddAudio, //插入音频
    FXVideoCommandTypeRecordAudio, //插入录制音频
    FXVideoCommandTypeAudioMute, //原视频静音调整
    FXVideoCommandTypeAudioVolumeAdjustment, //音量调节
    FXVideoCommandTypeAudioTrim, //音频裁剪
    FXVideoCommandTypeAudioDelete,
    FXVideoCommandTypeAudioExchange,

    //字幕轨道
    FXVideoCommandTypeAddSubtitle,
};

@interface FXAVCommand : NSObject

- (instancetype)initWithComposition:(FXAVComposition *)composition;

@property (nonatomic, strong) FXAVComposition *composition;

@property (nonatomic, assign) FXVideoCommandType commandType;

/**
 视频信息初始化

 @param asset asset
 */
- (void)performWithAsset:(AVAsset *)asset;

/**
 视频融合器初始化
 */
- (void)performVideoCompopsition;

/**
 音频融合器初始化
 */
- (void)performAudioCompopsition;

/**
  计算旋转角度

  @param transform transForm
  @return 角度
  */
- (NSUInteger)degressFromTransform:(CGAffineTransform)transForm;

extern NSString *const FXAVExportCommandCompletionNotification;

extern NSString *const FXAVExportCommandError;

@end