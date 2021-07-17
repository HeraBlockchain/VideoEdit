//
//  FXTimeLIneDataSource.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLIneDataSource.h"
#import "FXAudioItemCollectionViewCell.h"
#import "FXPipVideoItemCollectionViewCell.h"
#import "FXTimelineItemViewModel.h"
#import "FXTransitionCollectionViewCell.h"
#import "FXTransitionDescribe.h"
#import "FXVideoItem.h"
#import "FXVideoItemCollectionViewCell.h"

static NSString *const FXPipVideoItemCollectionViewCellID = @"FXPipVideoItemCollectionViewCell";

static NSString *const FXVideoItemCollectionViewCellID = @"FXVideoItemCollectionViewCell";
static NSString *const FXTransitionCollectionViewCellID = @"FXTransitionCollectionViewCell";
static NSString *const FXTitleItemCollectionViewCellID = @"FXTitleItemCollectionViewCell";
static NSString *const FXAudioItemCollectionViewCellID = @"FXAudioItemCollectionViewCell";

@interface FXTimeLIneDataSource ()

@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation FXTimeLIneDataSource

+ (id)dataSourceWithCollectionView:(UICollectionView *)collectionView {
    return [[self alloc] initWithCollectionView:collectionView];
}

- (id)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        //        for (int i = 0; i < 6; i++) {
        //            [self.controller.collectionView registerClass:[FXVideoItemCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",FXVideoItemCollectionViewCellID,i]];
        //            [self.controller.collectionView registerClass:[FXAudioItemCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",FXAudioItemCollectionViewCellID,i]];
        //            [self.controller.collectionView registerClass:[FXTransitionCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",FXTransitionCollectionViewCellID,i]];
        //        }
        [_collectionView registerClass:[FXVideoItemCollectionViewCell class] forCellWithReuseIdentifier:FXPipVideoItemCollectionViewCellID];
        [_collectionView registerClass:[FXVideoItemCollectionViewCell class] forCellWithReuseIdentifier:FXVideoItemCollectionViewCellID];
        [_collectionView registerClass:[FXAudioItemCollectionViewCell class] forCellWithReuseIdentifier:FXAudioItemCollectionViewCellID];
        [_collectionView registerClass:[FXTransitionCollectionViewCell class] forCellWithReuseIdentifier:FXTransitionCollectionViewCellID];
        [self resetTimeline];
    }
    return self;
}

- (void)clearTimeline {
    self.timelineItems = [NSMutableArray array];
}

- (void)resetTimeline {
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[NSMutableArray array]];
    [items addObject:[NSMutableArray array]];
    [items addObject:[NSMutableArray array]];
    [items addObject:[NSMutableArray array]];

    self.timelineItems = items;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.timelineItems.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.timelineItems[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [self cellIDForIndexPath:indexPath];
    //    NSString *identifier = [NSString stringWithFormat:@"%@%ld", cellID,indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if ([cellID isEqualToString:FXPipVideoItemCollectionViewCellID]) {
        [self configurePipVideoItemCell:(FXPipVideoItemCollectionViewCell *)cell withItemAtIndexPath:indexPath];
    } else if ([cellID isEqualToString:FXVideoItemCollectionViewCellID]) {
        [self configureVideoItemCell:(FXVideoItemCollectionViewCell *)cell withItemAtIndexPath:indexPath];

    } else if ([cellID isEqualToString:FXAudioItemCollectionViewCellID]) {
        [self configureAudioItemCell:(FXAudioItemCollectionViewCell *)cell withItemAtIndexPath:indexPath];

    } else if ([cellID isEqualToString:FXTransitionCollectionViewCellID]) {
        FXTransitionCollectionViewCell *transCell = (FXTransitionCollectionViewCell *)cell;
        //        FXVideoTransition *transition = self.timelineItems[indexPath.section][indexPath.row];
        //        transCell.button.transitionType = transition.type;
    } else if ([cellID isEqualToString:FXTitleItemCollectionViewCellID]) {
        //        [self configureTitleItemCell:(FXTimelineItemCell *)cell withItemAtIndexPath:indexPath];
    }
    cell.contentView.frame = cell.bounds;
    cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    return cell;
}

- (void)configurePipVideoItemCell:(FXPipVideoItemCollectionViewCell *)cell withItemAtIndexPath:(NSIndexPath *)indexPath {
    FXTimelineItemViewModel *model = self.timelineItems[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor greenColor];
    cell.itemModel = model;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.itemView.backgroundColor = [UIColor colorWithRed:0.523 green:0.641 blue:0.851 alpha:1.000];
}

- (void)configureVideoItemCell:(FXVideoItemCollectionViewCell *)cell withItemAtIndexPath:(NSIndexPath *)indexPath {
     FXTimelineItemViewModel *model = self.timelineItems[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor greenColor];
    cell.itemModel = model;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.itemView.backgroundColor = [UIColor colorWithRed:0.523 green:0.641 blue:0.851 alpha:1.000];
}

