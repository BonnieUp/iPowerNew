//
//  RunTimeWarningInfoViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "RunTimeWarningInfoViewController.h"
#import "PowerDataService.h"
@interface RunTimeWarningInfoViewController ()

@end

@implementation RunTimeWarningInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"实时告警";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建滚动视图
    scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,                ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT - 40)];
    
    // Do any additional setup after loading the view.
    infoView = [WarningInfoView instanceWarningInfoView];
    [scrollerView addSubview:infoView];
    [self.view addSubview:scrollerView];
    
    //初始化数值
    [self displayWarningInfo];
}

//设置contentScrollView的内容大小
-(void)viewWillLayoutSubviews
{
    scrollerView.frame = CGRectMake(0.0,
                                          0,
                                          ScreenWidth,
                                          ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT - 40);
    [scrollerView setShowsHorizontalScrollIndicator:NO];
    [scrollerView setContentSize:CGSizeMake(ScreenWidth,480)];
}

//获取告警实时信息数据
-(void)getWarningInfoWithAlarmNum:(NSString *)alarmNum alarmType:(NSString *)alarmType {
    RequestCompleteBlock block = ^(id result) {
        _warningInfoDic = (NSDictionary *)result;
        [self displayWarningInfo];
        
        if(_delegate && [_delegate respondsToSelector:@selector(passNetUnit:)]) {
            [_delegate passNetUnit:[_warningInfoDic objectForKey:@"NETUNIT_ID"]];
        }
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getRunTimeAlarmInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] alarmNum:alarmNum alarmType:alarmType completeBlock:block loadingView:nil showHUD:YES];
}

//获取数据以后赋值
-(void)displayWarningInfo {
    infoView.gaojingInfoDic = _warningInfoDic;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setWarningDic:(NSDictionary *)warningDic {
    _warningDic = warningDic;
    [self getWarningInfoWithAlarmNum:[_warningDic objectForKey:@"ALARM_NUM"] alarmType:[_warningDic objectForKey:@"ALARM_TYPE"]];
}

@end
