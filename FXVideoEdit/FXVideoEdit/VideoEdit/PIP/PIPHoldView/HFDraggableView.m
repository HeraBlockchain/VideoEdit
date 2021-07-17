//
//  HFDraggableView.m
//  HFDraggableView
//
//  Created by Henry on 08/11/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

#import "HFDraggableView.h"
#import "HFDragHandle.h"
#import "UIView+HFFoundation.h"
#import "FXFontManager.h"

static const CGFloat kHandleWH = 20;
static const CGFloat kRotateHandleDistance = 40;

@implementation HFDraggableView {
    UIImageView *_tlZoomHandle;
    UIImageView *_trZoomHandle;
    UIImageView *_brZoomHandle;
    UIPanGestureRecognizer *_panOnView;

    CGPoint _initialPoint;
    CGFloat _initialAngle;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    _tlZoomHandle = [self createZoomHandle];
    _tlZoomHandle.image = [UIImage imageNamed:@"PIP旋转"];
    
    _trZoomHandle = [self createZoomHandle];
    _trZoomHandle.image = [UIImage imageNamed:@"PIP删除"];

    _brZoomHandle = [self createZoomHandle];
    _brZoomHandle.image = [UIImage imageNamed:@"PIP缩放"];


    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)]];
    _panOnView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanView:)];
    _panOnView.enabled = NO;
    [self addGestureRecognizer:_panOnView];

    self.layer.borderColor = [[UIColor blackColor] CGColor];

    [self setActive:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textlabelChangeNotification:) name:KNotificationTitleEditDetail object:nil];
    return self;
}

- (void)textlabelChangeNotification:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    if ([dic containsObjectForKey:@"font"]) {
        NSString *fontName = [dic objectForKey:@"font"];
        UIFont *font = [[FXFontManager shareFontManager] fontWithName:fontName];
        _textlabel.font = [font fontWithSize:100];
    }
    else if ([dic containsObjectForKey:@"color"]) {
        UIColor *color = [dic objectForKey:@"color"];
        _textlabel.textColor = color;
    }
    else if ([dic containsObjectForKey:@"alpha"]) {
        CGFloat alpha = [dic floatValueForKey:@"alpha" default:1.0];
        _textlabel.alpha = alpha;
    }
}


- (void)setFreeSize:(BOOL)freeSize
{
    _freeSize = freeSize;
    if (freeSize) {
        if (!_textlabel) {
            _textlabel = [UILabel new];
            _textlabel.textColor = UIColor.whiteColor;
            _textlabel.numberOfLines = 0;
            _textlabel.font = [UIFont systemFontOfSize:100];
            _textlabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_textlabel];
            _textlabel.text = @"输入文字";
            _textlabel.adjustsFontSizeToFitWidth = YES;
            [_textlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
        }
    }
}

- (void)didMoveToSuperview {
    [_tlZoomHandle removeFromSuperview];
    [_trZoomHandle removeFromSuperview];
    [_brZoomHandle removeFromSuperview];

    [self.superview addSubview:_tlZoomHandle];
    [self.superview addSubview:_trZoomHandle];
    [self.superview addSubview:_brZoomHandle];
    self.transform = CGAffineTransformMakeRotation(self.angle);
}

#pragma mark - public M
+ (void)setActiveView:(HFDraggableView *)view {
    static HFDraggableView *activeView = nil;
    if (![view isEqual:activeView]) {
        [activeView setActive:NO];
        activeView = view;
        [activeView setActive:YES];
    }
    else{
        if (activeView.delegate && [activeView.delegate respondsToSelector:@selector(draggableViewTapAgain:)]) {
            [activeView.delegate draggableViewTapAgain:view];
        }
    }
}

#pragma mark - event
- (void)didTapView:(UITapGestureRecognizer *)tap {
    [[self class] setActiveView:self];
}

- (void)didPanView:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:self.superview];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
    NSLog(@"center:%f  %f",self.center.x,self.center.y);
    [self refreshHandles];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (_delegate && [_delegate respondsToSelector:@selector(draggableViewChangeFinish:)]) {
            [_delegate draggableViewChangeFinish:self];
        }
    }
}

