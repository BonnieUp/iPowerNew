//
//  WarningViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//----------------------------
//告警视图
//----------------------------
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
@protocol WarningTaskViewDelegate <NSObject>

-(void)setWarningTaskAmount:(NSString *)taskAmount;
-(void)popWarningDetailWithDic:(NSDictionary *)dic;
@end

@interface WarningViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    UITableView *warningTableView;
    //告警列表
    NSArray *warningList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (nonatomic,strong)id<WarningTaskViewDelegate> delegate;

@property (nonatomic,strong )NSString *siteId;

-(void)getWarningData;

@end
