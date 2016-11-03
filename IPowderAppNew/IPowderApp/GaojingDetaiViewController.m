//
//  GaojingDetaiViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GaojingDetaiViewController.h"
#import "PowerDataService.h"
@interface GaojingDetaiViewController ()

@end

@implementation GaojingDetaiViewController {
    UILabel *nameValueLabel;
    UILabel *typeValueLabel;
    UILabel *yuanyinValueLabel;
    UILabel *weizhiValueLabel;
    UILabel *jibieValueLabel;
    UILabel *fashengshijianValueLabel;
    UILabel *tongdaohaoValueLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"设备告警详情"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建滚动视图
    scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,                ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    
    // Do any additional setup after loading the view.
    infoView = [WarningInfoView instanceWarningInfoView];
    [scrollerView addSubview:infoView];
    [self.view addSubview:scrollerView];
    
    //初始化数值
    [self displayWarningInfo];
//    jibieList = [[NSMutableArray alloc]initWithObjects:@"严重告警",@"一般告警",@"重大告警", nil];
    // Do any additional setup after loading the view.
    //设备名称
//    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 39)];
//    nameLabel.text = @"设备名称";
//    nameLabel.font = [UIFont systemFontOfSize:14];
//    nameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    nameLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:nameLabel];
//    
//    nameValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, ScreenWidth-90, 39)];
//    nameValueLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:nameValueLabel];
//    
//    //设备类型
//    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 80, 39)];
//    typeLabel.text = @"设备类型";
//    typeLabel.font = [UIFont systemFontOfSize:14];
//    typeLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    typeLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:typeLabel];
//    
//    typeValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, ScreenWidth-90, 39)];
//    typeValueLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:typeValueLabel];
//    
//    //告警原因
//    UILabel *yuanyinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 80, 39)];
//    yuanyinLabel.text = @"告警原因";
//    yuanyinLabel.font = [UIFont systemFontOfSize:14];
//    yuanyinLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    yuanyinLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:yuanyinLabel];
//    
//    yuanyinValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 80, ScreenWidth-90, 39)];
//    yuanyinValueLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:yuanyinValueLabel];
//    
//    //告警位置
//    UILabel *weizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 80, 39)];
//    weizhiLabel.text = @"告警位置";
//    weizhiLabel.font = [UIFont systemFontOfSize:14];
//    weizhiLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    weizhiLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:weizhiLabel];
//    
//    weizhiValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 120, ScreenWidth-90, 39)];
//    weizhiValueLabel.numberOfLines = 2;
//    weizhiValueLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:weizhiValueLabel];
//    
//    //告警级别
//    UILabel *jibieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, 80, 39)];
//    jibieLabel.text = @"告警级别";
//    jibieLabel.font = [UIFont systemFontOfSize:14];
//    jibieLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    jibieLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:jibieLabel];
//    
//    jibieValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 160, ScreenWidth-90, 39)];
//    jibieValueLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:jibieValueLabel];
//    
//    //告警发生时间
//    UILabel *fashengshijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 80, 39)];
//    fashengshijianLabel.text = @"告警发生时间";
//    fashengshijianLabel.font = [UIFont systemFontOfSize:14];
//    fashengshijianLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    fashengshijianLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:fashengshijianLabel];
//    
//    fashengshijianValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 200, ScreenWidth-90, 39)];
//    fashengshijianValueLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:fashengshijianValueLabel];
//    
//    //通道号
//    UILabel *tongdaohaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 240, 80, 39)];
//    tongdaohaoLabel.text = @"通道号";
//    tongdaohaoLabel.font = [UIFont systemFontOfSize:14];
//    tongdaohaoLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
//    tongdaohaoLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:tongdaohaoLabel];
//    
//    tongdaohaoValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 240, ScreenWidth-90, 39)];
//    tongdaohaoValueLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:tongdaohaoValueLabel];
//    
//    
//    //添加横线
//    for(int i=0;i<7;i++) {
//        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), ScreenWidth, 1)];
//        seperateView.backgroundColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1];
//        [self.view addSubview:seperateView];
//    }
}
//-(void)setGaojingDic:(NSDictionary *)gaojingDic {
//    _gaojingDic = gaojingDic;
//    nameValueLabel.text = [_gaojingDic objectForKey:@"DEV_NAME"];
//    typeValueLabel.text = [_gaojingDic objectForKey:@"DEV_CLASS_NAME"];
//    yuanyinValueLabel.text = [_gaojingDic objectForKey:@"ALARM_DESCRIPT"];
//    weizhiValueLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[_gaojingDic objectForKey:@"REG_NAME"],[_gaojingDic objectForKey:@"STATION_NAME"],[_gaojingDic objectForKey:@"ROOM_NAME"]];
//    jibieValueLabel.text = [_gaojingDic objectForKey:@"ALARM_LEVEL_NAME"];
//    fashengshijianValueLabel.text = [_gaojingDic objectForKey:@"ALARM_TIME"];
//    tongdaohaoValueLabel.text = [_gaojingDic objectForKey:@"POINT_NAME"];
//}

//设置contentScrollView的内容大小
-(void)viewWillLayoutSubviews
{
    scrollerView.frame = CGRectMake(0.0,
                                    0,
                                    ScreenWidth,
                                    ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [scrollerView setShowsHorizontalScrollIndicator:NO];
    [scrollerView setContentSize:CGSizeMake(ScreenWidth,480)];
}

//获取告警实时信息数据
-(void)getWarningInfoWithAlarmNum:(NSString *)alarmNum alarmType:(NSString *)alarmType {
    RequestCompleteBlock block = ^(id result) {
        _warningInfoDic = (NSDictionary *)result;
        [self displayWarningInfo];
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
    if(![_warningDic isEqual:warningDic]) {
        _warningDic = warningDic;
        [self getWarningInfoWithAlarmNum:[_warningDic objectForKey:@"ALARM_NUM"] alarmType:[_warningDic objectForKey:@"ALARM_TYPE"]];
    }
}


@end
