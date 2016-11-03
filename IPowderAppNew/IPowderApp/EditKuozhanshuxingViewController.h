//
//  EditKuozhanshuxingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "EditPropertyCell.h"
@interface EditKuozhanshuxingViewController : BaseViewController

//设备dic
@property (nonatomic,strong)NSDictionary *deviceDic;

@property (nonatomic,strong)NSString *stationNum;

//生成json字典
-(NSMutableDictionary *)createJsonDictonry;

@end
