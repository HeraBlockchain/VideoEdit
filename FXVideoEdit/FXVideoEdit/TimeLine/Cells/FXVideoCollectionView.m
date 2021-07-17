//
//  FXVideoCollectionView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/26.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoCollectionView.h"

@implementation FXVideoCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherRecognizer {
    return YES;
}

@end