//
//  FXTransitionButton.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTransitionButton.h"

@implementation FXTransitionButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _transitionType = kTransitionTypeNone;
    self.userInteractionEnabled = NO;
    [self updateBackgroundImage];
}

- (void)updateBackgroundImage {
    [self setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
}

@end