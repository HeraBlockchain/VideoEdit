//
//  FXAudioDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/5.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioDescribe.h"
#import "FXTimelineManager.h"

@implementation FXAudioDescribe

- (instancetype)init {
    self = [super init];
    if (self) {
        self.desType = FXDescribeTypeAudio;
        self.volume = 1.0;
    }
    return self;
}

- (NSDictionary *)objectDictionary {
    NSDictionary *dic = [super objectDictionary];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:@(_reverse).stringValue forKey:@"reverse"];
    [dictionary setObject:@(_audioIndex).stringValue forKey:@"audioIndex"];
    [dictionary setObject:_audioItem.urlString forKey:@"audioItem"];
    [dictionary setObject:@(_volume) forKey:@"volume"];
    return dictionary;
}

- (void)setObjectWithDic:(NSDictionary *)dic {
    [super setObjectWithDic:dic];
    _audioIndex = [dic integerValueForKey:@"audioIndex" default:0];
    _reverse = [dic boolValueForKey:@"reverse" default:NO];
    NSString *urlString = [dic stringValueForKey:@"audioItem" default:nil];
    _audioItem = (FXAudioItem *)[[FXTimelineManager sharedInstance] sourceItemWithtype:self.desType sourceUrl:urlString];
    _volume = [dic floatValueForKey:@"volume" default:1.0];
}

@end
