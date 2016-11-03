//
//  EditGonggongshuxingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "EditShebeileixingViewController.h"

@interface EditGonggongshuxingViewController : BaseViewController<EditShebeileixingDelegate>

//设备dic
@property (nonatomic,strong)NSDictionary *deviceDic;

//设备状态信息
@property (nonatomic,strong)NSArray *deviceStatusList;
//设备所属房间列表
@property (nonatomic,strong)NSArray *roomList;
//设备所属系统
@property (nonatomic,strong)NSArray *suoshuxitongList;
////生产厂家
//@property (nonatomic,strong)NSArray *shengchanchangjiaList;

//生成json字典
-(NSMutableDictionary *)createJsonDictonry;

-(void)getGonggongshuxing;

@end
