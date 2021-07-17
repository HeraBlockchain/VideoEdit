//
//  FXAVComposition.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVComposition.h"

@implementation FXAVComposition

- (NSMutableArray<AVMutableAudioMixInputParameters *> *)audioMixParams {
    if (!_audioMixParams) {
        _audioMixParams = [NSMutableArray array];
    }
    return _audioMixParams;
}

- (NSMutableArray<AVMutableVideoCompositionInstruction *> *)instructions {
    if (!_instructions) {
        _instructions = [NSMutableArray array];
    }
    return _instructions;
}

@end