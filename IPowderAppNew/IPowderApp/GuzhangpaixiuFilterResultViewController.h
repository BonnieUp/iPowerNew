//
//  GuzhangpaixiuFilterResultViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-8-1.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface GuzhangpaixiuFilterResultViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GuzhangpaixiuFilterDelegate>

@property (nonatomic,strong) NSArray *siteList;

-(void)searchGaojingWithFilter:(NSDictionary *)dic;

@end
