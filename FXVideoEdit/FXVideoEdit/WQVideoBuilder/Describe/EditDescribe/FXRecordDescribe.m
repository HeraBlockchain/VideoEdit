//
//  FXRecordDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXRecordDescribe.h"
#import "FXTimelineManager.h"

@implementation FXRecordDescribe

- (instancetype)init
{
    self = [super init];
    if (self) {
        _volume = 1.0;
        self.desType = FXDescribeTypeRecord;
    }
    return self;
}

- (NSDictionary *)objectDictionary {
    NSDictionary *dic = [super objectDictionary];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:@(_recordIndex).stringValue forKey:@"recordIndex"];
    [dictionary setObject:_audioItem.urlString forKey:@"audioItem"];
    [dictionary setObject:@(_volume) forKey:@"volume"];
    return dictionary;
}

- (void)setObjectWithDic:(NSDictionary *)dic {
    [super setObjectWithDic:dic];
    _recordIndex = [dic integerValueForKey:@"recordIndex" default:0];
    NSString *urlString = [dic stringValueForKey:@"audioItem" default:nil];
    _audioItem = (FXAudioItem *)[[FXTimelineManager sharedInstance] sourceItemWithtype:self.desType sourceUrl:urlString];
    _volume = [dic floatValueForKey:@"volume" default:1.0];
}


@end
