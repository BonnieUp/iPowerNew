//
//  WodewangguanLogoView.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "WodewangguanLogoView.h"

@implementation WodewangguanLogoView

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
    //我的网管图标
    wangguanImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height-20)];
    wangguanImage.image = [UIImage imageNamed:@"ic_netmanage.png"];
    [self addSubview:wangguanImage];
    
    //名称
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
    [nameLabel setText:@"我的网管"];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:nameLabel];
}

@end
