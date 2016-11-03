//
//  DeviceTableViewCell.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeviceCellDelegate <NSObject>
@optional
-(void)refreshData;

@end
@interface DeviceTableViewCell : UITableViewCell

//设备信息dic
@property (nonatomic,strong)NSDictionary *dic;

@property (nonatomic,strong)id<DeviceCellDelegate> delegate;

//计算cell高度
+(float)caculateCellHeight:(NSDictionary *)deviceDic;


@end
