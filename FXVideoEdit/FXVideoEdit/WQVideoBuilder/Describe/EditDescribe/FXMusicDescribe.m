//
//  FXMusicDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXMusicDescribe.h"
#import "FXTimelineManager.h"

@implementation FXMusicDescribe

- (instancetype)init
{
    self = [super init];
    if (self) {
        _volume = 1.0;
        self.desType = FXDescribeTypeMusic;
    }
    return self;
}

- (NSDictionary *)objectDictionary {
    NSDictionary *dic = [super objectDictionary];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:@(_musicIndex).stringValue forKey:@"musicIndex"];
    [dictionary setObject:_audioItem.urlString forKey:@"audioItem"];
    [dictionary setObject:@(_volume) forKey:@"volume"];
    return dictionary;
}

- (void)setObjectWithDic:(NSDictionary *)dic {
    [super setObjectWithDic:dic];
    _musicIndex = [dic integerValueForKey:@"musicIndex" default:0];
    NSString *urlString = [dic stringValueForKey:@"audioItem" default:nil];
    _audioItem = (FXAudioItem *)[[FXTimelineManager sharedInstance] sourceItemWithtype:self.desType sourceUrl:urlString];
    _volume = [dic floatValueForKey:@"volume" default:1.0];
}

@end
