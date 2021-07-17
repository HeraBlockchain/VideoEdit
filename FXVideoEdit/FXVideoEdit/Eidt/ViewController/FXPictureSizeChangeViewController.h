//
//  FXPictureSizeChangeViewController.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimelineDescribe.h"
#import "FXViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface FXPictureSizeChangeViewController : FXViewController <UIPopoverPresentationControllerDelegate>

@property (nonatomic, copy, nullable) void (^choosePictureSizeBlock)(FXPictureSize pictureSize);

@end

NS_ASSUME_NONNULL_END