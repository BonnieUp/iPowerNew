//
//  ProcessingTaskCell.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//--------------------------
//进行中的任务Piece
//--------------------------
#import <UIKit/UIKit.h>

@protocol ProcessingTaskCellDelegate <NSObject>
@optional
-(void)refreshData;
@end

@interface ProcessingTaskCell : UITableViewCell {
    //左边的checkbox按钮
    UIButton *selectBtn;
    //任务内容label;
    UILabel *taskContentLabel;
    //任务计划时间label
    UILabel *taskTimeLabel;
    //右边的完工checkbox按钮
    UIButton *finishBtn;
    //分割线
    UIView *seperateView;
}


@property (nonatomic, strong) NSDictionary *taskInfoDic;
@property (nonatomic,strong) id<ProcessingTaskCellDelegate>delegate;

+(float)caculateCellHeight:(NSDictionary *)dic;
@end
