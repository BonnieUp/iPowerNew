//
//  XunjianDeviceMainViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "WeichaDeviceListViewController.h"
#import "YichaDeviceListViewController.h"
@interface XunjianDeviceMainViewController : BaseViewController<UIScrollViewDelegate,WeichaDeviceListDelegate,YichaDeviceListDelegate> {
    
    //未查设备列表ctrl
    WeichaDeviceListViewController *weichaCtrl;
    //已查设备列表ctrl
    YichaDeviceListViewController *yichaCtrl;
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

@property (nonatomic,strong) NSDictionary *stationDic;

////设备所属房间列表
@property (nonatomic,strong)NSArray *roomList;
//设备状态列表
@property (nonatomic,strong)NSArray *deviceStatusList;
//设备所属系统列表
@property (nonatomic,strong)NSArray *suoshuxitongList;
////生产厂家
//@property (nonatomic,strong)NSArray *shengchanchangjiaList;
//存放任务数量label数组
@property (nonatomic,strong) NSMutableArray *amountLabels;
@end
