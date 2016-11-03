//
//  XudianchineizuceshiViewController.h
//  i动力
//
//  Created by 王敏 on 15/12/30.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
@protocol XudianchineizuDelegate <NSObject>

-(void)popNeizuFilterConditionController;

@end

@interface XudianchineizuceshiViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate>{
    //存放测试信息table
    UITableView *tableView;
    NSMutableArray *batteryList;
    //刷新控件
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    //按钮
    UIGlossyButton *searchBtn;
    UIView *operationView;
}

//获取蓄电池放电测试数据
-(void)getXudianchiDataWithRegNum:(NSString *)regNum
                      testTypeNum:(NSString *)testTypeNum
                          staName:(NSString *)staName
                          sysName:(NSString *)sysName
                        assetsNum:(NSString *)assetsNum
                       articleNum:(NSString *)articleNum
                        startTime:(NSString *)startTime
                         stopTime:(NSString *)stopTime;

@property (nonatomic,strong )NSString *regNO;

@property (nonatomic,strong) id<XudianchineizuDelegate> delegate;

@end
