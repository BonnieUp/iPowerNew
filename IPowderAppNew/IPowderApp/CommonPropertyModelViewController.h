//
//  CommonPropertyModelViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"
@protocol CommonPropertyDelegate <NSObject>
@optional
//当选择设备大类以后点击提交触发
-(void)submitHandler:(NSDictionary *)dic;
@end

@interface CommonPropertyModelViewController : BaseModalViewController


//存放所有属性的列表
@property (nonatomic,strong)NSArray *dataList;
//当前选中的属性
@property (nonatomic,strong)NSMutableDictionary *selectDic;
//title
@property (nonatomic,strong)NSString *titleStr;

@property (nonatomic,strong)id<CommonPropertyDelegate>delegate;

@end
