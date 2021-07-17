//
//  FXTransitionCollectionViewCell.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTransitionCollectionViewCell.h"

@implementation FXTransitionCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _button = [[FXTransitionButton alloc] init];
    [self.contentView addSubview:_button];
    [_button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end