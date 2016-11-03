//
//  GuzhangMainViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "GuzhangxiangqingViewController.h"
#import "GuzhangliuzhuanViewController.h"

@interface GuzhangMainViewController : BaseViewController<UIScrollViewDelegate>

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

@property (nonatomic,strong) NSString *WXFULLNO;

@property (nonatomic,strong) NSArray *siteList;

@end
