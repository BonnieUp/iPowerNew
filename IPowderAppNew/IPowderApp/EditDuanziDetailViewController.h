//
//  EditDuanziDetailViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "EditPropertyCell.h"
@interface EditDuanziDetailViewController : BaseViewController

@property (nonatomic,strong) NSDictionary *duanziDic;

@property (nonatomic,strong) NSDictionary *deviceDic;

@property (nonatomic,strong) NSString *stationNum;

-(NSDictionary *)getEditedDuanziDic;

@end
