//
//  ZhouqiweihuViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//-------------
//----周期维护主视图
//-------------
#import "BaseViewController.h"
#import "MyTaskViewController.h"
#import "GroupTaskViewController.h"
#import "ProcessingViewController.h"
#import "WarningViewController.h"
#import "ZBarSDK.h"
#import "UIGlossyButton.h"
@interface ZhouqiweihuViewController : BaseViewController<UIScrollViewDelegate,MyTaskViewDelegate,
GroupTaskViewDelegate,ProcessingTaskViewDelegate,WarningTaskViewDelegate,ZBarReaderDelegate> {
    //显示当前所处站点，点击弹出定位视图
    UIButton *siteButton;
    //我的任务视图
    MyTaskViewController *myTaskCtrl;
    //全组任务视图
    GroupTaskViewController *groupTaskCtrl;
    //进行中的任务视图
    ProcessingViewController *processTaskCtrl;
    //告警视图
    WarningViewController *warningCtrl;
    
    NSUInteger selectedTab;
    //
    UIView *operationView;
    //设备扫描button
    UIGlossyButton *saomiaoBtn;
    //全部任务button
    UIGlossyButton *allTaskBtn;
    
//    
//    //显示我的任务数量label
//    UILabel *myTaskAmountLabel;
//    //显示全组任务数量label
//    UILabel *groupTaskAmountLabel;
//    //显示进行中的任务数量label
//    UILabel *processingTaskAmountLabel;
//    //显示告警信息数量label
//    UILabel *alarmAmountLabel;
}



//当前站点信息
@property (nonatomic,strong) NSDictionary *siteDic;
//菜单高度
@property (nonatomic, assign) float menuHeight;
//内容滚动区域
@property (nonatomic, strong) UIScrollView *contentScrollView;
//barbutton数组
@property (nonatomic, strong) NSMutableArray *tabs;
//存放任务数量label数组
@property (nonatomic,strong) NSMutableArray *amountLabels;

//当前tab指示器
@property (nonatomic, strong) UIView *indicatorView;
//tab控制器数组
@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic) BOOL backToHomePage;

-(void)scanWithResNo:(NSString *)resNo;

@end
