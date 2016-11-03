//
//  WeichaDeviceListViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "WeichaDeviceTableViewCell.h"
@protocol WeichaDeviceListDelegate <NSObject>

-(void)setWeichaDeviceAmount:(NSString *)Amount;
-(void)popEditDeivceController:(NSDictionary *)dic;

@end

@interface WeichaDeviceListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,WeichaDeviceCellDelegate,ZBarReaderDelegate>

@property (nonatomic,strong) NSString *stationNum;

@property (nonatomic,strong) id<WeichaDeviceListDelegate> delegate;

//获取本地存储的位差的设备列表
-(void)getWeichaDeviceList;

@end
