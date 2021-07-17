//
//  FXTimeLIneCollectionViewLayout.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/28.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLIneCollectionViewLayout.h"
#import "FXFunctionHelp.h"
#import "FXTimeLineLayoutAttributes.h"
#import "FXVideoItemCollectionViewCell.h"
#import "UIView+FXAdd.h"

typedef enum {
    FXPanDirectionLeft = 0,
    FXPanDirectionRight
} FXPanDirection;

typedef enum {
    FXDragModeNone = 0,
    FXDragModeMove,
    FXDragModeTrim
} FXDragMode;

#define DEFAULT_INSETS        UIEdgeInsetsMake(0.0f, kScreenWidth / 2, 0.0f, kScreenWidth / 2)
#define VERTICAL_PADDING      4.0f
#define TRANSITION_CONTROL_HW 32.0f

@interface FXTimeLIneCollectionViewLayout () <UIGestureRecognizerDelegate>

@property (nonatomic) CGSize contentSize;
@property (strong, nonatomic) NSDictionary *calculatedLayout;
@property (strong, nonatomic) NSDictionary *initialLayout;
@property (strong, nonatomic) NSArray *updates;
@property (nonatomic) CGFloat scaleUnit;
@property (nonatomic) FXPanDirection panDirection;
@property (weak, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (weak, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (weak, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UIImageView *draggableImageView;
@property (nonatomic) BOOL swapInProgress;
@property (nonatomic) FXDragMode dragMode;
@property (nonatomic) BOOL trimming;

@property (nonatomic, assign) BOOL canDrag;

@end

@implementation FXTimeLIneCollectionViewLayout

- (id)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _trackInsets = DEFAULT_INSETS;
    _trackHeight = TRIM_IMAGE_WIDTH;
    _dragMode = FXDragModeNone;
}

- (void)setTrackInsets:(UIEdgeInsets)trackInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_trackInsets, trackInsets)) {
        _trackInsets = trackInsets;
        [self invalidateLayout];
    }
}

#pragma mark - Collection View Layout Overrides

+ (Class)layoutAttributesClass {
    return [FXTimeLineLayoutAttributes class];
}

- (void)prepareLayout {
    [self configGesture];

    NSMutableDictionary *layoutDictionary = [NSMutableDictionary dictionary];

    CGFloat xPos = self.trackInsets.left;
    CGFloat yPos = 0;
    CGFloat heightOffset = 0;

    CGFloat maxTrackWidth = 0.0f;

    id<UICollectionViewDelegateTimelineLayout> delegate = (id<UICollectionViewDelegateTimelineLayout>)self.collectionView.delegate;

    NSUInteger trackCount = [self.collectionView numberOfSections];
    for (NSInteger track = 0; track < trackCount; track++) {
        for (NSInteger item = 0, itemCount = [self.collectionView numberOfItemsInSection:track]; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:track];

            FXTimeLineLayoutAttributes *attributes = (FXTimeLineLayoutAttributes *)
                [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

            CGFloat width = [delegate collectionView:self.collectionView widthForItemAtIndexPath:indexPath];
            CGPoint position = [delegate collectionView:self.collectionView positionForItemAtIndexPath:indexPath];

            if (position.x > 0.0f) {
                xPos = position.x + self.trackInsets.left;
            }
            if (track == 0) {
                yPos = 30;
                heightOffset = 30;
            } else if (track == 1) {
                heightOffset = 0;
            }
            if (item == 1) {
                if (itemCount == 3) {
                    attributes.frame = CGRectMake(xPos, yPos + self.trackInsets.top, width, self.trackHeight - self.trackInsets.bottom - heightOffset);
                } else {
                    attributes.frame = CGRectMake(xPos, yPos + self.trackInsets.top, width - 2, self.trackHeight - self.trackInsets.bottom - heightOffset);
                }
            } else if (item == itemCount - 2) {
                attributes.frame = CGRectMake(xPos, yPos + self.trackInsets.top, width - 2, self.trackHeight - self.trackInsets.bottom - heightOffset);
            } else {
                attributes.frame = CGRectMake(xPos, yPos + self.trackInsets.top, width - 4, self.trackHeight - self.trackInsets.bottom - heightOffset);
            }

            // Hacky, revisit
            if (width == TRANSITION_CONTROL_HW) {
                CGRect rect = attributes.frame;
                rect.size.height = TRANSITION_CONTROL_HW;
                rect.origin.y += ((TRIM_IMAGE_WIDTH - rect.size.height) / 2);
                rect.origin.x -= (TRANSITION_CONTROL_HW / 2);
                attributes.frame = rect;
                attributes.zIndex = 1;
            }

            if ([self.selectedIndexPath isEqual:indexPath]) {
                attributes.hidden = YES;
            }

            layoutDictionary[indexPath] = attributes;

            if (width != TRANSITION_CONTROL_HW) {
                if (item == 1) {
                    if (itemCount == 3) {
                        xPos += width;
                    } else {
                        xPos += (width + 2);
                    }
                } else if (item == itemCount - 2) {
                    xPos += width;
                    xPos -= 2;
                } else {
                    xPos += width;
                }
            }
        }

        if (xPos > maxTrackWidth) {
            maxTrackWidth = xPos;
        }

        xPos = self.trackInsets.left;
        yPos += self.trackHeight;
    }

    self.contentSize = CGSizeMake(maxTrackWidth + kScreenWidth / 2, trackCount * self.trackHeight);

    self.calculatedLayout = layoutDictionary;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributesInRect = [NSMutableArray arrayWithCapacity:self.calculatedLayout.count];

    for (NSIndexPath *indexPath in self.calculatedLayout) {
        UICollectionViewLayoutAttributes *attributes = self.calculatedLayout[indexPath];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributesInRect addObject:attributes];
        }
    }

    return allAttributesInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.calculatedLayout[indexPath];
}

