//
//  RunTimeWarningDataViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface RunTimeWarningDataViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate> {
    UITableView *runtimeDataTable;
    
}

//告警信息数据
@property (nonatomic ,strong )NSDictionary *warningDic;
//告警实时信息数据
@property (nonatomic,strong)NSArray *warningInfoList;

@property (nonatomic,strong)NSString *netunit_id;

-(void)getWarningData;

@end
