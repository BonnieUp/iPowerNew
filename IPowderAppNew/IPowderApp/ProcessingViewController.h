//
//  ProcessingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//----------------------------
//进行中的任务视图
//----------------------------
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
@protocol ProcessingTaskViewDelegate <NSObject>

-(void)setProcessingTaskAmount:(NSString *)taskAmount;

-(void)popTaskDetailWithTaskId:(NSString *)taskId
                        nuName:(NSString *)nuName
                         title:(NSString *)title
               contentIdentity:(NSString *)contentIdentity;

@end

@interface ProcessingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate> {
    UITableView *taskTableView;
    NSArray *taskList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (nonatomic,strong )NSString *siteId;

@property (nonatomic,strong)id<ProcessingTaskViewDelegate> delegate;

-(void)getTask;

-(void)getTaskWithResNo;


@end
