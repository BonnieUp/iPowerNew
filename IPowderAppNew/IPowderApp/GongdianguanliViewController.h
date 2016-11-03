//
//  GongdianguanliViewController.h
//  i动力
//
//  Created by 王敏 on 15/12/26.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "JuzhangongdianguanliViewController.h"
#import "JifanggongdianguanliViewController.h"
#import "XitonggongdianguanliViewController.h"
#import "ShebeigongdianguanliViewController.h"
#import "UserRegionViewController.h"

@interface GongdianguanliViewController : BaseViewController<UIScrollViewDelegate,UserRegionDelegate>{
    JuzhangongdianguanliViewController *juzhanCtrl;
    JifanggongdianguanliViewController *jifangCtrl;
    XitonggongdianguanliViewController *xitongCtrl;
    ShebeigongdianguanliViewController *shebeiCtrl;
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
