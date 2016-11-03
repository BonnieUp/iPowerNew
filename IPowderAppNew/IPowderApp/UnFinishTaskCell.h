//
//  UnFinishTaskCell.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//--------------------------
//未完成任务中的清单Piece
//--------------------------
#import <UIKit/UIKit.h>

@protocol UnFinishTaskCellDelegate <NSObject>
@optional
-(void)refreshData;

@end
@interface UnFinishTaskCell : UITableViewCell {
    //左边的checkbox按钮
    UIButton *selectBtn;
    //任务内容label;
    UILabel *taskContentLabel;
    //任务计划时间label
    UILabel *taskTimeLabel;
    //分割线
    UIView *seperateView;
}


@property (nonatomic, strong) NSDictionary *taskInfoDic;
@property (nonatomic,strong) id<UnFinishTaskCellDelegate>delegate;


+(float)caculateCellHeight:(NSDictionary *)dic;
@end
