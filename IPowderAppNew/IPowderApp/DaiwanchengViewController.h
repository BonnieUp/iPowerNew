//
//  DaiwanchengViewController.h
//  i动力
//
//  Created by 王敏 on 16/1/6.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@protocol DaiwanchengDelegate <NSObject>

-(void)popDaiwanchengDetailViewController:(NSString *)planNum titleLabel:(NSString *)titleLabel;

@end

@interface DaiwanchengViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    UITableView *checkDataTableView;
    NSArray *checkDataList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}


-(void)getCheckData;

@property (nonatomic,strong) id<DaiwanchengDelegate> delegate;


@end
