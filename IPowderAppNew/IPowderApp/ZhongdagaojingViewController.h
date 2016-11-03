//
//  ZhongdagaojingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "ZhongdagaojingListViewController.h"
@protocol ZhongdagaojingDelegate <NSObject>

-(void)setZhongdagaojingAmount:(NSString *)amount;

@end
@interface ZhongdagaojingViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) id<ZhongdagaojingDelegate> delegate;

-(void)searchGaojingWithFilter:(NSDictionary *)dic;

@property (nonatomic,strong) NSArray *siteList;
@property (nonatomic,strong) NSArray *deviceClassList;
@property (nonatomic,strong) NSArray *gaojingjibieList;

-(void)getFatalAlarmData;
@end
