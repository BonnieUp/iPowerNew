//
//  CommitDataViewController.h
//  i动力
//
//  Created by 王敏 on 14-10-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//提交数据时弹出的对话窗口
#import "BaseModalViewController.h"

@protocol CommitDataDelegate <NSObject>
@optional
//当点击确定以后提交
-(void)submitData:(NSString *)isAuto;
@end

@interface CommitDataViewController : BaseModalViewController


@property (nonatomic,strong)id<CommitDataDelegate> delegate;

//自动还是手动
@property (nonatomic,strong)NSString *isAuto;

@end
