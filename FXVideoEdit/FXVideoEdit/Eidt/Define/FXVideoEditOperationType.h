//
//  FXVideoEditOperationType.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#ifndef FXVideoEditOperationType_h
#define FXVideoEditOperationType_h

typedef NS_ENUM(NSInteger, FXVideoModeifyParameterType) {
    FXVideoModeifyParameterEditType = 1,
    FXVideoModeifyParameterSpecialEffectsType,
    FXVideoModeifyParameterAudioType,
    FXVideoModeifyParameterSubtitleType,
};

typedef NS_ENUM(NSInteger, FXVideoModeifyParameterSubType) {
    FXVideoModeifyParameterPlaceholderSubType = 0, //占位用。
    FXVideoModeifyParameterCropSubType, //裁剪
    FXVideoModeifyParameterSortSubType, //排序
    FXVideoModeifyParameterSpliteSubType, //分割
    FXVideoModeifyParameterRotationSubType, //旋转
    FXVideoModeifyParameterVariableSpeedSubType, //变速。
    FXVideoModeifyParameterDeleteSubType, //删除
    FXVideoModeifyParameterPictureInPictureSubType, //画中画
    FXVideoModeifyParameterFilterSubType, //滤镜
    FXVideoModeifyParameterEditSubType, //编辑。
    FXVideoModeifyParameterSoundtrackSubType, //配乐
    FXVideoModeifyParameterDubbingSubType, //配音
    FXVideoModeifyParameterSubtitleSubType, //字幕
};

#endif /* FXVideoEditOperationType_h */