//
//  FXFunctionHelp.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/8/26.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXFunctionHelp.h"

@implementation FXFunctionHelp

+ (void)playShake {
    UIImpactFeedbackGenerator *impactFeedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [impactFeedBack prepare];
    [impactFeedBack impactOccurred];
}

+ (NSString *)timeFormatted:(int)totalSeconds

{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
@end
