//
//  GaojingFilterConditionViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "EditFilterCell.h"
@protocol GaojingFilterDelegate <NSObject>
@optional
-(void)gaojingFilterOnChange:(NSDictionary *)dic;
@end
@interface GaojingFilterConditionViewController : BaseViewController<EditFilterCellDelegate>

@property (nonatomic,strong) NSArray *siteList;
@property (nonatomic,strong) NSArray *deviceClassList;
@property (nonatomic,strong) NSArray *gaojingdengjiList;
@property (nonatomic,strong) id<GaojingFilterDelegate>delegate;

//查询的时哪个tab
//1:当前告警
//2:历史告警
//3:重大告警
@property (nonatomic,strong) NSString* selectTabIndex;

@end
