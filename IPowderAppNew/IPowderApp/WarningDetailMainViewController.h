//
//  WarningDetailMainViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "RunTimeWarningDataViewController.h"
#import "RunTimeWarningInfoViewController.h"

@interface WarningDetailMainViewController : BaseViewController<UIScrollViewDelegate,RunTimeWarningInfoDelegate> {
    //当前选项卡索引
    NSUInteger selectedTab;
    //实时数据ctrl
    RunTimeWarningDataViewController *dataCtrl;
    //实时告警信息ctrl
    RunTimeWarningInfoViewController *infoCtrl;
}

@property (nonatomic,strong) NSDictionary *warningDic;
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

@end
