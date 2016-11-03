//
//  GonggongshuxingView.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-8.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GonggongshuxingView.h"

@implementation GonggongshuxingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
//    [self setBtnStyle:_zhandianmingchengBtn];
//     [self setBtnStyle:_suoshufangjianBtn];
//     [self setBtnStyle:_suoshuxitongBtn];
//     [self setBtnStyle:_shebeileixingBtn];
//     [self setBtnStyle:_shebeizhuangtaiBtn];
//     [self setBtnStyle:_zichanbianhaoBtn];
//     [self setBtnStyle:_shiwubianhaoBtn];
//     [self setBtnStyle:_touchanriqiBtn];
//     [self setBtnStyle:_shebeixingzhiBtn];
//     [self setBtnStyle:_shoukongzhuangtaiBtn];
//     [self setBtnStyle:_shebeixinghaoBtn];
//     [self setBtnStyle:_shebeirongliangBtn];
//     [self setBtnStyle:_rongliangdanweiBtn];
//     [self setBtnStyle:_shengchanriqiBtn];
//     [self setBtnStyle:_shengchanchangjiaBtn];
//     [self setBtnStyle:_beizhuBtn];
}


-(void)setBtnStyle:(UIButton *)btn {
    UIImage *iconImage = [PowerUtils OriginImage:[UIImage imageNamed:@"ic_unedit.png"] scaleToSize:CGSizeMake(25, 25)];
    [btn setImage:iconImage forState:UIControlStateNormal];
    [btn setImage:iconImage forState:UIControlStateHighlighted];
    
    btn.backgroundColor = [UIColor clearColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 0);
    
//    UIImage *backgroundImage = [PowerUtils createImageWithColor:[UIColor blueColor] size:CGSizeMake(ScreenWidth, 40)];
//    [btn setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
}

+(GonggongshuxingView *)instanceGonggongshuxingView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"Gonggongshuxing" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
