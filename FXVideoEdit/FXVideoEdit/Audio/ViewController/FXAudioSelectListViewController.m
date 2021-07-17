//
//  FXAudioSelectListViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/1.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXAudioSelectListViewController.h"
#import "FXAlertController.h"
#import "FXAudioDataModel.h"
#import "FXAudioOperatingView.h"
#import "FXAudioSelectTableViewCell.h"
#import "FXFXAudioSelectListHeaderView.h"

static NSString *const kExportFromVideo = @"从视频提取";
static NSString *const kExportFromFile = @"从“文件”导入";
static NSString *const kExportFromApps = @"AirDrop、微信、QQ导入";

@interface FXAudioSelectListViewController () <UITableViewDataSource, UITableViewDelegate, FXAudioSelectTableViewCellDelegate, FXFXAudioSelectListHeaderViewDelegate>

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *cellDatas;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL audioListEditing;

@property (nonatomic, strong) FXAudioOperatingView *audioOperatingView;

@property (nonatomic, strong) UIView *iPhoneXBottomView;

@end

@implementation FXAudioSelectListViewController

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    {
        _cellDatas = NSMutableArray.new;
        {
            NSMutableArray *sections = NSMutableArray.new;
            [sections addObject:kExportFromVideo];
            [sections addObject:kExportFromFile];
            [sections addObject:kExportFromApps];
            [_cellDatas addObject:sections];
        }

        {
            NSMutableArray *sections = NSMutableArray.new;
            NSUInteger count = arc4random_uniform(10) + 10;
            for (NSUInteger i = 0; i < count; ++i) {
                [sections addObject:FXAudioDataModel.testObj];
            }

            [_cellDatas addObject:sections];
        }
    }

    {
        _audioListEditing = NO;
    }

    {
        _tableView = [UITableView.alloc initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.tableFooterView = UIView.new;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        Class viewClass = UITableViewCell.class;
        [_tableView registerClass:viewClass forCellReuseIdentifier:NSStringFromClass(viewClass)];
        viewClass = FXFXAudioSelectListHeaderView.class;
        [_tableView registerClass:viewClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(viewClass)];
        [self.view addSubview:_tableView];
    }

    __weak typeof(self) weakSelf = self;
    {
        _audioOperatingView = FXAudioOperatingView.new;
        _audioOperatingView.backgroundColor = self.view.backgroundColor;
        _audioOperatingView.clickDeleteBlock = ^{
            [weakSelf p_deleteSeletedItems];
        };
        _audioOperatingView.clickShareBlock = ^{
            [weakSelf p_shareSeletedItems];
        };
        _audioOperatingView.hidden = YES;
        [self.view addSubview:_audioOperatingView];
        [_audioOperatingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.audioOperatingView.superview);
            make.bottom.equalTo(weakSelf.audioOperatingView.superview.mas_bottomMargin);
            make.height.mas_equalTo(90);
        }];
    }

    {
        _iPhoneXBottomView = UIView.new;
        _iPhoneXBottomView.hidden = YES;
        _iPhoneXBottomView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:_iPhoneXBottomView];
        [_iPhoneXBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf.iPhoneXBottomView.superview);
            make.top.equalTo(weakSelf.iPhoneXBottomView.mas_bottomMargin);
        }];
    }
}
#pragma mark -

#pragma mark <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cellDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellDatas[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = _cellDatas[indexPath.section][indexPath.row];
    if ([data isKindOfClass:NSString.class]) {
        NSString *cellData = (NSString *)data;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
        cell.textLabel.text = cellData;
        cell.textLabel.textColor = [UIColor colorWithRGBA:0x999DA4FF];
        cell.textLabel.font = [UIFont systemFontOfSize:IS_IPAD ? 22 : 16];
        cell.backgroundColor = UIColor.clearColor;
        if ([cellData isEqualToString:kExportFromVideo]) {
            cell.imageView.image = [UIImage imageNamed:@"ExportFromVideo"];
            cell.accessoryView = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"ArrowAccessory"]];
        } else if ([cellData isEqualToString:kExportFromFile]) {
            cell.imageView.image = [UIImage imageNamed:@"ExportFromFile"];
            cell.accessoryView = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"ArrowAccessory"]];
        } else if ([cellData isEqualToString:kExportFromApps]) {
            cell.imageView.image = [UIImage imageNamed:@"ExportFromApps"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"HelpAccessory"] forState:UIControlStateNormal];
            [button addBlockForControlEvents:UIControlEventTouchUpInside
                                       block:^(id _Nonnull sender) {
                                           NSLog(@"点击帮助按钮");
                                       }];
            cell.accessoryView = button;
        }

        [cell.accessoryView sizeToFit];

        return cell;
    } else if ([data isKindOfClass:FXAudioDataModel.class]) {
        FXAudioDataModel *dataModel = (FXAudioDataModel *)data;
        NSString *reuseIdentifier = [FXAudioSelectTableViewCell reuseIdentifierForAudioSelectTableViewCell:_audioListEditing];
        FXAudioSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [FXAudioSelectTableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.delegate = self;
        }
        cell.dataModel = dataModel;
        return cell;
    } else {
        return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    }
}
#pragma mark -

