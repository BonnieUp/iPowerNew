//
//  GonggongshuxingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-8.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "GonggongshuxingView.h"

@interface GonggongshuxingViewController : BaseViewController

//设备dic
@property (nonatomic,strong)NSDictionary *deviceDic;
//设备状态
@property (nonatomic,strong)NSArray *deviceStatusList;

-(void)getGonggongshuxing;
@end
