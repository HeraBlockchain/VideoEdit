//
//  FXVideoRankView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/12.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoRankView.h"
#import "FXTimelineDescribe.h"
#import "FXVideoDescribe.h"
#import <MyLayout/MyLayout.h>

@interface FXVideoRankView ()

@property (weak, nonatomic) IBOutlet UIView *holdView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdViewHeightConstraint;

@property (nonatomic, strong) MyFlowLayout *flowLayout;

@property (nonatomic, strong) MyLayoutDragger *dragger;

@end

@implementation FXVideoRankView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FXVideoRankView" owner:self options:nil];
        self = array.firstObject;
    }
    return self;
}

- (void)setTimelineDescribe:(FXTimelineDescribe *)timelineDescribe {
    _timelineDescribe = timelineDescribe;
    [_holdView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self creatLayout];
}

- (void)creatLayout {
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:6];
    self.flowLayout.backgroundColor = UIColorMake(24, 24, 24);
    self.flowLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.flowLayout.subviewSpace = 10; //流式布局里面的子视图的水平和垂直间距都设置为10
    self.flowLayout.gravity = MyGravity_Horz_Fill; //流式布局里面的子视图的宽度将平均分配。
    self.flowLayout.weight = 1; //流式布局占用线性布局里面的剩余高度。
    self.flowLayout.myTop = 0;
    [_holdView addSubview:self.flowLayout];
    NSInteger count = _timelineDescribe.videoArray.count;
    CGFloat height = 50;
    if (count > 6 && count < 13) {
        height = 110;
    } else if (count > 12) {
        height = 170;
    }
    _holdViewHeightConstraint.constant = height;
    [self layoutIfNeeded];

    [self.flowLayout mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    NSInteger tagIndex = 0;
    for (FXVideoDescribe *videoDes in _timelineDescribe.videoArray) {
        UIButton *button = [self createTagButton:videoDes];
        button.tag = tagIndex;
        [self.flowLayout addSubview:button];
        tagIndex++;
    }
    //创建一个布局拖动器。
    self.dragger = [self.flowLayout createLayoutDragger];
    self.dragger.animateDuration = 0.2;
}

- (void)refreshVideoCoverSubView {
    NSInteger tagIndex = 0;
    for (UIView *view in self.flowLayout.subviews) {
        view.tag = tagIndex;
        tagIndex++;
    }
}

//创建标签按钮
- (UIButton *)createTagButton:(FXVideoDescribe *)videoDes {
    UIButton *tagButton = [UIButton new];
    [tagButton setBackgroundImage:[videoDes coverImage] forState:UIControlStateNormal];
    Float64 time = CMTimeGetSeconds(videoDes.duration);
    [tagButton setTitle:[NSString stringWithFormat:@"%.02f", time] forState:UIControlStateNormal];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:14];
    ;
    tagButton.backgroundColor = [UIColor whiteColor];
    tagButton.heightSize.equalTo(@50);
    tagButton.widthSize.equalTo(@50);

    [tagButton addTarget:self action:@selector(handleTouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside]; //注册拖动事件。
    [tagButton addTarget:self action:@selector(handleTouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragOutside]; //注册外面拖动事件。
    [tagButton addTarget:self action:@selector(handleTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown]; //注册按下事件
    [tagButton addTarget:self action:@selector(handleTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside]; //注册抬起事件
    [tagButton addTarget:self action:@selector(handleTouchUp:withEvent:) forControlEvents:UIControlEventTouchCancel]; //注册终止事件
    [tagButton addTarget:self action:@selector(handleTouchDownRepeat:withEvent:) forControlEvents:UIControlEventTouchDownRepeat]; //注册多次点击事件

    return tagButton;
}

#pragma mark-- Handle Method

- (IBAction)handleTouchDown:(UIButton *)sender withEvent:(UIEvent *)event {
    //拖动子视图开始处理。
    sender.transform = CGAffineTransformMakeScale(1.4, 1.4);
    [self.dragger dragView:sender withEvent:event];
}

- (IBAction)handleTouchUp:(UIButton *)sender withEvent:(UIEvent *)event {
    //停止子视图拖动处理。
    if (CGRectGetMidY(sender.frame) < 0) {
        [sender removeFromSuperview];
        [self.flowLayout layoutAnimationWithDuration:0.2];
        if (_deleteBlock) {
            _deleteBlock(sender.tag);
        }
    } else {
        sender.transform = CGAffineTransformMakeScale(1, 1);
        [self.dragger dropView:sender withEvent:event];
        if (_stepBlock) {
            _stepBlock(sender.tag, self.dragger.currentIndex);
            [self refreshVideoCoverSubView];
        }
    }
}

- (IBAction)handleTouchDrag:(UIButton *)sender withEvent:(UIEvent *)event {
    //子视图拖动中处理。
    [self.dragger dragginView:sender withEvent:event];
}

- (IBAction)handleTouchDownRepeat:(UIButton *)sender withEvent:(UIEvent *)event {
    [sender removeFromSuperview];
    [self.flowLayout layoutAnimationWithDuration:0.2];
}

- (IBAction)clickCancelButton:(id)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (IBAction)clickConfirmButton:(id)sender {
    if (_confirmSortBlock) {
        _confirmSortBlock();
    }
}

@end