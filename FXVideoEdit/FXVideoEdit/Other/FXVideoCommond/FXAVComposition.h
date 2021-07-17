//
//  FXAVComposition.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXAVComposition : NSObject

/**
 视频轨道信息
 */
@property (nonatomic, strong) AVMutableComposition *mutableComposition;
/**
 视频操作指令
 */
@property (nonatomic, strong) AVMutableVideoComposition *mutableVideoComposition;

//视频大小，一般取第一个视频片段的大小
@property (nonatomic, assign) CGSize naturalSize;

/**
 音频操作指令
 */
@property (nonatomic, strong) AVMutableAudioMix *mutableAudioMix;

/**
 视频时长(变速/裁剪后)
 */
@property (nonatomic, assign) CMTime duration;

/**
 视频分辩率
 */
@property (nonatomic, copy) NSString *presetName;

/**
 视频质量
 */
@property (nonatomic, assign) NSInteger videoQuality;

/**
 输出文件格式
 */
@property (nonatomic, copy) AVFileType fileType;

/**
 视频操作参数数组,包括转场这些动画
 */
@property (nonatomic, strong) NSMutableArray<AVMutableVideoCompositionInstruction *> *instructions;

/**
 音频操作参数数组
 */
@property (nonatomic, strong) NSMutableArray<AVMutableAudioMixInputParameters *> *audioMixParams;

/**
 画布父容器
 */
@property (nonatomic, strong) CALayer *parentLayer;

/**
 原视频容器
 */
@property (nonatomic, strong) CALayer *videoLayer;

@property (nonatomic, assign) CGSize lastInstructionSize;

@end