//
//  FXTimelineManager+history.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineManager+history.h"

@implementation FXTimelineManager (history)

#pragma mark undo redo

- (void)undoOperation {
    if (![self canundo]) {
        return;
    }
    self.operationIndex--;
    NSString *preOperation = [self.historyDataArray objectOrNilAtIndex:self.operationIndex - 1];
    self.timelineDescribe = [self timelineScaleWithJson:preOperation];
}

- (void)redoOperation {
    if (![self canRedo]) {
        return;
    }
    self.operationIndex++;
    NSString *peration = [self.historyDataArray objectOrNilAtIndex:self.operationIndex - 1];
    self.timelineDescribe = [self timelineScaleWithJson:peration];
}

- (void)resetOperation {
    NSString *peration = [self.historyDataArray lastObject];
    self.timelineDescribe = [self timelineScaleWithJson:peration];
}

- (BOOL)canundo {
    if (self.operationIndex <= 1) {
        return NO;
    }
    NSString *pre = [self.historyDataArray objectOrNilAtIndex:self.operationIndex - 2];
    if (!pre) {
        return NO;
    }
    return YES;
}

- (BOOL)canRedo {
    NSString *next = [self.historyDataArray objectOrNilAtIndex:self.operationIndex];
    if (!next) {
        return NO;
    }
    return YES;
}

- (void)saveHistoryData {
    NSMutableDictionary *historyDict = [NSMutableDictionary new];
    [historyDict setObject:[self historyDataArray:self.timelineDescribe.videoArray] forKey:@"videoTrack"];
    [historyDict setObject:[self historyDataArray:self.timelineDescribe.audioArray] forKey:@"audioTrack"];
    [historyDict setObject:[self historyDataArray:self.timelineDescribe.transitionArray] forKey:@"transitionTrack"];
    [historyDict setObject:@(CMTimeGetSeconds(self.timelineDescribe.duration)).stringValue forKey:@"duration"];
    [historyDict setObject:@(self.timelineDescribe.lengthTimeScale).stringValue forKey:@"lengthTimeScale"];
    [historyDict setObject:@(self.timelineDescribe.defaultNaturalSize.width).stringValue forKey:@"defaultNaturalSizeWidth"];
    [historyDict setObject:@(self.timelineDescribe.defaultNaturalSize.height).stringValue forKey:@"defaultNaturalSizeHeight"];
    [historyDict setObject:@(self.timelineDescribe.mainVideoVolume).stringValue forKey:@"mainVideoVolume"];
    [historyDict setObject:@(self.timelineDescribe.pipVideoVolume).stringValue forKey:@"pipVideoVolume"];

    NSString *json = [historyDict jsonStringEncoded];
    NSInteger count = self.historyDataArray.count;
    if (MAX(count - 2, 0) > self.operationIndex) {
        [self.historyDataArray removeObjectsInRange:NSMakeRange(self.operationIndex + 1, self.historyDataArray.count - self.operationIndex - 1)];
    }
    self.operationIndex++;
    [self.historyDataArray addObject:json];
}

- (FXTimelineDescribe *)timelineScaleWithJson:(NSString *)jsonString {
    FXTimelineDescribe *describe = [[FXTimelineDescribe alloc] init];
    NSDictionary *dic = [jsonString jsonValueDecoded];
    CGFloat width = [dic floatValueForKey:@"defaultNaturalSizeWidth" default:0];
    CGFloat height = [dic floatValueForKey:@"defaultNaturalSizeHeight" default:0];
    describe.defaultNaturalSize = CGSizeMake(width, height);

    describe.lengthTimeScale = [dic floatValueForKey:@"lengthTimeScale" default:LENGTH_TIME_SCALE_MIN];
    describe.duration = CMTimeMakeWithSeconds([dic doubleValueForKey:@"duration" default:0], 600);
    describe.mainVideoVolume = [dic floatValueForKey:@"mainVideoVolume" default:100];
    describe.pipVideoVolume = [dic floatValueForKey:@"pipVideoVolume" default:100];

    NSArray *videoArray = dic[@"videoTrack"];
    for (NSDictionary *dic in videoArray) {
        FXVideoDescribe *video = [[FXVideoDescribe alloc] init];
        [video setObjectWithDic:dic];
        [describe.videoArray addObject:video];
    }
    NSArray *audioArray = dic[@"audioTrack"];
    for (NSDictionary *dic in audioArray) {
        FXAudioDescribe *audio = [[FXAudioDescribe alloc] init];
        [audio setObjectWithDic:dic];
        [describe.audioArray addObject:audio];
    }
    NSArray *transArray = dic[@"transitionTrack"];
    for (NSDictionary *dic in transArray) {
        FXTransitionDescribe *trans = [[FXTransitionDescribe alloc] init];
        [trans setObjectWithDic:dic];
        [describe.transitionArray addObject:trans];
    }
    return describe;
}

- (NSArray *)historyDataArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray new];
    for (FXDescribe *describe in array) {
        NSDictionary *dic = [describe objectDictionary];
        [tempArray addObject:dic];
    }
    return tempArray;
}

@end
