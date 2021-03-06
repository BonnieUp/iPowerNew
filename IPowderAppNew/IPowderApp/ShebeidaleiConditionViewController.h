//
//  ShebeidaleiConditionViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-6.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"
@protocol ShebeidaleiConditionDelegate <NSObject>
@optional
//当选择设备大类以后点击提交触发
-(void)submitShebeidaleiCondition:(NSDictionary *)dic;
@end
@interface ShebeidaleiConditionViewController : BaseModalViewController

@property (nonatomic,strong)id<ShebeidaleiConditionDelegate> delegate;

//当前选中的大类类型
@property (nonatomic,strong)NSString *selectDalei;

@end
