//
//  FXTimeline.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FXTrack) {
    FXPipTrack = 0,
    FXVideoTrack,
    FXMusicTrack,
    FXRecordTrack
};

@interface FXTimeline : NSObject

@property (strong, nonatomic) NSArray *videos;

@property (strong, nonatomic) NSArray *transitions;

@property (strong, nonatomic) NSArray *titles;

@property (strong, nonatomic) NSArray *voiceOvers;

@property (strong, nonatomic) NSArray *musicItems;

@property (nonatomic, strong) UIColor *videoBackgroundColor;

@property (nonatomic, assign) int operation;

@end