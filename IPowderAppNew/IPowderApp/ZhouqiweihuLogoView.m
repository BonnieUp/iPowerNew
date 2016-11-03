//
//  ZhouqiweihuLogoView.m
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

//周期维护图标视图
#import "ZhouqiweihuLogoView.h"

@implementation ZhouqiweihuLogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)layoutSubviews {
    [super layoutSubviews];
    
    //周期维护图标
    weihuImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height-20)];
    weihuImage.image = [UIImage imageNamed:@"ic_maintain.png"];
    [self addSubview:weihuImage];
    //名称
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
    [nameLabel setText:@"周期维护"];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:nameLabel];
    //我的待处理任务
    myTaskAmountView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, 30, 30)];
    myTaskAmountView.image = [UIImage imageNamed:@"bg_num_blue.9.png"];
    [myTaskAmountView setHidden:YES];
    UILabel *myTaskLabel = [[UILabel alloc]initWithFrame:myTaskAmountView.bounds];
    myTaskLabel.font = [UIFont systemFontOfSize:12];
    myTaskLabel.textAlignment = NSTextAlignmentCenter;
    myTaskLabel.textColor = [UIColor whiteColor];
    myTaskLabel.backgroundColor = [UIColor clearColor];
    myTaskLabel.tag = 100;
    [myTaskAmountView addSubview:myTaskLabel];
    [self addSubview:myTaskAmountView];
    
    //我的组任务
    myGroupAmountView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-20, -10,30, 30)];
    myGroupAmountView.image = [UIImage imageNamed:@"bg_num_red.9.png"];
    [myGroupAmountView setHidden:YES];
    UILabel *groupTaskLabel = [[UILabel alloc]initWithFrame:myTaskAmountView.bounds];
    groupTaskLabel.font = [UIFont systemFontOfSize:12];
    groupTaskLabel.textAlignment = NSTextAlignmentCenter;
    groupTaskLabel.textColor = [UIColor whiteColor];
    groupTaskLabel.backgroundColor = [UIColor clearColor];
    groupTaskLabel.tag = 101;
    [myGroupAmountView addSubview:groupTaskLabel];
    [self addSubview:myGroupAmountView];
}

-(void)setMyTaskAmount:(NSString *)myTaskAmount {
    if(! [myTaskAmount isEqualToString:_myTaskAmount]) {
        _myTaskAmount = myTaskAmount;
        UILabel *myTaskLabel = (UILabel *)[myTaskAmountView viewWithTag:100];
        myTaskLabel.text = _myTaskAmount;
        if(![_myTaskAmount isEqual:@"0"]) {
            [myTaskAmountView setHidden:NO];
        }
        else {
            [myTaskAmountView setHidden:YES];
        }
    }
}


-(void)setGroupTaskAmount:(NSString *)groupTaskAmount {
    if(! [groupTaskAmount isEqualToString:_groupTaskAmount]) {
        _groupTaskAmount = groupTaskAmount;
        UILabel *myGroupLabel = (UILabel *)[myGroupAmountView viewWithTag:101];
        myGroupLabel.text = _groupTaskAmount;
        if(![_groupTaskAmount isEqual:@"0"]) {
            [myGroupAmountView setHidden:NO];
        }
        else {
            [myGroupAmountView setHidden:YES];
        }
    }
}
@end
