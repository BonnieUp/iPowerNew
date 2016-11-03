//
//  WodewangguanViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GaojingViewController.h"
#import "GuanchaViewController.h"
#import "GuzhangpaixiuViewController.h"
#import "BaseTabBarViewController.h"
@interface WodewangguanViewController :BaseTabBarViewController<UIAlertViewDelegate> {
    //告警tab
    GaojingViewController *gaojingCtrl;
    //观察列表tab
    GuanchaViewController *guanchaCtrl;
    //故障派修tab
    GuzhangpaixiuViewController *guzhangpaixiuCtrl;

}

@property (nonatomic) BOOL backToHomePage;

//barbutton数组
@property (nonatomic, strong) NSMutableArray *tabs;


@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,strong) NSArray *siteList;


@end
