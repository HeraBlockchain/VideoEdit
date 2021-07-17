//
//  FXAddTransitionView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/26.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAddTransitionView.h"
#import <MyLayout/MyLayout.h>

@interface FXAddTransitionView ()

@property (weak, nonatomic) IBOutlet UIView *holdView;

@property (nonatomic, strong) MyFlowLayout *flowLayout;

@end

@implementation FXAddTransitionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FXAddTransitionView" owner:self options:nil];
        self = array.firstObject;
        [self creatLayout];
    }
    return self;
}

- (void)creatLayout {
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:5];
    self.flowLayout.backgroundColor = UIColorMake(24, 24, 24);
    self.flowLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.flowLayout.subviewSpace = 10; //流式布局里面的子视图的水平和垂直间距都设置为10
    self.flowLayout.gravity = MyGravity_Horz_Fill; //流式布局里面的子视图的宽度将平均分配。
    self.flowLayout.weight = 1; //流式布局占用线性布局里面的剩余高度。
    self.flowLayout.myTop = 0;
    [_holdView addSubview:self.flowLayout];
    [self layoutIfNeeded];
    [self.flowLayout mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    for (int i = 0; i < 6; i++) {
        [self.flowLayout addSubview:[self createTagButton]];
    }
}

//创建标签按钮
- (UIButton *)createTagButton {
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:@"12f" forState:UIControlStateNormal];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:14];
    ;
    tagButton.backgroundColor = [UIColor whiteColor];
    tagButton.heightSize.equalTo(@60);
    tagButton.widthSize.equalTo(@60);
    [tagButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    return tagButton;
}

- (void)buttonClick {
    if (_buttonBlock) {
        _buttonBlock();
    }
}

- (IBAction)clickCancelButton:(id)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
}
- (IBAction)clickConfirmButton:(id)sender {
    if (_confitmBlock) {
        _confitmBlock();
    }
}

@end