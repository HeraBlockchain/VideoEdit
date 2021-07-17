//
//  FXViewController.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/8/31.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXViewController.h"

@interface FXViewController ()

@end

@implementation FXViewController

#pragma mark 对外

- (void)showDesc:(NSString *)desc {
    if (desc.length > 0) {
    }
}

- (void)showError:(NSError *)error {
    if (error.localizedDescription) {
        [self showDesc:error.localizedDescription];
    }
}

- (void)showErrorDesc:(NSString *)errorDesc {
    if (errorDesc.length > 0) {
    }
}

#pragma mark -

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    {
        self.view.backgroundColor = [UIColor colorWithRGBA:0x0F0F13FF];
    }
}
#pragma mark -

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end