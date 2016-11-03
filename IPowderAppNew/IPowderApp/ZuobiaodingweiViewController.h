//
//  ZuobiaodingweiViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
//#import "BMapKit.h"
//CLLocationManagerDelegate
@interface ZuobiaodingweiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UITextFieldDelegate> {
    
    CLLocationManager *locationManager;
    
    UITableView *siteTable;
    //显示经度label
    UILabel *lngLabel;
    //显示纬度label
    UILabel *latLabel;
    
    //百度地图SDK
//    BMKLocationService *locationService;

}

@property (nonatomic,strong) NSArray* siteArray;

@end
