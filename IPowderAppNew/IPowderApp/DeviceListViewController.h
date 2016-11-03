//
//  DeviceListViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "UIGlossyButton.h"
#import "DeviceTableViewCell.h"
#import "FilterWayViewController.h"
#import "FilterConditionListViewController.h"
#import "DeviceDetailMainViewController.h"
#import "XunjianDeviceMainViewController.h"
@interface DeviceListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,DeviceCellDelegate,FilterWayDelegate,ZBarReaderDelegate,conditionViewDelegate> {
    //显示设备table
    UITableView *deviceTable;
    //反选按钮
    UIGlossyButton *selectAllBtn;
    //筛选按钮
    UIGlossyButton *filterBtn;
    //加入巡检按钮
    UIGlossyButton *xunjianBtn;
    //存放设备信息列表
    NSMutableArray *deviceList;
    //存放设备状态信息
    NSArray *deviceStatusList;
    //存放机房信息
    NSArray *roomList;
    //存放所属系统信息
    NSArray *suoshuxitongList;
}


//从站点列表界面传递过来的站点信息
@property (nonatomic,strong) NSDictionary *siteDic;

@end
