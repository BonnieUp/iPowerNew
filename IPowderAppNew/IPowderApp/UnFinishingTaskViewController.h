//
//  UnFinishingTaskViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//--------------------------
//未完成任务视图
//--------------------------
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "UnFinishTaskCell.h"
#import "UIGlossyButton.h"
#import "CommitDataViewController.h"

@protocol UnFinishingTaskDelegate <NSObject>

-(void)setUnFinishingTaskAmount:(NSString *)taskAmount;

@end

@interface UnFinishingTaskViewController : BaseViewController<EGORefreshTableDelegate,UITableViewDelegate,UITableViewDataSource,UnFinishTaskCellDelegate,UIAlertViewDelegate,CommitDataDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    UITableView *unFinishingTaskTable;
    BOOL _reloading;
    NSMutableArray *taskList;
    UIGlossyButton *selectAllBtn;
    UIGlossyButton *startWeihuBtn;
}

@property (nonatomic,strong )NSString *taskId;

@property (nonatomic,strong)id<UnFinishingTaskDelegate> delegate;

@property (nonatomic,strong) NSString *isAuto;

- (void)getTaskDetail;
@end
