//
//  FXVolumeChangeViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FXVolumeChangeType) {
    FXMainVolumeChangeType,
    FXPIPVolumeChangeType,
    FXDubbingVolumeChangeType,
    FXSoundtrackVolumeChangeType,
};

@interface FXVolumeChangeViewController : FXViewController <UIPopoverPresentationControllerDelegate>

@property (nonatomic, copy) void (^volumeChangeBlock)(FXVolumeChangeType type, CGFloat volume);

@end

NS_ASSUME_NONNULL_END