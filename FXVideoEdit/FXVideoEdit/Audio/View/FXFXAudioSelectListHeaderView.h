//
//  FXFXAudioSelectListHeaderView.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXFXAudioSelectListHeaderView;

NS_ASSUME_NONNULL_BEGIN

@protocol FXFXAudioSelectListHeaderViewDelegate <NSObject>

- (void)clickLeftButtonInAudioSelectListHeaderView:(FXFXAudioSelectListHeaderView *)view;
- (void)clickRightButtonInAudioSelectListHeaderView:(FXFXAudioSelectListHeaderView *)view;

@end

@interface FXFXAudioSelectListHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak, nullable) id<FXFXAudioSelectListHeaderViewDelegate> delegate;

@property (nonatomic, assign) BOOL audioListEditing;

@property (nonatomic, assign) BOOL chooseAll;

@end

NS_ASSUME_NONNULL_END