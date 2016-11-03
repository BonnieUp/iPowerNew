//
//  TaskDetailMainViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//----------------------------
//任务详情主界面
//----------------------------
#import "BaseViewController.h"
#import "UnFinishingTaskViewController.h"
#import "ProcessingTaskViewController.h"
#import "FinishedTaskViewController.h"

@interface TaskDetailMainViewController : BaseViewController<UIScrollViewDelegate,UnFinishingTaskDelegate,ProcessingTaskDelegate,FinishedTaskDelegate> {
    //任务主题label
    UILabel *taskTitleLabel;
    
    //未完成任务视图ctrl
    UnFinishingTaskViewController *unFinishingTaskViewCtrl;
    //进行中任务视图ctrl
    ProcessingTaskViewController *processingTaskViewCtrl;
    //已完成任务视图ctrl
    FinishedTaskViewController *finishedTaskViewCtrl;
}

//当前站点信息
@property (nonatomic,strong) NSDictionary *siteDic;
//菜单高度
@property (nonatomic, assign) float menuHeight;
//内容滚动区域
@property (nonatomic, strong) UIScrollView *contentScrollView;
//barbutton数组
@property (nonatomic, strong) NSMutableArray *tabs;
//当前tab指示器
@property (nonatomic, strong) UIView *indicatorView;
//tab控制器数组
@property (nonatomic, strong) NSArray *controllers;
//当前任务ID
@property (nonatomic,strong) NSString *taskId;
//nuName
@property (nonatomic,strong) NSString *nuName;
//contentIdentity
@property (nonatomic,strong) NSString *contentIdentity;
//isAuto
@property (nonatomic,strong) NSString *isAuto;
//当前选项卡索引
@property (nonatomic) NSInteger selectedTab;
//存放任务数量label数组
@property (nonatomic,strong) NSMutableArray *amountLabels;

@end