#pragma mark <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = _cellDatas[indexPath.section][indexPath.row];
    if ([data isKindOfClass:NSString.class]) {
        return IS_IPAD ? 67 : 48;
    } else if ([data isKindOfClass:FXAudioDataModel.class]) {
        return IS_IPAD ? 75 : 64;
    } else {
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : (IS_IPAD ? 52 : 36);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        FXFXAudioSelectListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(FXFXAudioSelectListHeaderView.class)];
        view.delegate = self;
        view.chooseAll = tableView.indexPathsForSelectedRows.count == [tableView numberOfRowsInSection:1];
        view.audioListEditing = _audioListEditing;
        return view;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = _cellDatas[indexPath.section][indexPath.row];
    if ([data isKindOfClass:NSString.class]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([data isKindOfClass:FXAudioDataModel.class]) {
        if (!_audioListEditing) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            UITableViewHeaderFooterView *headerView = [tableView headerViewForSection:1];
            if (headerView && [headerView isKindOfClass:FXFXAudioSelectListHeaderView.class]) {
                FXFXAudioSelectListHeaderView *view = (FXFXAudioSelectListHeaderView *)headerView;
                view.chooseAll = tableView.indexPathsForSelectedRows.count == [tableView numberOfRowsInSection:1];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_audioListEditing) {
        id data = _cellDatas[indexPath.section][indexPath.row];
        if ([data isKindOfClass:FXAudioDataModel.class]) {
            UITableViewHeaderFooterView *headerView = [tableView headerViewForSection:1];
            if (headerView && [headerView isKindOfClass:FXFXAudioSelectListHeaderView.class]) {
                FXFXAudioSelectListHeaderView *view = (FXFXAudioSelectListHeaderView *)headerView;
                view.chooseAll = NO;
            }
        }
    }
}
#pragma mark -

#pragma mark setter
- (void)setAudioListEditing:(BOOL)audioListEditing {
    _audioListEditing = audioListEditing;
    _tableView.tableFooterView = _audioListEditing ? [UIView.alloc initWithFrame:CGRectMake(0, 0, 0, 90)] : UIView.new;
    _iPhoneXBottomView.hidden = !_audioListEditing;
    _audioOperatingView.hidden = _iPhoneXBottomView.hidden;
    _tableView.allowsMultipleSelection = _audioListEditing;
    [_tableView reloadData];
}
#pragma mark -

#pragma mark 逻辑
- (void)p_deleteSeletedItems {
    if (_tableView.indexPathsForSelectedRows.count == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self presentViewController:[FXAlertController alertControllerWithTitle:@"提示"
                                    message:@"是否删除选中的配乐？"
                                    leftButtonTitle:@"取消"
                                    leftButtonActionBlock:^(FXAlertController *_Nonnull alertController) {
                                        [alertController dismissViewControllerAnimated:YES completion:nil];
                                    }
                                    rightButtonTitle:@"确定"
                                    rightButtonActionBlock:^(FXAlertController *_Nonnull alertController) {
                                        [alertController dismissViewControllerAnimated:YES
                                                                            completion:^{
                                                                                [weakSelf.cellDatas[1] removeObjectsInArray:[weakSelf p_selectedDatas]];
                                                                                [weakSelf.tableView reloadData];
                                                                                if (weakSelf.cellDatas[1].count == 0) {
                                                                                    weakSelf.audioListEditing = NO;
                                                                                }
                                                                            }];
                                    }]
                       animated:YES
                     completion:nil];
}

- (void)p_shareSeletedItems {
    NSLog(@"分享:%@", [self p_selectedDatas]);
}

- (NSArray<FXAudioDataModel *> *)p_selectedDatas {
    NSMutableArray<FXAudioDataModel *> *result = NSMutableArray.new;
    __weak typeof(self) weakSelf = self;
    [_tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj.section == 1) {
            [result addObject:(FXAudioDataModel *)[weakSelf.cellDatas[obj.section] objectAtIndex:obj.row]];
        }
    }];
    return result;
}

#pragma mark -

#pragma mark <FXAudioSelectTableViewCellDelegate>
- (void)clickUseButttonInAudioSelectTableViewCell:(FXAudioSelectTableViewCell *)cell {
    NSLog(@"使用:%@", cell.dataModel);
}
#pragma mark -

#pragma mark <FXFXAudioSelectListHeaderViewDelegate>
- (void)clickLeftButtonInAudioSelectListHeaderView:(FXFXAudioSelectListHeaderView *)view {
    if (!view.audioListEditing && _cellDatas[1].count == 0) {
        return;
        ;
    }
    self.audioListEditing = !view.audioListEditing;
}

- (void)clickRightButtonInAudioSelectListHeaderView:(FXFXAudioSelectListHeaderView *)view {
    if (view.chooseAll) {
        [_tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    } else {
        for (NSUInteger i = 0; i < [_tableView numberOfRowsInSection:1]; ++i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
            if (![_tableView.indexPathsForSelectedRows containsObject:indexPath]) {
                [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }

        view.chooseAll = YES;
    }
}

#pragma mark -

@end