#pragma mark - Set up Gesture Recognizers

- (void)configGesture {
    if (_panGestureRecognizer) {
        return;
    }
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.2f;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapRecognizer.numberOfTapsRequired = 2;

    self.panGestureRecognizer = panRecognizer;
    self.longPressGestureRecognizer = longPressRecognizer;
    self.tapGestureRecognizer = tapRecognizer;

    self.panGestureRecognizer.delegate = self;
    self.longPressGestureRecognizer.delegate = self;
    self.tapGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:panRecognizer];
    [self.collectionView addGestureRecognizer:longPressRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherRecognizer {
    return YES;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    id<UICollectionViewDelegateTimelineLayout> delegate = (id<UICollectionViewDelegateTimelineLayout>)self.collectionView.delegate;
    [delegate collectionView:self.collectionView willDeleteItemAtIndexPath:indexPath];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)changeScrollEnableState:(BOOL)scrollEnable {
    id<UICollectionViewDelegateTimelineLayout> delegate = (id<UICollectionViewDelegateTimelineLayout>)self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:scrollEnable:)]) {
        [delegate collectionView:self.collectionView scrollEnable:scrollEnable];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _canDrag = YES;
        [self changeScrollEnableState:!_canDrag];
        [FXFunctionHelp playShake];
        self.dragMode = FXDragModeMove;

        CGPoint location = [recognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];

        if (!indexPath) {
            return;
        }

        self.selectedIndexPath = indexPath;
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        cell.highlighted = YES;

        self.draggableImageView = [cell toImageView];
        self.draggableImageView.frame = cell.frame;

        [self.collectionView addSubview:self.draggableImageView];
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.canDrag = NO;
        [self changeScrollEnableState:!_canDrag];
        //        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:self.selectedIndexPath];
        //        [UIView animateWithDuration:0.15 animations:^{
        //            self.draggableImageView.frame = attributes.frame;
        //        } completion:^(BOOL finished) {
        //            [self invalidateLayout];
        //            [UIView animateWithDuration:0.2 animations:^{
        //                self.draggableImageView.alpha = 0.0f;
        //
        //            } completion:^(BOOL complete) {
        //
        //                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        //                cell.selected = YES;
        //                [self.draggableImageView removeFromSuperview];
        //                self.draggableImageView = nil;
        //            }];
        //
        //            self.selectedIndexPath = nil;
        //            self.dragMode = FXDragModeMove;
        //
        //        }];
    }
}

#pragma mark - Pan Gesture Handler

