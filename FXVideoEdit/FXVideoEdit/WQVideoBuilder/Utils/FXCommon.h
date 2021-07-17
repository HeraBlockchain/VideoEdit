//
//  FXCommon.h
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/27.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#ifndef FXCommon_h
#define FXCommon_h

#define KNotificationRebuildTimelineView  @"rebuildTimelineView"

#define KNotificationTitleLabelEdit  @"titleLabelEditNotification"
#define KNotificationTitleCoverViewSelected  @"titleCoverViewSelected"
#define KNotificationTitleEditDetail  @"titleEditDetail"

static const CGFloat FXTimelineSeconds = 15.0f;
static const CGFloat FXTimelineWidth = 1014.0f;

static const CGSize FX720pVideoSize = {1280.0f, 720.0f};
static const CGSize FX1080pVideoSize = {1920.0f, 1080.0f};

static const CGRect FX720pVideoRect = {{0.0f, 0.0f}, {1280.0f, 720.0f}};
static const CGRect FX1080pVideoRect = {{0.0f, 0.0f}, {1920.0f, 1080.f}};

static const CMTime FXDefaultFadeInOutTime = {3, 2, 1, 0}; // 1.5 seconds
static const CMTime FXDefaultDuckingFadeInOutTime = {1, 2, 1, 0}; // .5 seconds
static const CMTime FXDefaultTransitionDuration = {1, 1, 1, 0}; // 1 second

static inline BOOL FXIsEmpty(id value) {
    return value == nil ||
        value == [NSNull null] ||
        ([value isKindOfClass:[NSString class]] && [value length] == 0) ||
        ([value respondsToSelector:@selector(count)] && [value count] == 0);
}

static inline CGFloat FXGetWidthForTimeRange(CMTimeRange timeRange, CGFloat scaleFactor) {
    return CMTimeGetSeconds(timeRange.duration) * scaleFactor;
}

static inline CGPoint FXGetOriginForTime(CMTime time) {
    if (CMTIME_IS_VALID(time)) {
        CGFloat seconds = CMTimeGetSeconds(time);
        return CGPointMake(seconds * (FXTimelineWidth / FXTimelineSeconds), 0);
    }
    return CGPointZero;
}

static inline CMTimeRange FXGetTimeRangeForWidth(CGFloat width, CGFloat scaleFactor) {
    CGFloat duration = width / scaleFactor;
    return CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, NSEC_PER_SEC));
}

static inline CMTime FXGetTimeForOrigin(CGFloat origin, CGFloat scaleFactor) {
    CGFloat seconds = origin / scaleFactor;
    return CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
}

static inline CGFloat FXDegreesToRadians(CGFloat degrees) {
    return (degrees * M_PI / 180);
}

#endif /* FXCommon_h */
