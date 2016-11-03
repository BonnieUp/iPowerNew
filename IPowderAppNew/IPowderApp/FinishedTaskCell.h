//
//  FinishedTaskCell.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishedTaskCell : UITableViewCell {
    //任务内容label;
    UILabel *taskContentLabel;
    //任务计划时间label
    UILabel *taskTimeLabel;
    //分割线
    UIView *seperateView;
}

@property (nonatomic, strong) NSDictionary *taskInfoDic;

+(float)caculateCellHeight:(NSDictionary *)dic;

@end
