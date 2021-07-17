//
//  NSString+FXExpand.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FXExpand)

+ (NSString *)fx_stringWithVideoDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END