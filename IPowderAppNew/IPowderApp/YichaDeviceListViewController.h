//
//  YichaDeviceListViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
@protocol YichaDeviceListDelegate <NSObject>

-(void)setYichaDeviceAmount:(NSString *)Amount;
-(void)popEditDeivceController:(NSDictionary *)dic;
@end
@interface YichaDeviceListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) NSString *stationNum;


@property (nonatomic,strong) id<YichaDeviceListDelegate> delegate;

//获取本地存储的已查的设备列表
-(void)getYichaDeviceList;

@end
