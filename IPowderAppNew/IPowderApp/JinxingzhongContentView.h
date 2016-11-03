//
//  JinxingzhongContentView.h
//  i动力
//
//  Created by 王敏 on 16/1/11.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
@protocol JinxingzhongContentDelegate <NSObject>

-(void)popToJinxingzhongDetailViewController;

@end
@interface JinxingzhongContentView : BaseViewController

-(void)setRecordNum:(NSString *)recordNum;

-(void)setTitleStr:(NSString *)titleStr;

@property (nonatomic,strong) id<JinxingzhongContentDelegate> delegate;

@end
