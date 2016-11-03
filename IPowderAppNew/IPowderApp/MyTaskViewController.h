//
//  MyTaskViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//----------------------------
//我的任务视图
//----------------------------
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
@protocol MyTaskViewDelegate <NSObject>

- (void)popSubTaskListWith:(NSString *)siteId taskTypeId:(NSString *)taskTypeId taskName:(NSString*)taskName taskAmount:(NSString *)taskAmount isAuto:(NSString *)isAuto;

-(void)setMyTaskAmount:(NSString *)taskAmount;

@end

@interface MyTaskViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    UITableView *taskTableView;
    NSArray *taskList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (nonatomic,strong )NSString *siteId;

@property (nonatomic,strong)id<MyTaskViewDelegate> delegate;

-(void)getTask;

-(void)getTaskWithResNo:(NSString *)resNo;

@end
