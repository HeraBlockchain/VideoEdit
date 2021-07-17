//
//  FXTimelineItemViewModel.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/27.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, FXTrackType) {
    FXTrackTypePip,
    FXTrackTypeVideo,
    FXTrackTypeAudio,
    FXTrackTypeTitle
};

@class FXDescribe;
@class FXTitleDescribe;
@class FXTimelineItem;


@interface FXTimeLineTitleModel : NSObject

@property (nonatomic, assign) CGFloat position;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) FXTitleDescribe *titleDescribe;

@end


@interface FXTimelineItemViewModel : NSObject

@property (nonatomic) CGFloat widthInTimeline;

@property (nonatomic) CGFloat minWidthInTimeline; //最小的宽度,一张截图的宽度

@property (nonatomic) CGFloat maxWidthInTimeline; // 最大的宽度，每秒10张的宽度

@property (nonatomic) CGFloat positionInTimeline;

@property (nonatomic, assign) CGFloat lengthTimeScale;

@property (nonatomic, strong) FXDescribe *describe;

@property (nonatomic, assign) FXTrackType trackType;

@property (nonatomic, strong) NSArray <FXTitleDescribe *>*titleDescribeArray;;

@property (nonatomic, strong) NSMutableArray *titleModelArray;

- (void)updateTimelineItem:(CGFloat)lengthScale;

- (id)initWithDescribe:(FXDescribe *)describe;

- (id)initWithDescribe:(FXDescribe *)describe
            widthScale:(CGFloat)scale;
@end
