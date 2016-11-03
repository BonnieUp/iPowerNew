//
//  SubTaskListViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface SubTaskListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
    UITableView *taskTableView;
    NSArray * taskList;
}

@property (nonatomic,strong) NSString * siteId;

@property (nonatomic,strong) NSString * taskTypeId;

@property (nonatomic,strong) NSString *typeStr;

@property (nonatomic,strong) NSString *detailTaskName;

@property (nonatomic,strong) NSString *isAuto;
@end
