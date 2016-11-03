//
//  CustomSwitch.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "CustomSwitch.h"

@implementation CustomSwitch {
    UIImage *onImage;
    UIImage *offImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(onChangeStateHandler) forControlEvents:UIControlEventTouchUpInside];
        
        onImage = [PowerUtils OriginImage:[UIImage imageNamed:@"btn_switcher_on.png"] scaleToSize:CGSizeMake(self.width, self.height)];
        
        offImage = [PowerUtils OriginImage:[UIImage imageNamed:@"btn_switcher_off.png"] scaleToSize:CGSizeMake(self.width, self.height)];
        if(_on == YES ) {
            [self setBackgroundImage:onImage forState:UIControlStateNormal];
        }else {
            [self setBackgroundImage:offImage forState:UIControlStateNormal];
        }
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}
-(void)setSwitchOnImage:(UIImage *)onImageP offImage:(UIImage *)offImageP {
    onImage = onImageP;
    offImage = offImageP;
    [self setNeedsLayout];
}

//切换image
-(void)setOn:(BOOL)on {
    _on = on;
    if(_on == YES ) {
        [self setBackgroundImage:onImage forState:UIControlStateNormal];
    }else {
        [self setBackgroundImage:offImage forState:UIControlStateNormal];
    }
}

-(void)onChangeStateHandler {
    if(_on == YES ) {
        self.on = NO;
    }else {
        self.on = YES;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(switchOnChange:)]) {
        [_delegate switchOnChange:self];
    }
}
@end
