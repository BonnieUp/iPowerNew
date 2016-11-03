//
//  ZhongdagaojingListViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-23.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "GaojingFilterConditionViewController.h"

@interface ZhongdagaojingListViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GaojingFilterDelegate>

@property (nonatomic,strong) NSDictionary *filterDic;

@property (nonatomic,strong) NSDictionary *siteDic;


@property (nonatomic,strong) NSArray *siteList;
@property (nonatomic,strong) NSArray *deviceClassList;
@property (nonatomic,strong) NSArray *gaojingjibieList;

@end
