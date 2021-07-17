//
//  FXTimeLineCollectionViewLayout.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/4.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXTimeLineCollectionViewLayout.h"

@interface FXTimeLineCollectionViewLayout ()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *caches;

@end

@implementation FXTimeLineCollectionViewLayout

#pragma mark UICollectionViewLayout
- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
    [_caches removeObjectsForKeys:context.invalidatedItemIndexPaths];
    NSMutableIndexSet *sections = NSMutableIndexSet.new;
    [context.invalidatedItemIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [sections addIndex:obj.section];
    }];

    [_caches addEntriesFromDictionary:[self p_calculationLayoutWithSections:sections]];
}

- (void)prepareLayout {
    [super prepareLayout];
    [_caches removeAllObjects];
    [_caches setDictionary:[self p_calculationLayoutWithSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]]];
}

- (CGSize)collectionViewContentSize {
    __block CGRect rect = CGRectZero;
    [_caches enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *_Nonnull key, UICollectionViewLayoutAttributes *_Nonnull obj, BOOL *_Nonnull stop) {
        rect = CGRectUnion(rect, obj.frame);
    }];
    return CGSizeMake(rect.origin.x + rect.size.width, rect.size.height);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *result = NSMutableArray.new;
    [_caches enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *_Nonnull key, UICollectionViewLayoutAttributes *_Nonnull obj, BOOL *_Nonnull stop) {
        CGRect r = CGRectIntersection(obj.frame, rect);
        if (!CGRectIsNull(r)) {
            [result addObject:obj];
        }
    }];

    return result;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _caches[indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
#pragma mark -

#pragma mark NSObject
- (instancetype)init {
    self = [super init];
    if (self) {
        _caches = NSMutableDictionary.dictionary;
    }
    return self;
}
#pragma mark -

#pragma mark 逻辑
- (NSDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *)p_calculationLayoutWithSections:(NSIndexSet *)sections {
    NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *result = NSMutableDictionary.new;
    const CGFloat height = self.collectionView.bounds.size.height / self.collectionView.numberOfSections;
    __weak typeof(self) weakSelf = self;
    [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *_Nonnull stop) {
        const NSInteger item = [self.collectionView numberOfItemsInSection:section];
//        CGFloat x = item > 0 ? [weakSelf.delegate timeLineCollectionViewLayout:weakSelf leadingForItemAtSection:section] : 0.0;
        for (NSInteger j = 0; j < item; ++j) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:section];
            const CGFloat position = [weakSelf.delegate timeLineCollectionViewLayout:weakSelf positionForItemAtIndexPath:indexPath];
            const CGFloat width = [weakSelf.delegate timeLineCollectionViewLayout:weakSelf widthForItemAtIndexPath:indexPath];
//            const CGFloat space = [weakSelf.delegate timeLineCollectionViewLayout:weakSelf spaceForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *collectionViewLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            collectionViewLayoutAttributes.frame = CGRectMake(position, height * section, width, height);
            result[indexPath] = collectionViewLayoutAttributes;
//            x += width + space;
        }
    }];
    return result.copy;
}
#pragma mark -

@end
