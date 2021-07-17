//
//  FXTitleInputView.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/9/15.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTitleInputView.h"
#import "HFDraggableView.h"
#import "FXPlayerViewController.h"
#import "FXTitleDescribe.h"
#import "FXTimelineManager.h"

@interface FXTitleInputView () <UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, assign) CGFloat keyboldH;
@property (nonatomic, strong) HFDraggableView *draggableView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) FXPlayerViewController *holdViewController;
@property (nonatomic, strong) FXTitleDescribe *titleDescribe;
@end


@implementation FXTitleInputView

- (instancetype)initWithDraggableView:(HFDraggableView *)dragView
                        titleDescribe:(FXTitleDescribe *)titleDescribe
{
    self = [super init];
    if (self) {
        _draggableView = dragView;
        _titleDescribe = titleDescribe;
    }
    return self;
}

- (void)setHoldViewController:(FXPlayerViewController *)holdViewController;
{
    _holdViewController = holdViewController;
    CGRect rect = holdViewController.playbackView.frame;
    CGFloat width = rect.size.width * 0.5;
    CGFloat height = width/2;
    CGFloat originalX = rect.size.width * 0.5 - width/2;
    CGFloat originalY = rect.size.height * 0.5 - height/2;
    CGRect dragRect = CGRectMake(originalX, originalY, width, height);
    
    _draggableView = [[HFDraggableView alloc] initWithFrame:dragRect];
    _draggableView.freeSize = YES;
    _draggableView.angle = 0;
    _draggableView.superRect = rect;
    [holdViewController.playbackView addSubview:_draggableView];
}

- (void)editComplete
{
    CGRect bounds = _draggableView.bounds;
    CGPoint center = _draggableView.center;
    CGRect holdRect = _holdViewController.playbackView.frame;
    Float64 totalTime = CMTimeGetSeconds([FXTimelineManager sharedInstance].timelineDescribe.duration);
    CMTime startTime = CMTimeMakeWithSeconds(totalTime*_currentPercent, 600);
    
    if (_titleDescribe) {
        _titleDescribe.text = _draggableView.textlabel.text;
        _titleDescribe.startTime = startTime;
        _titleDescribe.duration = CMTimeMake(1800, 600);
        _titleDescribe.centerXP = center.x / holdRect.size.width;
        _titleDescribe.centerYP = center.y / holdRect.size.height;
        _titleDescribe.widthPercent = bounds.size.width/holdRect.size.width;
        _titleDescribe.widthHeightPercent = bounds.size.width/bounds.size.height;
        _titleDescribe.rotateAngle = _draggableView.angle;
    }
    else{
        _titleDescribe = [FXTitleDescribe new];
        _titleDescribe.text = _draggableView.textlabel.text;
        _titleDescribe.startTime = startTime;
        _titleDescribe.duration = CMTimeMake(1800, 600);
        _titleDescribe.centerXP = center.x / holdRect.size.width;
        _titleDescribe.centerYP = center.y / holdRect.size.height;
        _titleDescribe.widthPercent = bounds.size.width/holdRect.size.width;
        _titleDescribe.widthHeightPercent = bounds.size.width/bounds.size.height;
        _titleDescribe.rotateAngle = _draggableView.angle;
        [[FXTimelineManager sharedInstance] addTitleWithTitle:_titleDescribe];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRebuildTimelineView object:nil];
        [self.draggableView removeFromSuperview];
    }
    [self inputViewHiden];
    [self removeFromSuperview];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:0.30];
        //使用NSNotificationCenter 鍵盤出現時
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillShown:)
         
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        //使用NSNotificationCenter 鍵盤隐藏時
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillBeHidden:)
         
                                                     name:UIKeyboardWillHideNotification object:nil];
        [self createView];
    }
    return self;
}
- (void)createView{
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 50)];
    [self addSubview:self.inputView];
    self.inputView.backgroundColor = [UIColor colorWithRed:0.80 green:0.82 blue:0.84 alpha:1.00];
    
    self.inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-100, 30)];
    self.inputTextView.delegate = self;
    self.inputTextView.returnKeyType = UIReturnKeyDone;
    self.inputTextView.layer.cornerRadius = 4;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.font = [UIFont systemFontOfSize:12];
    self.inputTextView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    self.inputTextView.textColor = [UIColor blackColor];
    [self.inputView addSubview:self.inputTextView];
    
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 10, 200, 10)];
    if (_titleDescribe) {
        self.placeLabel.text = _titleDescribe.text;
    }
    else{
        self.placeLabel.text = @"最多可输入30字";
    }
    self.placeLabel.textColor = [UIColor lightGrayColor];
    [self.inputTextView addSubview:self.placeLabel];
    //self.placeLabel.backgroundColor = [UIColor yellowColor];
    self.placeLabel.font = [UIFont systemFontOfSize:12];
    self.placeLabel.userInteractionEnabled = NO;
    self.placeLabel.hidden = NO;
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 10, 60, 30);
    [self.doneButton setImage:[UIImage imageNamed:@"发布"] forState:UIControlStateNormal];
    [self.inputView addSubview:self.doneButton];
    [self.doneButton addTarget:self action:@selector(editComplete) forControlEvents:UIControlEventTouchUpInside];
}
//这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"-----%@",text);
    if ([text isEqualToString:@""]) {
        //表示删除字符
    }
    
    if ([text isEqualToString:@"\n"]){
        if (self.inputTextView.text.length>0) {
            [self editComplete];
        }
        return NO;
    }else{
        NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if(new.length > 300){
            if (![text isEqualToString:@""]) {
                return NO;
            }
        }
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeLabel.hidden = NO;
    }else{
        self.placeLabel.hidden = YES;
    }
    static CGFloat maxHeight =120.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight){
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    }else{
        textView.scrollEnabled = NO;    // 不允许滚动
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.inputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.keyboldH-size.height-20, [UIScreen mainScreen].bounds.size.width, size.height+20);
        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    }];
    _draggableView.textlabel.text = textView.text;
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    self.keyboldH = kbSize.height;
    CGFloat height = 0;
    if (self.inputTextView.text == nil) {
        height = 50;
    }else{
        CGSize constraintSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT);
        CGSize size = [self.inputTextView sizeThatFits:constraintSize];
        height = size.height;
    }
    [UIView animateWithDuration:0.1 animations:^{
        if (height>=120.0f) {
            self.inputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - kbSize.height-120.0f-20, [UIScreen mainScreen].bounds.size.width, 120.0f+20);
        }else{
            self.inputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - kbSize.height-height-20, [UIScreen mainScreen].bounds.size.width, height+20);
        }
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    [UIView animateWithDuration:1 animations:^{
        self.inputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 50);
    }];
}

- (void)inputViewShow{
    [self.inputTextView becomeFirstResponder];
    
}
- (void)inputViewHiden{
    [self.inputTextView resignFirstResponder];

}
- (void)tapAction{
    [self removeFromSuperview];
    [self inputViewHiden];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view == self.inputView ) {
        return NO;
    }else{
        return YES;
    }
}

@end
