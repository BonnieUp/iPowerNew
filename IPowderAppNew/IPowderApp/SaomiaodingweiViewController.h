//
//  SaomiaodingweiViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-19.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//------------------------------
//扫描设备显示的站点视图
//------------------------------
#import "BaseViewController.h"

@interface SaomiaodingweiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate> {
    UITableView *siteTable;
}

@property (nonatomic,strong) NSArray *siteArray;
@property (nonatomic,strong) NSString* resNo;

@end
