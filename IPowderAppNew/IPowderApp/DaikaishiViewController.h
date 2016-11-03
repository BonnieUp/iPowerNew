//
//  DaikaishiViewController.h
//  i动力
//
//  Created by 王敏 on 16/1/6.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
@protocol DaikaishiDelegate <NSObject>

-(void)popDaikaishiDetailViewController:(NSString *)planNum titleLabel:(NSString *)titleLabel;

@end

@interface DaikaishiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    UITableView *checkDataTableView;
    NSArray *checkDataList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}


-(void)getCheckData;

@property (nonatomic,strong) id<DaikaishiDelegate> delegate;

@end
