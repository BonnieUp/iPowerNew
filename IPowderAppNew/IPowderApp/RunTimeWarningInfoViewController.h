//
//  RunTimeWarningInfoViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "WarningInfoView.h"
@protocol RunTimeWarningInfoDelegate <NSObject>

-(void)passNetUnit:(NSString *)netUnitId;

@end

@interface RunTimeWarningInfoViewController : BaseViewController {
    WarningInfoView *infoView;
    UIScrollView *scrollerView;
}

//告警信息数据
@property (nonatomic ,strong )NSDictionary *warningDic;

//告警实时信息数据
@property (nonatomic,strong)NSDictionary *warningInfoDic;

@property (nonatomic,strong)id<RunTimeWarningInfoDelegate> delegate;

@end
