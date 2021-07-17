//
//  FXFontManager.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/11.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXFontManager.h"

@interface FXFontManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, UIFont *> *cahce;

@end

@implementation FXFontManager

#pragma mark 对外
+ (FXFontManager *)shareFontManager {
    static FXFontManager *shareFontManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareFontManager = FXFontManager.new;
    });

    return shareFontManager;
}

- (UIFont *)fontWithName:(NSString *)fontName {
    UIFont *font = _cahce[fontName];
    if (!font) {
        NSURL *url = [NSBundle.mainBundle URLForResource:fontName withExtension:@"ttf"];
        if (!url) {
            url = [NSBundle.mainBundle URLForResource:fontName withExtension:@"otf"];
        }
        if (url) {
            font = [UIFont loadFontFromData:[NSData.alloc initWithContentsOfURL:url]];
        } else {
            font = [UIFont systemFontOfSize:IS_IPAD ? 18 : 12];
        }

        _cahce[fontName] = font;
    }

    return font;
}

#pragma mark -

#pragma mark NSObject
- (instancetype)init {
    self = [super init];
    if (self) {
        _cahce = NSMutableDictionary.dictionary;
        _fontNames = @[
            @"默认",
            @"方正仿宋",
            @"方正黑体",
            @"方正楷体",
            @"方正书宋",
            @"沐瑶软笔",
            @"意大利体",
            @"手写英文",
            @"小白体",
            @"正锐黑体",
            @"手书体",
            @"高端黑",
            @"站酷酷黑",
            @"快乐体",
            @"黄油体",
            @"文艺体",
            @"LOGO体",
        ];
    }

    return self;
}
#pragma mark -

@end