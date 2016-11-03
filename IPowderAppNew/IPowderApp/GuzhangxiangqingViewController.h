//
//  GuzhangxiangqingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface GuzhangxiangqingViewController : BaseViewController


@property (nonatomic,strong)NSString *WXFULLNO;

@property (nonatomic,strong) NSArray *siteList;

-(void)getGuzhangxiangqing ;
@end
