//
//  FXAudioDataModel.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXAudioDataModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, assign) NSTimeInterval duration;

+ (FXAudioDataModel *)testObj;

@end

NS_ASSUME_NONNULL_END