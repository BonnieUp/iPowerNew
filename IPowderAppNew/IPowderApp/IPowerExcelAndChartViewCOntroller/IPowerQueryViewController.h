//
//  IPowerQueryViewController.h
//  i动力
//
//  Created by 丁浪平 on 16/3/20.
//  Copyright © 2016年 Min.wang. All rights reserved.
//1.维护工单分类统计的查询条件
//字段	取值
//时间类型	工单开始时间、工单撰写时间、工单修改时间、工单归档时间、
//归档状态	已归档、未归档、全部
//归档类型	自动、手动、全部
//开始时间	时间
//结束时间	时间
//按局站统计

#import <UIKit/UIKit.h>
@protocol XudianchiFilterDelegate <NSObject>

-(void)submitFilterHandler:(NSDictionary *)dic;

@end
@interface IPowerQueryViewController : BaseViewController
{
    NSArray *qujuList;
    NSString *stringName;
    NSString *stringNameMETHOD_NAME;
     NSArray *dataSource;
}

-(void)setXudianchiTitle:(NSString *)title;

@property (nonatomic,strong) NSArray *qujuList;
@property (nonatomic,strong) NSString *stringName;
@property (nonatomic,strong) NSString *stringNameMETHOD_NAME;

@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic,strong) id<XudianchiFilterDelegate> delegate;

@end
