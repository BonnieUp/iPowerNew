//
//  FinishedTaskViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//--------------------------
//已完成任务视图
//--------------------------
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
@protocol FinishedTaskDelegate <NSObject>

-(void)setFinishedTaskAmount:(NSString *)taskAmount;

@end
@interface FinishedTaskViewController : BaseViewController<EGORefreshTableDelegate,UITableViewDelegate,UITableViewDataSource>  {
    EGORefreshTableHeaderView *_refreshHeaderView;
    UITableView *finishingTaskTable;
    BOOL _reloading;
    NSArray *taskList;
}

@property (nonatomic,strong )NSString *taskId;

@property (nonatomic,strong)id<FinishedTaskDelegate> delegate;

- (void)getTaskDetail ;
@end
