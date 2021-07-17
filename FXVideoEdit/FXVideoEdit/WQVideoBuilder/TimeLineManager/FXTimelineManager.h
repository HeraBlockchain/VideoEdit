//
//  FXTimelineManager.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/6.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioDescribe.h"
#import "FXAudioItem.h"
#import "FXDescribe.h"
#import "FXPIPVideoDescribe.h"
#import "FXTimelineDescribe.h"
#import "FXTransitionDescribe.h"
#import "FXVideoDescribe.h"
#import "FXVideoItem.h"
#import <Foundation/Foundation.h>

@class FXSourceItem;

@interface FXTimelineManager : NSObject

@property (nonatomic, strong) FXTimelineDescribe *timelineDescribe;

@property (nonatomic, assign) CMTime currentTime;

@property (nonatomic, strong) NSMutableArray *historyDataArray;

@property (nonatomic, assign) NSInteger operationIndex;

@property (nonatomic, strong) NSMutableArray *videoSourceArray;

@property (nonatomic, strong) NSMutableArray *audioSourceArray;

#pragma -mark Audio record

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, assign) NSInteger audioIndex;

@property (nonatomic, assign) CMTime startTime;

@property (nonatomic, strong) NSMutableArray *recordAudioArray;

#pragma -mark function

+ (instancetype)sharedInstance;

- (void)clearAllData;

@end

#import "FXTimelineManager+history.h"
#import "FXTimelineManager+music.h"
#import "FXTimelineManager+pipVideoOperation.h"
#import "FXTimelineManager+recordAudio.h"
#import "FXTimelineManager+resource.h"
#import "FXTimelineManager+title.h"
#import "FXTimelineManager+videoEdit.h"
