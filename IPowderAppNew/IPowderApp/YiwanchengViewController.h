//
//  YiwanchengViewController.h
//  i动力
//
//  Created by 王敏 on 16/1/6.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@protocol YiwanchengDelegate <NSObject>

-(void)popYiwanchengDetailViewController:(NSString *)planNum titleLabel:(NSString *)titleLabel;

@end

@interface YiwanchengViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    UITableView *checkDataTableView;
    NSArray *checkDataList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}


-(void)getCheckData;

@property (nonatomic,strong) id<YiwanchengDelegate> delegate;


@end
