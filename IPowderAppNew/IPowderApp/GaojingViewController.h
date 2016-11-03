//
//  GaojingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "DangqiangaojingViewController.h"
#import "LishigaojingViewController.h"
#import "GaojingFilterConditionViewController.h"

@interface GaojingViewController : BaseViewController<UIScrollViewDelegate,DangqiangaojingDelegate,LishigaojingDelegate,GaojingFilterDelegate> {
    //当前告警
    DangqiangaojingViewController *dangqianCtrl;
    //历史告警
    LishigaojingViewController *lishiCtrl;
    //当前选项卡索引
    NSUInteger selectedTab;
}

//菜单高度
@property (nonatomic, assign) float menuHeight;
//内容滚动区域
@property (nonatomic, strong) UIScrollView *contentScrollView;
//barbutton数组
@property (nonatomic, strong) NSMutableArray *tabs;
//tab控制器数组
@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSArray *siteList;
@property (nonatomic) BOOL backToHomePage;

-(void)popSearchWindow;

@end
