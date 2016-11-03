//
//  WodeziyuanLogoView.m
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "WodeziyuanLogoView.h"

@implementation WodeziyuanLogoView

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
    //我的资源图标
    ziyuanImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height-20)];
    ziyuanImage.image = [UIImage imageNamed:@"ic_resource.png"];
    [self addSubview:ziyuanImage];

    //名称
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
    [nameLabel setText:@"资源巡检"];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:nameLabel];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
