//
//  XudianchiguanliViewController.h
//  i动力
//
//  Created by 王敏 on 15/12/26.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "XudianchifangdianceshiViewController.h"
#import "XudianchineizuceshiViewController.h"
#import "UserRegionViewController.h"
#import "XudianchiFilterConditionViewController.h"


@interface XudianchiguanliViewController : BaseViewController<UIScrollViewDelegate,UserRegionDelegate,XudianchifangdianDelegate,XudianchineizuDelegate,XudianchiFilterDelegate>{
    XudianchifangdianceshiViewController *fangdianCtrl;
    XudianchineizuceshiViewController *neizuCtrl;
    UIButton *siteBtn;
    //当前选项卡索引
    NSUInteger selectedTab;
    //当前所选的区局
    NSDictionary *selectRegionDic;
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

//区局列表
@property (nonatomic,strong) NSMutableArray *regionList;

@end
