//
//  ZhiliangfenxiLogoView.m
//  i动力
//
//  Created by 丁浪平 on 16/3/18.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "ZhiliangfenxiLogoView.h"

@implementation ZhiliangfenxiLogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    //图标
    ziyuanhechaImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height-20)];
    ziyuanhechaImage.image = [UIImage imageNamed:@"donghuanbaobiao.png"];
    [self addSubview:ziyuanhechaImage];
    
    //名称
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
    [nameLabel setText:@"质量分析"];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:nameLabel];
}


@end
