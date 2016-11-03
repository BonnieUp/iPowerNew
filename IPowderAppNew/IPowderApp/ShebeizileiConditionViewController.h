//
//  ShebeizileiConditionViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-6.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"
@protocol ShebeizileiConditionDelegate <NSObject>
@optional
//当选择设备子类以后点击提交触发
-(void)submitShebeizileiCondition:(NSDictionary *)dic;
@end
@interface ShebeizileiConditionViewController : BaseModalViewController


@property (nonatomic,strong)id<ShebeizileiConditionDelegate> delegate;

//设备子类列表
@property (nonatomic,strong)NSArray *zileiList;
//当前选中的子类类型
@property (nonatomic,strong)NSString *selectZilei;

@end
