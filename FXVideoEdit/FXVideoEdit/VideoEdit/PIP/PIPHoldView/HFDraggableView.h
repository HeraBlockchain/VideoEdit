//
//  HFDraggableView.h
//  HFDraggableView
//
//  Created by Henry on 08/11/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HFDraggableView;

@protocol HFDraggableViewDelegate <NSObject>

- (void)draggableViewChangeFinish:(HFDraggableView *)draggableView;

- (void)draggableViewTapAgain:(HFDraggableView *)draggableView;

@end

@interface HFDraggableView : UIView

@property (nonatomic, weak) id<HFDraggableViewDelegate> delegate;

@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign) CGRect superRect;

@property (nonatomic, assign) BOOL freeSize;

@property (nonatomic, strong) UILabel *textlabel;

+ (void)setActiveView:(HFDraggableView *)view;

- (void)setActive:(BOOL)active;

@end
