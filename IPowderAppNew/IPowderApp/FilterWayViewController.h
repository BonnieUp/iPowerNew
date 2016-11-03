//
//  FilterWayViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//----------------------------
//选择筛选方式
//----------------------------
#import "BaseModalViewController.h"
@protocol FilterWayDelegate <NSObject>
@optional
-(void)chooseManualFilter;

-(void)chooseSaomiaoFilter;

-(void)chooseShowAllButton;

@end
@interface FilterWayViewController : BaseModalViewController

@property (nonatomic,strong) id<FilterWayDelegate> delegate;

@end
