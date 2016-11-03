//
//  ShebeizichanViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-6.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"
@protocol ShebeizichanConditionDelegate <NSObject>
@optional
//当选择设备大类以后点击提交触发
-(void)submitShebeizichanCondition:(NSString *)str;
@end
@interface ShebeizichanViewController : BaseModalViewController



@property (nonatomic,strong)id<ShebeizichanConditionDelegate> delegate;

//当前选中的设备资产
@property (nonatomic,strong)NSString *selectZichan;

@end