- (void)configureAudioItemCell:(FXAudioItemCollectionViewCell *)cell withItemAtIndexPath:(NSIndexPath *)indexPath {
    //    THTimelineItemViewModel *model = self.timelineItems[indexPath.section][indexPath.row];
    //    if (indexPath.section == THMusicTrack) {
    //        THAudioItem *item = (THAudioItem *)model.timelineItem;
    //        cell.volumeAutomationView.audioRamps = item.volumeAutomation;
    //        cell.volumeAutomationView.duration = item.timeRange.duration;
    //        cell.itemView.backgroundColor = [UIColor colorWithRed:0.361 green:0.724 blue:0.366 alpha:1.000];
    //    } else {
    //        cell.volumeAutomationView.audioRamps = nil;
    //        cell.volumeAutomationView.duration = kCMTimeZero;
    //        cell.itemView.backgroundColor = [UIColor colorWithRed:0.992 green:0.785 blue:0.106 alpha:1.000];
    //    }
}

- (NSString *)cellIDForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return FXPipVideoItemCollectionViewCellID;
    } else if (indexPath.section == 1) {
        return (indexPath.item % 2 == 0) ? FXTransitionCollectionViewCellID : FXVideoItemCollectionViewCellID;
    } else if (indexPath.section == 2 || indexPath.section == 3) {
        return FXAudioItemCollectionViewCellID;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didAdjustToWidth:(CGFloat)width forItemAtIndexPath:(NSIndexPath *)indexPath {
    FXTimelineItemViewModel *model = self.timelineItems[indexPath.section][indexPath.row];
    if (width <= model.maxWidthInTimeline) {
        model.widthInTimeline = width;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didAdjustToPosition:(CGPoint)position forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == FXPipTrack) {
        NSArray *tempArray = [self.timelineItems objectOrNilAtIndex:indexPath.section];
        if (tempArray.count) {
            FXTimelineItemViewModel *model = [tempArray objectOrNilAtIndex:indexPath.row];
            if (model) {
                model.positionInTimeline = position.x;
                [model updateTimelineItem:60];
                [self.collectionView reloadData];
                if (_delegate && [_delegate respondsToSelector:@selector(pipVideoMoveToPosition:timeline:)]) {
                    [_delegate pipVideoMoveToPosition:position.x timeline:model];
                }
            }
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView widthForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.item > 0) {
        if (indexPath.item % 2 != 1) {
            return 32.0f;
        }
    }
    FXTimelineItemViewModel *model = self.timelineItems[indexPath.section][indexPath.row];
    return model.widthInTimeline;
}

- (CGPoint)collectionView:(UICollectionView *)collectionView positionForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == FXPipTrack) {
        FXTimelineItemViewModel *model = self.timelineItems[indexPath.section][indexPath.row];
        return CGPointMake(model.positionInTimeline, 0);
    }
    return CGPointZero;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canAdjustToPosition:(CGPoint)point forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FXTimelineItemViewModel *selectedItem = self.timelineItems[indexPath.section][indexPath.item];
    if (selectedItem.describe.desType == FXDescribeTypeTransition) {
        [self selectTransition:selectedItem.describe atIndexPath:indexPath];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(timelineSelectedIndex:)]) {
            NSInteger select = (NSInteger)(indexPath.row / 2);
            [_delegate timelineSelectedIndex:select];
        }
    }
}

- (void)selectTransition:(FXDescribe *)describe atIndexPath:(NSIndexPath *)indexPath {
    FXTransitionDescribe *trans = (FXTransitionDescribe *)describe;
    if (_delegate && [_delegate respondsToSelector:@selector(clickTransitionButtonAtIndex:)]) {
        [_delegate clickTransitionButtonAtIndex:trans];
    }
    NSLog(@"trans button  click");
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

- (void)collectionView:(UICollectionView *)collectionView didMoveMediaItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *items = self.timelineItems[fromIndexPath.section];
    if (fromIndexPath.item == toIndexPath.item) {
        NSLog(@"FUBAR:  Attempting to move: %li to %li.", (long)fromIndexPath.item, (long)toIndexPath.item);
        NSAssert(NO, @"Attempting to make invalid move.");
    }
    [items exchangeObjectAtIndex:fromIndexPath.item withObjectAtIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)theLayout itemAtIndexPath:(NSIndexPath *)theFromIndexPath shouldMoveToIndexPath:(NSIndexPath *)theToIndexPath {
    return theFromIndexPath.section == theToIndexPath.section;
}

- (void)collectionView:(UICollectionView *)collectionView willDeleteItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.timelineItems[indexPath.section] removeObjectAtIndex:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView scrollEnable:(BOOL)scrollEnable {
    collectionView.scrollEnabled = scrollEnable;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    Float64 percet = offset.x / (scrollView.contentSize.width - kScreenWidth);
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollPercent:)]) {
        [_delegate scrollViewDidScrollPercent:percet];
    }
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        if ([cell isKindOfClass:[FXVideoItemCollectionViewCell class]]) {
            CGPoint centerPoint = CGPointMake(kScreenWidth / 2 + offset.x, CGRectGetMidY(cell.frame) + 10);
            CGRect cellRect = cell.frame;
            cellRect.origin.x -= 2;
            cellRect.size.width += 4;
            if (CGRectContainsPoint(cellRect, centerPoint)) {
                NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
                [self.collectionView selectItemAtIndexPath:indexpath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                if (_delegate && [_delegate respondsToSelector:@selector(timelineSelectedIndex:)]) {
                    NSInteger select = (NSInteger)(indexpath.row / 2);
                    [_delegate timelineSelectedIndex:select];
                }
                return;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollVideoWillDrag)]) {
        [_delegate scrollVideoWillDrag];
    }
}
@end
