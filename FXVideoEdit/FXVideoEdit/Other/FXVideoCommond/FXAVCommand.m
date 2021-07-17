//
//  FXAVCommand.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVCommand.h"

@interface FXAVCommand ()

@end

@implementation FXAVCommand

- (instancetype)init {
    return [self initWithComposition:[FXAVComposition new]];
}

- (instancetype)initWithComposition:(FXAVComposition *)composition {
    self = [super init];
    if (self != nil) {
        self.composition = composition;
    }
    return self;
}

- (void)performWithAsset:(AVAsset *)asset {
    [self doesNotRecognizeSelector:_cmd];
}

NSString *const FXAVExportCommandCompletionNotification = @"FXAVExportCommandCompletionNotification";
NSString *const FXAVExportCommandError = @"FXAVExportCommandError";

@end