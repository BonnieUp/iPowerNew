//
//  YichaDeviceTableViewCell.h
//  i动力
//
//  Created by 王敏 on 14-10-30.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WeichaDeviceCellDelegate <NSObject>
@optional
-(void)refreshData;

@end
@interface WeichaDeviceTableViewCell : UITableViewCell
//设备信息dic
@property (nonatomic,strong)NSDictionary *dic;

@property (nonatomic,strong)id<WeichaDeviceCellDelegate> delegate;

//计算cell高度
+(float)caculateCellHeight:(NSDictionary *)deviceDic;
@end
