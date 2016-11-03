//
//  GuzhangliuzhuanViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface GuzhangliuzhuanViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *WXFULLNO;

-(void)getGuzhangliuzhuan;
@end
