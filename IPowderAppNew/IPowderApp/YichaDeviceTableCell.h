//
//  WeichaDeviceTableCell.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-16.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YichaDeviceTableCell : UITableViewCell

//设备信息dic
@property (nonatomic,strong)NSDictionary *dic;

//计算cell高度
+(float)caculateCellHeight:(NSDictionary *)deviceDic;

@end
