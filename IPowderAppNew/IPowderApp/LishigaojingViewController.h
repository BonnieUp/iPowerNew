//
//  LishigaojingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "EGORefreshTableFooterView.h"
#import "WarningDetailMainViewController.h"
@protocol LishigaojingDelegate <NSObject>

-(void)setLishigaojingAmount:(NSString *)amount;

@end

@interface LishigaojingViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGORefreshTableDelegate>

@property (nonatomic,strong) id<LishigaojingDelegate> delegate;

@property (nonatomic,strong) NSArray *siteList;

-(void)searchGaojingWithFilter:(NSDictionary *)dic;

@end
