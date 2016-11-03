//
//  DeviceDetailEditMainViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "EditGonggongshuxingViewController.h"
#import "EditKuozhanshuxingViewController.h"
#import "EditShebeiduanziViewController.h"

@interface DeviceDetailEditMainViewController : BaseViewController<UIScrollViewDelegate> {
    
    //公共属性ctrl
    EditGonggongshuxingViewController *gonggongshuxingCtrl;
    //扩展属性ctrl
    EditKuozhanshuxingViewController *kuozhanshuxingCtrl;
    //设备端口ctrl
    EditShebeiduanziViewController *shebeiduankouCtrl;
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
//设备所属房间列表
@property (nonatomic,strong)NSArray *roomList;
//设备所属系统
@property (nonatomic,strong)NSArray *suoshuxitongList;
////生产厂家
//@property (nonatomic,strong)NSArray *shengchanchangjiaList;

@property (nonatomic,strong)NSString *stationNum;
@end
