//
//  SuoshuxitongConditionViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-6.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"
@protocol SuoshuxitongConditionDelegate <NSObject>
@optional
//当选择设备子类以后点击提交触发
-(void)submitSuoshuxitongCondition:(NSDictionary *)dic;
@end

@interface SuoshuxitongConditionViewController : BaseModalViewController

@property (nonatomic,strong)id<SuoshuxitongConditionDelegate> delegate;

//所属系统列表
@property (nonatomic,strong)NSArray *suoshuxitongList;
//当前选中的子类类型
@property (nonatomic,strong)NSString *selectSuoshuxitong;


@end
