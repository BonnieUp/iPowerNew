//
//  DangqiangaojingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "WarningDetailMainViewController.h"

@protocol DangqiangaojingDelegate <NSObject>

-(void)setDangqiangaojingAmount:(NSString *)amount;

@end

@interface DangqiangaojingViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) id<DangqiangaojingDelegate> delegate;

@property (nonatomic,strong) NSArray *siteList;

-(void)searchGaojingWithFilter:(NSDictionary *)dic;



@end
