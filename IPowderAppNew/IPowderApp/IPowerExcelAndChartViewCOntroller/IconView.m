//
//  IconView.m
//  i动力
//
//  Created by 丁浪平 on 16/3/19.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "IconView.h"

@implementation IconView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    // Drawing code
}
- (instancetype)initIconViewWithValue:(NSString*)string1 title:(NSString*)string2
{
    if (self) {
        
        
        self = [[IconView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        self.backgroundColor = [UIColor clearColor];
        self.imageNameString = string1;
        self.IconTitleString = string2;
        
        UITapGestureRecognizer *zhiliangfenxiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToZhiliangfenxiView:)];
        [self addGestureRecognizer:zhiliangfenxiTap];
        
        
//        //图标
//        ziyuanhechaImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height-20)];
//        ziyuanhechaImage.image = [UIImage imageNamed:self.imageNameString];
//        [self addSubview:ziyuanhechaImage];
//        
//        //名称
//        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
//        [nameLabel setText:self.IconTitleString];
//        [nameLabel setFont:[UIFont systemFontOfSize:14]];
//        [nameLabel setTextAlignment:NSTextAlignmentCenter];
//        [nameLabel setTextColor:[UIColor blackColor]];
//        [nameLabel setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:nameLabel];
        [self setNeedsDisplay];
    }
    
    return self;
    
}


-(void)layoutSubviews {
    [super layoutSubviews];
    //图标
    ziyuanhechaImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height-20)];
    ziyuanhechaImage.image = [UIImage imageNamed:self.imageNameString];
    [self addSubview:ziyuanhechaImage];
    
    //名称
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
    [nameLabel setFont:[UIFont systemFontOfSize:12]];

    [nameLabel setText:self.IconTitleString];
    if (self.IconTitleString.length>5) {
        [nameLabel setFont:[UIFont systemFontOfSize:10]];

    }
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:nameLabel];
}
-(void)goToZhiliangfenxiView:(UITapGestureRecognizer*)tap
{
    [self.delegate didSelectIcon:self.tag];
}

@end
