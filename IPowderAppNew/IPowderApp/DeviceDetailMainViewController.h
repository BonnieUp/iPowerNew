//
//  DeviceDetailMainViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-8.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "GonggongshuxingViewController.h"
#import "KuozhanshuxingViewController.h"
#import "ShebeiduanziViewController.h"

@interface DeviceDetailMainViewController : BaseViewController<UIScrollViewDelegate,ShebeiduanziDelegate> {
    
    //公共属性ctrl
    GonggongshuxingViewController *gonggongshuxingCtrl;
    //扩展属性ctrl
    KuozhanshuxingViewController *kuozhanshuxingCtrl;
    //设备端口ctrl
    ShebeiduanziViewController *shebeiduankouCtrl;
    //当前选项卡索引
    NSUInteger selectedTab;
}

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

//设备编号
@property (nonatomic,strong)NSDictionary *deviceDic;
//设备状态信息
@property (nonatomic,strong)NSArray *deviceStatusList;
@end
