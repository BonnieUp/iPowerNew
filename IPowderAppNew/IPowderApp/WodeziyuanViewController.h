//
//  WodeziyuanViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "UIGlossyButton.h"
#import "ZBarSDK.h"
#import "UserRegionViewController.h"

@interface WodeziyuanViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ZBarReaderDelegate,UserRegionDelegate,UITextFieldDelegate,UIAlertViewDelegate>  {
    //显示站点的列表
    UITableView *siteTableView;
    //过滤栏
    UITextField *searchBar;
    //设备扫描按钮
    UIGlossyButton *saomiaoBtn;
    //存放站点信息列表
    NSArray *siteList;
    //存放原始的站点信息列表，用于过滤以后的重置
    NSMutableArray *siteListOri;
//    //存放区局信息列表
//    NSArray *regionList;
    //当前所选的区局
    NSDictionary *selectRegionDic;
    
    //相应键盘事件的一个透明view
    UIView *tapBackgroundView;
    
}


@property (nonatomic) BOOL backToHomePage;

@property (nonatomic,strong) NSArray *regionList;

@end
