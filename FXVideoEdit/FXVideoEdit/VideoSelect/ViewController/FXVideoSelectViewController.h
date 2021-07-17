//
//  FXVideoSelectViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXViewController.h"
@class AVAsset;
NS_ASSUME_NONNULL_BEGIN

@interface FXVideoSelectViewController : FXViewController

+ (FXVideoSelectViewController *)videoSelectViewControllerWithAllowMaxSelectedNumber:(NSUInteger)allowMaxSelectedNumber nextBlock:(void (^)(NSArray<AVAsset *> *avassets))nextBlock;

@end

NS_ASSUME_NONNULL_END
