//
//  FXAVAppendVideoCommand.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/20.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAVCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXAVAppendVideoCommand : FXAVCommand

- (void)performWithAsset:(AVAsset *)asset appendAsset:(AVAsset *)appendAsset;

@end

NS_ASSUME_NONNULL_END