//
//  FXMediaItem.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/24.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXSourceItem.h"

typedef void (^FXPreparationCompletionBlock)(BOOL complete);

@interface FXMediaItem : FXSourceItem

@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, readonly) BOOL prepared;

@property (nonatomic, readonly) NSString *mediaType;

@property (nonatomic, copy, readonly) NSString *title;

@property (strong, nonatomic) NSString *urlString;

- (id)initWithAvAsset:(AVAsset *)videoAsset;

- (id)initWithURL:(NSURL *)url;

- (void)prepareWithCompletionBlock:(FXPreparationCompletionBlock)completionBlock;

- (void)performPostPrepareActionsWithCompletionBlock:(FXPreparationCompletionBlock)completionBlock;

- (BOOL)isTrimmed;

- (AVPlayerItem *)makePlayable;

@end
