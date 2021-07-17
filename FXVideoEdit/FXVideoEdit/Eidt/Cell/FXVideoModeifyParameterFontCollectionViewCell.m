//
//  FXVideoModeifyParameterFontCollectionViewCell.m
//  FXVideoEdit
//
//  Created by duoyi on 2020/9/10.
//  Copyright © 2020 xunni zou. All rights reserved.
//

#import "FXVideoModeifyParameterFontCollectionViewCell.h"
#import "FXFontManager.h"

@interface FXVideoModeifyParameterFontCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation FXVideoModeifyParameterFontCollectionViewCell

#pragma mark 对外
- (void)setCellData:(NSString *)cellData {
    [UIFont unloadFontFromData:_font];
    _cellData = cellData;
    _label.text = cellData;
    _font = [FXFontManager.shareFontManager fontWithName:_cellData];
    _label.font = _font;
}
#pragma mark -

#pragma mark
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _label.backgroundColor = self.selected ? [UIColor colorWithRGBA:0xF54184FF] : [UIColor colorWithRGBA:0x999DA4FF];
}
#pragma mark -

#pragma mark UIView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel.alloc initWithFrame:self.contentView.bounds];
        _label.userInteractionEnabled = YES;
        _label.layer.cornerRadius = IS_IPAD ? 2 : 2;
        _label.layer.masksToBounds = YES;
        _label.adjustsFontSizeToFitWidth = YES;
        _label.backgroundColor = [UIColor colorWithRGBA:0x999DA4FF];
        _label.textColor = UIColor.whiteColor;
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
    }

    return self;
}
#pragma mark -

- (void)dealloc {
    [UIFont unloadFontFromData:_font];
}

@end