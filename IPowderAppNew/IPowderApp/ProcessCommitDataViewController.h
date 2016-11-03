//
//  ProcessCommitDataViewController.h
//  i动力
//
//  Created by 王敏 on 14-10-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"

@protocol ProcessCommitDataDelegate <NSObject>
@optional
//当点击确定以后提交
//flowNO:故障流水号
-(void)submitData:(NSString *)flowNO;
@end

@interface ProcessCommitDataViewController : BaseModalViewController<UITextFieldDelegate>

@property (nonatomic,strong)id<ProcessCommitDataDelegate> delegate;
//是否有已完工
@property (nonatomic)BOOL hasFinish;

@end
