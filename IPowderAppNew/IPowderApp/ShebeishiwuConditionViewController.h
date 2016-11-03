//
//  ShebeishiwuConditionViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-6.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"
@protocol ShebeishiwuConditionDelegate <NSObject>
@optional
//当选择设备大类以后点击提交触发
-(void)submitShebeishiwuCondition:(NSString *)str;
@end
@interface ShebeishiwuConditionViewController : BaseModalViewController


@property (nonatomic,strong)id<ShebeishiwuConditionDelegate> delegate;

//当前选中的设备实物
@property (nonatomic,strong)NSString *selectShiwu;

@end
