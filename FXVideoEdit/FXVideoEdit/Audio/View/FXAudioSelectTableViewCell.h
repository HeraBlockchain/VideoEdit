//
//  FXAudioSelectTableViewCell.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioDataModel.h"
#import <UIKit/UIKit.h>
@class FXAudioSelectTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol FXAudioSelectTableViewCellDelegate <NSObject>

- (void)clickUseButttonInAudioSelectTableViewCell:(FXAudioSelectTableViewCell *)cell;

@end

@interface FXAudioSelectTableViewCell : UITableViewCell

@property (nonatomic, strong, nullable) FXAudioDataModel *dataModel;

@property (nonatomic, weak, nullable) id<FXAudioSelectTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifierForAudioSelectTableViewCell:(BOOL)editing;

@end

NS_ASSUME_NONNULL_END