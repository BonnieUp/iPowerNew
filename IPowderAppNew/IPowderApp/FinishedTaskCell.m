//
//  FinishedTaskCell.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "FinishedTaskCell.h"

@implementation FinishedTaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //添加任务名称label
    taskContentLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 40)];
    taskContentLabel.font = [UIFont systemFontOfSize:14];
    taskContentLabel.backgroundColor = [UIColor clearColor];
    taskContentLabel.numberOfLines = 2;
    [self.contentView addSubview:taskContentLabel];
    
    //添加任务计划时间label
    taskTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 300, 20)];
    taskTimeLabel.font = [UIFont systemFontOfSize:12];
    taskContentLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:taskTimeLabel];
    
    
    //添加分割线
    seperateView = [[UIView alloc]initWithFrame:CGRectMake(0,59, ScreenWidth, 0.5)];
    seperateView.alpha = 0.8;
    seperateView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:seperateView];
    
    [self reloadUI];
}

-(void)reloadUI {
    [taskContentLabel setText:[_taskInfoDic objectForKey:@"subTaskTypeName"]];
    NSString *operTime = [[_taskInfoDic objectForKey:@"operTime"] substringToIndex:16];
    [taskTimeLabel setText:[NSString stringWithFormat:@"完成时间:%@",operTime]];
    
    //重新布局
    float height = [FinishedTaskCell caculateCellHeight:_taskInfoDic];
    taskContentLabel.frame = CGRectMake(10, 0, 300, height-25);
    taskTimeLabel.bottom = height-3;
    seperateView.bottom = height-1;
}

-(void)setTaskInfoDic:(NSDictionary *)taskInfoDic {
    if(![_taskInfoDic isEqual:taskInfoDic ]) {
        _taskInfoDic = taskInfoDic;
        [self reloadUI];
    }
}

//计算cell高度
+(float)caculateCellHeight:(NSDictionary *)dic {
    float hei = 5;
    CGSize titleSize = [PowerUtils getLabelSizeWithText:[dic objectForKey:@"subTaskTypeName"] width:300 font:[UIFont systemFontOfSize:14]];
    hei+=titleSize.height+25;
    return hei;
}

@end
