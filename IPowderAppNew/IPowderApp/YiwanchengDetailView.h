//
//  YiwanchengDetailView.h
//  i动力
//
//  Created by 王敏 on 16/1/8.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface YiwanchengDetailView : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    //存放信息table
    UITableView *tableView;
    NSMutableArray *checkDataList;
    //刷新控件
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

-(void)setPlanNum:(NSString *)planNum;

//barbutton数组
@property (nonatomic, strong) NSMutableArray *tabs;

@end
