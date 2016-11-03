//
//  JinxingzhongDetailView.h
//  i动力
//
//  Created by 王敏 on 16/1/8.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "JinxingzhongContentView.h"
@interface JinxingzhongDetailView : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,JinxingzhongContentDelegate>

-(void)setPlanNum:(NSString *)planNum;

@property (nonatomic,strong) NSString *titleStr;

//barbutton数组
@property (nonatomic, strong) NSMutableArray *tabs;

@end