- (void)handleDrag:(UIPanGestureRecognizer *)recognizer {
    if (!_canDrag) {
        return;
    }
    CGPoint location = [recognizer locationInView:self.collectionView];
    CGPoint translation = [recognizer translationInView:self.collectionView];
    self.panDirection = translation.x > 0 ? FXPanDirectionRight : FXPanDirectionLeft;

    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (indexPath.section == 1) {
        return;
    }
    FXVideoItemCollectionViewCell *cell = (FXVideoItemCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self invalidateLayout];
    }

    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        // Dragging, not trimming
        if (self.dragMode == FXDragModeMove) {
            CGPoint centerPoint = self.draggableImageView.center;
            if (self.selectedIndexPath.section == 1) {
                self.draggableImageView.center = CGPointMake(centerPoint.x + translation.x, centerPoint.y + translation.y);
                if (!self.swapInProgress) {
                    [self swapClips];
                }
            } else {
                // Constrain to horizontal movement
                CGPoint constrainedPoint = self.draggableImageView.center;
                CGPoint newCenter = CGPointMake(constrainedPoint.x + translation.x, constrainedPoint.y);
                CGPoint newOriginPointLeft = CGPointMake(newCenter.x - (CGRectGetWidth(self.draggableImageView.frame) / 2), 0.0f);
                id<UICollectionViewDelegateTimelineLayout> delegate = (id<UICollectionViewDelegateTimelineLayout>)self.collectionView.delegate;
                if (![delegate collectionView:self.collectionView canAdjustToPosition:newOriginPointLeft forItemAtIndexPath:self.selectedIndexPath]) {
                    return;
                }
                CGPoint newOriginPointRight = CGPointMake(newCenter.x + (CGRectGetWidth(self.draggableImageView.frame) / 2), 0.0f);
                if (![delegate collectionView:self.collectionView canAdjustToPosition:newOriginPointRight forItemAtIndexPath:self.selectedIndexPath]) {
                    return;
                }
                self.draggableImageView.center = newCenter;
                NSLog(@"111111:%f", newCenter.x);

                [delegate collectionView:self.collectionView didAdjustToPosition:newOriginPointLeft forItemAtIndexPath:self.selectedIndexPath];
            }
        } else {
            if (indexPath.section != 0) {
                return;
            }

            CMTimeRange timeRange = cell.maxTimeRange;
            self.scaleUnit = CMTimeGetSeconds(timeRange.duration) / CGRectGetWidth(cell.frame);

            NSArray *selectedPaths = [self.collectionView indexPathsForSelectedItems];
            if (selectedPaths && selectedPaths.count > 0) {
                NSIndexPath *selectedPath = [self.collectionView indexPathsForSelectedItems][0];
                if (selectedPath) {
                    cell = (FXVideoItemCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectedPath];
                    if (cell && [cell respondsToSelector:@selector(isPointInDragHandle:)]) {
                        if ([cell isPointInDragHandle:[self.collectionView convertPoint:location toView:cell]]) {
                            self.trimming = YES;
                        }
                        if (self.trimming) {
                            CGFloat newFrameWidth = CGRectGetWidth(cell.frame) + translation.x;
                            [self adjustedToWidth:newFrameWidth];
                        }
                    }
                }
            }
        }

        // Reset translation point as translation amounts are cumulative
        [recognizer setTranslation:CGPointZero inView:self.collectionView];
    }

    // User Ended Gesture
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        //[self invalidateLayout];
        self.trimming = NO;
    }
}

- (BOOL)shouldSwapSelectedIndexPath:(NSIndexPath *)selected withIndexPath:(NSIndexPath *)hovered {
    if (self.panDirection == FXPanDirectionRight) {
        return selected.row < hovered.row;
    } else {
        return selected.row > hovered.row;
    }
}

- (void)swapClips {
    NSIndexPath *hoverIndexPath = [self.collectionView indexPathForItemAtPoint:self.draggableImageView.center];

    id<UICollectionViewDelegateTimelineLayout> delegate = (id<UICollectionViewDelegateTimelineLayout>)self.collectionView.delegate;

    if (hoverIndexPath && [self shouldSwapSelectedIndexPath:self.selectedIndexPath withIndexPath:hoverIndexPath]) {
        if (![delegate collectionView:self.collectionView canMoveItemAtIndexPath:hoverIndexPath]) {
            return;
        }

        self.swapInProgress = YES;
        NSIndexPath *lastSelectedIndexPath = self.selectedIndexPath;
        self.selectedIndexPath = hoverIndexPath;

        [delegate collectionView:self.collectionView didMoveMediaItemAtIndexPath:lastSelectedIndexPath toIndexPath:self.selectedIndexPath];

        [self.collectionView
            performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:@[lastSelectedIndexPath]];
                [self.collectionView insertItemsAtIndexPaths:@[self.selectedIndexPath]];
            }
            completion:^(BOOL finished) {
                self.swapInProgress = NO;
                [self invalidateLayout];
            }];
    }
}

#pragma mark - Event Handler Methods

- (void)adjustedToWidth:(CGFloat)width {
    id<UICollectionViewDelegateTimelineLayout> delegate = (id<UICollectionViewDelegateTimelineLayout>)self.collectionView.delegate;
    NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
    [delegate collectionView:self.collectionView didAdjustToWidth:width forItemAtIndexPath:indexPath];
    [self invalidateLayout];
}

@end