//
//  FXAudioDataModel.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioDataModel.h"

@implementation FXAudioDataModel

+ (FXAudioDataModel *)testObj {
    FXAudioDataModel *dataModel = FXAudioDataModel.new;
    dataModel.name = [NSString stringWithFormat:@"name-%@", @(arc4random())];
    dataModel.author = arc4random() % 3 != 0 ? [NSString stringWithFormat:@"author-%@", @(arc4random_uniform(100))] : nil;
    dataModel.duration = arc4random_uniform(60 * 60) + 10;
    return dataModel;
}

@end