//
//  ProcessingTaskCell.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "ProcessingTaskCell.h"

@implementation ProcessingTaskCell {
    UILabel *finishLabel;
}

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
    //添加checkbox按钮
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(10,15, 30,30 );
    //checkbox状态
    if([[_taskInfoDic objectForKey:@"selected"] isEqualToString:@"YES"]) {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_normal.png"] forState:UIControlStateNormal];
    }
    else {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_disable.png"] forState:UIControlStateNormal];
    }
    [selectBtn addTarget:self action:@selector(onTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:selectBtn];
    
    //添加任务名称label
    taskContentLabel  = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 240, 40)];
    taskContentLabel.font = [UIFont systemFontOfSize:14];
    taskContentLabel.backgroundColor = [UIColor clearColor];
    taskContentLabel.numberOfLines = 2;
    [self.contentView addSubview:taskContentLabel];
    
    //添加任务计划时间label
    taskTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 37, 240, 20)];
    taskTimeLabel.font = [UIFont systemFontOfSize:12];
    taskContentLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:taskTimeLabel];
    
    
    //添加是否完工checbox按钮
    finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(ScreenWidth-35,10, 30,30 );
    //checkbox状态
    if([[_taskInfoDic objectForKey:@"isFinished"] isEqualToString:@"YES"]) {
        [finishBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_selected.png"] forState:UIControlStateNormal];
    }
    else {
        [finishBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_disable.png"] forState:UIControlStateNormal];
    }
    [finishBtn addTarget:self action:@selector(onFinishBtnTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:finishBtn];
    
    finishLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-30, 35, 60, 20)];
    finishLabel.text = @"完工";
    finishLabel.font = [UIFont systemFontOfSize:12];
    finishLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:finishLabel];
    
    //添加分割线
    seperateView = [[UIView alloc]initWithFrame:CGRectMake(0,59, ScreenWidth, 0.5)];
    seperateView.alpha = 0.8;
    seperateView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:seperateView];
    
    
    [self reloadUI];
    
    //添加鼠标单击事件
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchHandler)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:recognizer];
}


-(void)reloadUI {
    //checkbox状态
    if([[_taskInfoDic objectForKey:@"selected"] isEqualToString:@"YES"] ) {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_normal.png"] forState:UIControlStateNormal];
    }
    else {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_disable.png"] forState:UIControlStateNormal];
    }
    
    //finishBtn状态
    if([[_taskInfoDic objectForKey:@"isFinished"] isEqualToString:@"YES"]) {
        [finishBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_selected.png"] forState:UIControlStateNormal];
    }
    else {
        [finishBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_disable.png"] forState:UIControlStateNormal];
    }
    
    [taskContentLabel setText:[_taskInfoDic objectForKey:@"subTaskTypeName"]];
    NSString *operTime = [[_taskInfoDic objectForKey:@"operTime"] substringToIndex:16];
    [taskTimeLabel setText:[NSString stringWithFormat:@"开始时间:%@",operTime]];
    
    //重新布局
    float height = [ProcessingTaskCell caculateCellHeight:_taskInfoDic];
    selectBtn.frame = CGRectMake(10, (height-30)/2, 30, 30);
    finishBtn.bottom = selectBtn.bottom-4;
    finishLabel.top = selectBtn.bottom-8;
    taskContentLabel.frame = CGRectMake(50, 0, 240, height-25);
    taskTimeLabel.bottom = height-3;
    seperateView.bottom = height-1;
    
}

-(void)setTaskInfoDic:(NSDictionary *)taskInfoDic {
    if(![_taskInfoDic isEqual:taskInfoDic ]) {
        _taskInfoDic = taskInfoDic;
        [self reloadUI];
    }
}

-(void)onTouchHandler {
    if([[_taskInfoDic objectForKey:@"selected"] isEqualToString:@"YES"]) {
        [_taskInfoDic setValue:@"NO" forKey:@"selected"];
        [_taskInfoDic setValue:@"NO" forKey:@"isFinished"];
    }
    else
        [_taskInfoDic setValue:@"YES" forKey:@"selected"];
    [self reloadUI];
    
    if(_delegate && [_delegate respondsToSelector:@selector(refreshData)]) {
        [_delegate refreshData];
    }
}

-(void)onFinishBtnTouchHandler {
    if([[_taskInfoDic objectForKey:@"isFinished"] isEqualToString:@"YES"])
        [_taskInfoDic setValue:@"NO" forKey:@"isFinished"];
    else {
        [_taskInfoDic setValue:@"YES" forKey:@"isFinished"];
        [_taskInfoDic setValue:@"YES" forKey:@"selected"];
    }
    [self reloadUI];
    
    if(_delegate && [_delegate respondsToSelector:@selector(refreshData)]) {
        [_delegate refreshData];
    }
}

//计算cell高度
+(float)caculateCellHeight:(NSDictionary *)dic {
    float hei = 5;
    CGSize titleSize = [PowerUtils getLabelSizeWithText:[dic objectForKey:@"subTaskTypeName"] width:240 font:[UIFont systemFontOfSize:14]];
    hei+=titleSize.height+25;
    return hei;
}

@end
