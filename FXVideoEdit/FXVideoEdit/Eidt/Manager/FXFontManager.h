//
//  FXFontManager.h
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/11.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FXFontManager : NSObject

@property (nonatomic, copy, readonly) NSArray<NSString *> *fontNames;

+ (FXFontManager *)shareFontManager;

- (UIFont *)fontWithName:(NSString *)fontName;

@end

NS_ASSUME_NONNULL_END