//
//  main.m
//  FXVideoEdit
//
//  Created by xunni zou on 2020/7/15.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    NSString *appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}