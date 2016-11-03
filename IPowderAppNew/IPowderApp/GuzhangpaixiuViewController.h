//
//  GuzhangpaixiuViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "GuzhangpaixiuFilterConditionViewController.h"

@interface GuzhangpaixiuViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GuzhangpaixiuFilterDelegate>


-(void)popSearchWindow;

@property (nonatomic,strong) NSArray *siteList;

@property (nonatomic) BOOL backToHomePage;

@end
