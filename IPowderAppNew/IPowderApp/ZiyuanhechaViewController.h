//
//  ZiyuanhechaViewController.h
//  i动力
//
//  Created by 王敏 on 15/12/26.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "DairenlingViewController.h"
#import "DaikaishiViewController.h"
#import "DaiwanchengViewController.h"
#import "YiwanchengViewController.h"

@interface ZiyuanhechaViewController : BaseViewController<UIScrollViewDelegate,DairenlingDelegate,DaikaishiDelegate,DaiwanchengDelegate,YiwanchengDelegate>{
    //当前选项卡索引
    NSUInteger selectedTab;
    DairenlingViewController *dairenlingCtrl;
    DaikaishiViewController *daikaishiCtrl;
    DaiwanchengViewController *daiwanchengCtrl;
    YiwanchengViewController *yiwanchengCtrl;
}


@property (nonatomic) BOOL backToHomePage;


//tab控制器数组
@property (nonatomic, strong) NSArray *controllers;
//内容滚动区域
@property (nonatomic, strong) UIScrollView *contentScrollView;
//菜单高度
@property (nonatomic, assign) float menuHeight;

//barbutton数组
@property (nonatomic, strong) NSMutableArray *tabs;

@end
