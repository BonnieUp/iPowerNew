//
//  ShebeiduanziViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-8.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
@protocol ShebeiduanziDelegate <NSObject>

- (void)popDuanziDetailWith:(NSDictionary *)dic;

@end

@interface ShebeiduanziViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

//设备dic
@property (nonatomic,strong)NSDictionary *deviceDic;

@property (nonatomic,strong)id<ShebeiduanziDelegate>delegate;

-(void)getShebeiduanzi ;

@end
