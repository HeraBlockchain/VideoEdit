//
//  FXTitleDescribe.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/15.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTitleDescribe.h"
#import "FXFontManager.h"

@implementation FXTitleDescribe

- (instancetype)init {
    self = [super init];
    if (self) {
        self.desType = FXDescribeTypeTitle;
        self.duration = CMTimeMake(1800, 600);
        _rotateAngle = 0;
        _widthPercent = 0.5;
        _widthHeightPercent = 2;
        _centerXP = 0.5;
        _centerYP = 0.5;
    }
    return self;
}

- (UIFont *)titleFont
{
    UIFont *font = [[FXFontManager shareFontManager] fontWithName:@"dd"];
    font = [font fontWithSize:100];
    return font;
}


- (NSDictionary *)objectDictionary {
    NSDictionary *dic = [super objectDictionary];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:@(_titleIndex).stringValue forKey:@"titleIndex"];
    [dictionary setObject:@(_rotateAngle).stringValue forKey:@"_rotateAngle"];
    [dictionary setObject:@(_centerXP).stringValue forKey:@"centerXP"];
    [dictionary setObject:@(_centerYP).stringValue forKey:@"centerYP"];
    [dictionary setObject:@(_widthPercent).stringValue forKey:@"widthPercent"];
    [dictionary setObject:@(_widthHeightPercent).stringValue forKey:@"widthHeightPercent"];
    return dictionary;
}

- (void)setObjectWithDic:(NSDictionary *)dic {
    [super setObjectWithDic:dic];
    _titleIndex = [dic integerValueForKey:@"titleIndex" default:0];
    _rotateAngle = [dic floatValueForKey:@"rotateAngle" default:0];
    _centerXP = [dic floatValueForKey:@"centerXP" default:0.5];
    _centerYP = [dic floatValueForKey:@"centerYP" default:0.5];
    _widthPercent = [dic floatValueForKey:@"widthPercent" default:0.5];
    _widthHeightPercent = [dic floatValueForKey:@"widthHeightPercent" default:0.5];
}


@end
