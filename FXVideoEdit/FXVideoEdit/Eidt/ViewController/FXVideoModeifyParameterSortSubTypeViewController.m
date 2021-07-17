//
//  FXFXVideoModeifyParameterEditTypeViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/3.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterSortSubTypeViewController.h"
#import "FXCustomSubTypeTitleView.h"
#import "FXVideoDescribe.h"
#import <MyLayout/MyLayout.h>
#import "FXTimelineManager.h"

@interface FXVideoModeifyParameterSortSubTypeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) FXTimelineDescribe *timelineDescribe;

@property (nonatomic, strong) MyFlowLayout *flowLayout;

@property (nonatomic, strong) MyLayoutDragger *dragger;

@property (nonatomic, strong) UIView *holdView;

@property (nonatomic, strong) NSMutableArray *deleteArray;

@end

@implementation FXVideoModeifyParameterSortSubTypeViewController

#pragma mark 对外
+ (FXVideoModeifyParameterSortSubTypeViewController *)videoModeifyParameterSortSubTypeViewControllerWithDataModel:(FXTimelineDescribe *)dataModel {
    FXVideoModeifyParameterSortSubTypeViewController *cotnroller = FXVideoModeifyParameterSortSubTypeViewController.new;
    cotnroller.timelineDescribe = dataModel;
    return cotnroller;
}
#pragma mark -

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _deleteArray = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    {
        FXCustomSubTypeTitleView *topView = FXCustomSubTypeTitleView.new;
        topView.title = @"排序";
        topView.closeButtonActionBlock = ^{
            if (weakSelf.SortDoneBlock) {
                weakSelf.SortDoneBlock(NO);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };

        topView.doneButtonActionBlock = ^{
            for (int i = 0; i < self.deleteArray.count; i++) {
                NSNumber *num = [weakSelf.deleteArray objectOrNilAtIndex:i];
                if (num) {
                    [weakSelf.timelineDescribe.videoArray removeObjectAtIndex:num.integerValue];
                }
            }
            NSInteger index = 0;
            for (UIView *subview in self.flowLayout.subviews) {
                if ([subview isKindOfClass:[UIButton class]]) {
                    NSInteger tag = subview.tag;
                    FXVideoDescribe *video = [weakSelf.timelineDescribe.videoArray objectOrNilAtIndex:tag];
                    video.videoIndex = index;
                    index++;
                }
            }
            if (weakSelf.SortDoneBlock) {
                weakSelf.SortDoneBlock(YES);
            }
            NSLog(@"点击排序确认按钮");
        };
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(topView.superview);
            make.height.mas_equalTo(FXCustomSubTypeTitleView.heightOfCustomSubTypeTitleView);
        }];
        
        _holdView = UIView.new;
        [self.view addSubview:_holdView];
        [_holdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(topView.superview);
            make.top.mas_equalTo(topView.mas_bottom);
        }];
    }

    {
        [self creatLayout];
    }
}
#pragma mark -

- (void)creatLayout {
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:6];
    self.flowLayout.backgroundColor = UIColorMake(24, 24, 24);
    self.flowLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.flowLayout.subviewSpace = 10; //流式布局里面的子视图的水平和垂直间距都设置为10
    self.flowLayout.gravity = MyGravity_Horz_Fill; //流式布局里面的子视图的宽度将平均分配。
    self.flowLayout.weight = 1; //流式布局占用线性布局里面的剩余高度。
    self.flowLayout.topPadding = 100;
    [_holdView addSubview:self.flowLayout];
    NSInteger count = _timelineDescribe.videoArray.count;
    CGFloat height = 50;
    if (count > 6 && count < 13) {
        height = 110;
    } else if (count > 12) {
        height = 170;
    }
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
        [_deleteArray addObject:@(sender.tag)];
    } else {
        sender.transform = CGAffineTransformMakeScale(1, 1);
        [self.dragger dropView:sender withEvent:event];
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

#pragma mark -

@end
