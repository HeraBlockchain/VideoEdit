//
//  FXTitleCoverView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/16.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTitleCoverView.h"
#import "FXTimelineItemViewModel.h"

@interface FXTitleCoverView ()

@property (nonatomic, strong) FXTimeLineTitleModel *currentTitleModel;

@property (nonatomic, assign) BOOL selectState;

@end


@implementation FXTitleCoverView

- (instancetype)initWithModel:(FXTimeLineTitleModel *)titleModel
{
    CGRect frame = CGRectMake(titleModel.position, 0, titleModel.width, 50);
    self = [super initWithFrame:frame];
    if (self) {
        self.currentTitleModel = titleModel;
        self.backgroundColor =[UIColor colorWithRed:245 green:65 blue:132 alpha:0.7];
        __weak typeof(self) weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            weakSelf.selectState = !weakSelf.selectState;
            [weakSelf coverViewSelected:weakSelf.selectState];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationTitleCoverViewSelected object:nil userInfo:@{@"titleModel":titleModel}];
        }];
        [self addGestureRecognizer:tap];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleViewSelectNotification:) name:KNotificationTitleCoverViewSelected object:nil];
    return self;
}

- (void)titleViewSelectNotification:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    FXTimeLineTitleModel *titleModel = dic[@"titleModel"];
    if (titleModel == _currentTitleModel) {
        return;
    }
    else{
        if (_currentTitleModel.titleDescribe == titleModel.titleDescribe) {
            _selectState = YES;
            [self coverViewSelected:_selectState];
        }
        else{
            if (_selectState) {
                _selectState = NO;
                [self coverViewSelected:_selectState];
            }
        }
    }
}


- (void)coverViewSelected:(BOOL)select
{
    if (select) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
    }
    else{
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
    }
}

@end
