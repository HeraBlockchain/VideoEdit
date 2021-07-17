//
//  FXTimelineManager.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/6.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager.h"

@interface FXTimelineManager ()

@end

@implementation FXTimelineManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _historyDataArray = [NSMutableArray new];
        _videoSourceArray = [NSMutableArray new];
        _audioSourceArray = [NSMutableArray new];
        _operationIndex = 0;
        _currentTime = kCMTimeZero;
        _timelineDescribe = [[FXTimelineDescribe alloc] init];
        _recordAudioArray = [NSMutableArray new];
        _startTime = kCMTimeInvalid;
    }
    return self;
}

- (void)clearAllData {
    [_historyDataArray removeAllObjects];
    _operationIndex = 0;
    [_videoSourceArray removeAllObjects];
    [_audioSourceArray removeAllObjects];
    _timelineDescribe = [[FXTimelineDescribe alloc] init];
}



@end
