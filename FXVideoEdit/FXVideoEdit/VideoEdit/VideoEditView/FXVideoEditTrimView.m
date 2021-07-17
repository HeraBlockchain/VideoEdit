//
//  FXVideoTrimView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/19.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoEditTrimView.h"

@interface FXVideoEditTrimView ()

@end

@implementation FXVideoEditTrimView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FXVideoEditTrimView" owner:self options:nil];
        self = array.firstObject;
    }
    return self;
}

@end