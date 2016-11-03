//
//  ProcessingTaskViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//--------------------------
//进行中的任务视图
//--------------------------
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ProcessingTaskCell.h"
#import "UIGlossyButton.h"
#import "ProcessCommitDataViewController.h"

@protocol ProcessingTaskDelegate <NSObject>

-(void)setProcessingTaskAmount:(NSString *)taskAmount;

@end
@interface ProcessingTaskViewController : BaseViewController<EGORefreshTableDelegate,UITableViewDelegate,UITableViewDataSource,ProcessingTaskCellDelegate,UIAlertViewDelegate,ProcessCommitDataDelegate>  {
    EGORefreshTableHeaderView *_refreshHeaderView;
    UITableView *processingTaskTable;
    BOOL _reloading;
    NSMutableArray *taskList;
    UIGlossyButton *selectAllBtn;
    UIGlossyButton *submitBtn;
    UIGlossyButton *selectAllFinishBtn;
}

@property (nonatomic,strong )NSString *taskId;

@property (nonatomic,strong)id<ProcessingTaskDelegate> delegate;

//contentIdentity
@property (nonatomic,strong) NSString *contentIdentity;

- (void)getTaskDetail ;
@end