- (void)didPanZoomHandle:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self];
    UIView *targetView = pan.view;

    if ([targetView isEqual:_tlZoomHandle]) {
        [self didPanRotateHandle:pan];
        return;
    } else if ([targetView isEqual:_brZoomHandle]) {
        if (pan.state == UIGestureRecognizerStateBegan) {
            [self hf_setAnchorPoint:CGPointMake(0, 0)];
        }
        if (_freeSize) {
            CGRect bounds = self.bounds;
            bounds.size.width = MAX(bounds.size.width + translation.x, kHandleWH);
            bounds.size.height = MAX(bounds.size.height + translation.y, kHandleWH);
            self.bounds = bounds;
        }
        else{
            CGPoint location = [pan locationInView:self];
            CGRect bounds = self.bounds;
            CGFloat per = bounds.size.height/bounds.size.width;
            bounds.size.width = MAX(bounds.size.width + translation.x, kHandleWH);
            bounds.size.height = bounds.size.width * per;
            self.bounds = bounds;
        }
    } else if ([targetView isEqual:_trZoomHandle]) {
        if (pan.state == UIGestureRecognizerStateBegan) {
            [self hf_setAnchorPoint:CGPointMake(0, 1)];
        }
        CGRect bounds = self.bounds;
        bounds.size.width = MAX(bounds.size.width + translation.x, kHandleWH);
        bounds.size.height = MAX(bounds.size.height - translation.y, kHandleWH);
        self.bounds = bounds;
    }

    [pan setTranslation:CGPointZero inView:self];
    [self refreshHandles];
    [self refreshRoateLine];
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self hf_setAnchorPoint:CGPointMake(0.5, 0.5)];
        if (_delegate && [_delegate respondsToSelector:@selector(draggableViewChangeFinish:)]) {
            [_delegate draggableViewChangeFinish:self];
        }
    }
}

- (void)didPanRotateHandle:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:pan.view.superview];

    if (pan.state == UIGestureRecognizerStateBegan) {
        _initialPoint = pan.view.center;
        _initialAngle = self.angle;
    }

    CGFloat startAngle = atan2(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
    CGFloat endAngle = atan2(point.x - self.center.x, point.y - self.center.y);

    _initialAngle += (startAngle - endAngle);
    _initialPoint = point;

    if (fabs(fmodf(_initialAngle, M_PI_2)) < M_PI / 90) {
        self.transform = CGAffineTransformMakeRotation((int)(_initialAngle / M_PI_2) * M_PI_2);
        self.angle = (int)(_initialAngle / M_PI_2) * M_PI_2;
    } else {
        self.transform = CGAffineTransformMakeRotation(_initialAngle);
        self.angle = _initialAngle;
    }

    [self refreshHandles];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (_delegate && [_delegate respondsToSelector:@selector(draggableViewChangeFinish:)]) {
            [_delegate draggableViewChangeFinish:self];
        }
    }
}

#pragma mark - private M
- (UIImageView *)createZoomHandle {
    UIImageView *handle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHandleWH, kHandleWH)];
    handle.userInteractionEnabled = YES;
    [handle addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(didPanZoomHandle:)]];
    handle.hidden = YES;
    return handle;
}

- (CAShapeLayer *)createRotateLine {
    CAShapeLayer *rotateLine = [CAShapeLayer layer];
    rotateLine.opacity = 0.0;
    return rotateLine;
}

- (void)refreshHandles {
    [self layoutIfNeeded];
    _tlZoomHandle.center = [self hf_topLeftVertex];
    _trZoomHandle.center = [self hf_topRightVertex];
    _brZoomHandle.center = [self hf_bottomRightVertex];
}

- (void)refreshRoateLine {
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    [linePath moveToPoint:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    [linePath addLineToPoint:CGPointMake(self.bounds.size.width / 2, -kRotateHandleDistance)];
}

- (CGPoint)rotateHandleCenter {
    CGRect frame = self.hf_frame;
    CGPoint point = frame.origin;

    // origin center
    point.x += frame.size.width / 2;
    point.y -= kRotateHandleDistance;

    // transformed center
    point.x -= self.center.x;
    point.y -= self.center.y;
    point = CGPointApplyAffineTransform(point, self.transform);
    point.x += self.center.x;
    point.y += self.center.y;

    return point;
}

#pragma mark - accessor

- (void)setActive:(BOOL)active {
    if (active) {
        [self refreshHandles];
        [self refreshRoateLine];
    }
    self.layer.borderWidth = active ? 1 : 0;
    _panOnView.enabled = active;

    _tlZoomHandle.hidden = !active;
    _brZoomHandle.hidden = !active;
    _trZoomHandle.hidden = !active;

}

@end
