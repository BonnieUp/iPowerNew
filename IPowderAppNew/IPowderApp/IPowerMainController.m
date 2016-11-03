//
//  IPowerMainController.m
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "IPowerMainController.h"
#import "BaseViewController.h"
#import "PowerDataService.h"
#import "WodeziyuanViewController.h"
#import "ZhouqiweihuViewController.h"
#import "LocationViewController.h"
#import "GongdianguanliViewController.h"
#import "XudianchiguanliViewController.h"
#import "ZiyuanhechaViewController.h"
#import "ZhiliangfenxiLogoView.h"
#import "IPowerExcelViewController.h"
#import "QualityAnalysisMangmentViewController.h"
#import "DongliNetworkElementViewController.h"
#import "DongliWorkOrderViewController.h"
@interface IPowerMainController ()

@end

@implementation IPowerMainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //设置背景颜色
        self.view.backgroundColor = [UIColor whiteColor];
        
        //监听站点更改通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(siteOnChanged:) name:KSiteChanged object:nil
         ];
        
        [self setTitleWithPosition:@"center" title:@"i动力"];

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置navigationbar左按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backActionToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
     self.navigationItem.leftBarButtonItem=backBarBtn;
    
    //LOGO图标
//    logoView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-150)/2,(ScreenHeight-50)/2-40, 150, 150)];
//    logoView.image = [UIImage imageNamed:@"logo.jpg"];
//    [self.view addSubview:logoView];
    
    //周期维护图标视图
    weihuLogo  = [[ZhouqiweihuLogoView alloc]initWithFrame:CGRectMake(20, 10, 70, 90)];
    //添加点击事件
    UITapGestureRecognizer *weihuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToZhouqiweihuView:)];
    [weihuLogo addGestureRecognizer:weihuTap];
    [self.view addSubview:weihuLogo];
    
    //我的资源图标视图
    ziyuanLogo = [[WodeziyuanLogoView alloc]initWithFrame:CGRectMake(125, 10, 70, 90)];
    UITapGestureRecognizer *ziyuanTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToZiyuanView:)];
    [ziyuanLogo addGestureRecognizer:ziyuanTap];
    [self.view addSubview:ziyuanLogo];
    
    //我的网管图标视图
    wangguanLogo = [[WodewangguanLogoView alloc]initWithFrame:CGRectMake(230, 10, 70, 90)];    //获取我的待处理任务数量和组任务数量
    UITapGestureRecognizer *wangguanTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToWangguanView:)];
    [wangguanLogo addGestureRecognizer:wangguanTap];
    [self.view addSubview:wangguanLogo];
    
    //蓄电池管理图标视图
    xudianchiguanliLogo = [[XudianchiguanliLogoView alloc]initWithFrame:CGRectMake(20, 110, 70, 90)];
    UITapGestureRecognizer *xudianchiguanliTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToXudianchiguanliView:)];
    [xudianchiguanliLogo addGestureRecognizer:xudianchiguanliTap];
    [self.view addSubview:xudianchiguanliLogo];
    
    //资源核查图标视图
    ziyuanhechaLogo = [[ZiyuanhechaLogoView alloc]initWithFrame:CGRectMake(125, 110, 70, 90)];
    UITapGestureRecognizer *ziyuanhechaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToZiyuanhechaView:)];
    [ziyuanhechaLogo addGestureRecognizer:ziyuanhechaTap];
    [self.view addSubview:ziyuanhechaLogo];
    
    //供电管理图标视图
    gongdianguanliLogo = [[GongdianguanliLogoView alloc]initWithFrame:CGRectMake(230, 110, 70, 90)];
    UITapGestureRecognizer *gongdianguanliTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToGongdianguanliView:)];
    [gongdianguanliLogo addGestureRecognizer:gongdianguanliTap];
    [self.view addSubview:gongdianguanliLogo];
    
    
    //质量分析图标视图
    zhiliangfenxiLogo = [[ZhiliangfenxiLogoView alloc]initWithFrame:CGRectMake(20, 210, 70, 90)];
    UITapGestureRecognizer *zhiliangfenxiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToZhiliangfenxiView:)];
    [zhiliangfenxiLogo addGestureRecognizer:zhiliangfenxiTap];
    [self.view addSubview:zhiliangfenxiLogo];
    
    
    //动力工单图标视图
    dongliWorkOrderLogo = [[DongliWorkOrder alloc]initWithFrame:CGRectMake(125, 210, 70, 90)];
    UITapGestureRecognizer *dongliWorkOrderLogoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToDongliWorkOrderView:)];
    [dongliWorkOrderLogo addGestureRecognizer:dongliWorkOrderLogoTap];
    [self.view addSubview:dongliWorkOrderLogo];
    
    //动力网元图标视图
    dongliNetworkElementLogo = [[DongliNetworkElementView alloc]initWithFrame:CGRectMake(230, 210, 70, 90)];
    UITapGestureRecognizer *dongliNetworkElementLogoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToDongliNetworkElementView:)];
    [dongliNetworkElementLogo addGestureRecognizer:dongliNetworkElementLogoTap];
    [self.view addSubview:dongliNetworkElementLogo];
    
    
    
    
    
    [self getMyTaskAmount];
    [self getGroupTaskAmount];
    
    
}

#pragma mark -- 跳转到动力工单
-(void)goToDongliWorkOrderView:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DongliWorkOrderStoryboard" bundle:nil];
    
    
    DongliWorkOrderViewController *dongliWorkOrderViewController = [storyboard instantiateViewControllerWithIdentifier:@"DongliWorkOrderMain"];
   
    if([sender isKindOfClass:[UITapGestureRecognizer class ]]){
        [self.navigationController pushViewController:dongliWorkOrderViewController animated:YES];
    }else{
        [self.navigationController pushViewController:dongliWorkOrderViewController animated:NO];
    }
}
#pragma mark -- 跳转到动力网元
-(void)goToDongliNetworkElementView:(id)sender
{
    DongliNetworkElementViewController *dongliNetworkElementViewController = [[DongliNetworkElementViewController alloc]init];
    
    if([sender isKindOfClass:[UITapGestureRecognizer class ]]){
        [self.navigationController pushViewController:dongliNetworkElementViewController animated:YES];
    }else{
        [self.navigationController pushViewController:dongliNetworkElementViewController animated:NO];
    }
}

//跳转到周期维护视图
-(void)goToZhouqiweihuView:(NSString *)res {
    //获取当前站点信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* siteDic = [userDefaults objectForKey:@"siteDic"];
    //如果本地没有站点信息，那么弹出定位视图
    if( siteDic == nil) {
        LocationViewController *locationCtrl = [[LocationViewController alloc]init];
        [self.navigationController pushViewController:locationCtrl animated:YES];
    }else {
        ZhouqiweihuViewController *zhouqiweihuCtrl = [[ZhouqiweihuViewController alloc]init];
        if([enterModuleName isEqualToString:module_zhouqiweihu]){
            zhouqiweihuCtrl.backToHomePage = NO;
        }else {
            zhouqiweihuCtrl.backToHomePage = YES;
        }
        zhouqiweihuCtrl.siteDic = siteDic;
        [self.navigationController pushViewController:zhouqiweihuCtrl animated:NO];
        if(res!=nil){
            [zhouqiweihuCtrl scanWithResNo:res];
        }
    }
}

//跳转到我的资源视图
-(void) goToZiyuanView:(id)sender {
    WodeziyuanViewController *wodeziyuanCtrl = [[WodeziyuanViewController alloc]init];
    if([enterModuleName isEqualToString:module_ziyuanxunjian]) {
                    wodeziyuanCtrl.backToHomePage = NO;
                }else {
                    wodeziyuanCtrl.backToHomePage = YES;
                }
    if([sender isKindOfClass:[UITapGestureRecognizer class ]]){
        [self.navigationController pushViewController:wodeziyuanCtrl animated:YES];
    }else{
        [self.navigationController pushViewController:wodeziyuanCtrl animated:NO];
    }
    //先获取区局列表数据
//    PowerDataService *dataService = [[PowerDataService alloc]init];
//    RequestCompleteBlock block = ^(id result) {
//        NSArray* regionList = (NSArray *)result;
//        //如果不为空，将第一个作为默认选择区局
//        if(regionList.count > 0) {
//            WodeziyuanViewController *wodeziyuanCtrl = [[WodeziyuanViewController alloc]init];
//            if([enterModuleName isEqualToString:module_ziyuanxunjian]) {
//                wodeziyuanCtrl.backToHomePage = NO;
//            }else {
//                wodeziyuanCtrl.backToHomePage = YES;
//            }
//            wodeziyuanCtrl.regionList = regionList;
//            [self.navigationController pushViewController:wodeziyuanCtrl animated:YES];
//        }else{
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您无权访问.." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            alertView.tag = 101;
//            alertView.delegate = self;
//            [alertView show];
//            return;
//        }
//        
//    };
//    [dataService getUserRegionDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:nil showHUD:YES];
    

}

//跳转到我的网管视图
-(void)goToWangguanView:(id)sender {
    WodewangguanViewController *wodewangguanCtrl = [[WodewangguanViewController alloc]init];
    wodewangguanCtrl.titleStr = @"我的网管";
    if([enterModuleName isEqualToString:module_dongliwangguan]) {
        wodewangguanCtrl.backToHomePage = NO;
    }else {
        wodewangguanCtrl.backToHomePage = YES;
    }
    if([sender isKindOfClass:[UITapGestureRecognizer class ]]){
        [self.navigationController pushViewController:wodewangguanCtrl animated:YES];
    }else{
        [self.navigationController pushViewController:wodewangguanCtrl animated:NO];
    }
   

//    //首先获取该用户的区局信息
//    PowerDataService *dataService = [[PowerDataService alloc]init];
//    RequestCompleteBlock block = ^(id result) {
//        NSMutableArray *legalAreaList = [[NSMutableArray alloc]init];
//        NSArray *areaList = (NSArray *)result;
//        for (NSDictionary *dic  in areaList ) {
//            if([[dic objectForKey:@"IS_CAN_ACCESS"] isEqualToString:@"1"]) {
//                [legalAreaList addObject:dic];
//            }
//        }
//        //如果区局为0，提示没有权限，点击确定返回到i运维
//        if(legalAreaList.count == 0 ) {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您无权访问.." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            alertView.tag = 100;
//            alertView.delegate = self;
//            [alertView show];
//            return;
//        }else if(legalAreaList.count == 1 ) {
//            NSString *areaName = [[legalAreaList objectAtIndex:0] objectForKey:@"REG_NAME"];
//            WodewangguanViewController *wodewangguanCtrl = [[WodewangguanViewController alloc]init];
//            wodewangguanCtrl.titleStr = [NSString stringWithFormat:@"我的网管(%@)",areaName];
//            wodewangguanCtrl.siteList = legalAreaList;
//            if([enterModuleName isEqualToString:module_dongliwangguan]) {
//                wodewangguanCtrl.backToHomePage = NO;
//            }else {
//                wodewangguanCtrl.backToHomePage = YES;
//            }
//            [self.navigationController pushViewController:wodewangguanCtrl animated:YES];
//        }else if(legalAreaList.count > 1 && legalAreaList.count < areaList.count ) {
//            WodewangguanViewController *wodewangguanCtrl = [[WodewangguanViewController alloc]init];
//            wodewangguanCtrl.titleStr = @"我的网管(多区局)";
//            wodewangguanCtrl.siteList = legalAreaList;
//            if([enterModuleName isEqualToString:module_dongliwangguan]) {
//                wodewangguanCtrl.backToHomePage = NO;
//            }else {
//                wodewangguanCtrl.backToHomePage = YES;
//            }
//            [self.navigationController pushViewController:wodewangguanCtrl animated:YES];
//        }else {
//            WodewangguanViewController *wodewangguanCtrl = [[WodewangguanViewController alloc]init];
//            wodewangguanCtrl.titleStr = @"我的网管(全网)";
//            wodewangguanCtrl.siteList = legalAreaList;
//            if([enterModuleName isEqualToString:module_dongliwangguan]) {
//                wodewangguanCtrl.backToHomePage = NO;
//            }else {
//                wodewangguanCtrl.backToHomePage = YES;
//            }
//            [self.navigationController pushViewController:wodewangguanCtrl animated:YES];
//        }
//        
//    };
//    [dataService getUserAreaDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:nil showHUD:YES];
}



//质量分析页面
-(void)goToZhiliangfenxiView:(id)sender{
    
//    GongdianguanliViewController *gongdianguanliCtrl = [[GongdianguanliViewController alloc]init];
    QualityAnalysisMangmentViewController *VC = [[QualityAnalysisMangmentViewController alloc]init];

    if([enterModuleName isEqualToString:module_donghuanbaobiao]) {
        VC.backToHomePage = NO;
    }else {
        VC.backToHomePage = YES;
    }
    if([sender isKindOfClass:[UITapGestureRecognizer class ]]){
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self.navigationController pushViewController:VC animated:NO];
    }
    
    
//    QualityAnalysisMangmentViewController *VC = [[QualityAnalysisMangmentViewController alloc]init];
////    IPowerExcelViewController *VC = [[IPowerExcelViewController alloc]init];
//    [self.navigationController pushViewController:VC animated:NO];
}
//跳转到供电管理视图
-(void)goToGongdianguanliView:(id)sender{
    GongdianguanliViewController *gongdianguanliCtrl = [[GongdianguanliViewController alloc]init];
    if([enterModuleName isEqualToString:module_gongdiandengji]) {
        gongdianguanliCtrl.backToHomePage = NO;
    }else {
        gongdianguanliCtrl.backToHomePage = YES;
    }
    if([sender isKindOfClass:[UITapGestureRecognizer class ]]){
        [self.navigationController pushViewController:gongdianguanliCtrl animated:YES];
    }else{
        [self.navigationController pushViewController:gongdianguanliCtrl animated:NO];
    }
    
}

//跳转到蓄电池管理视图
-(void)goToXudianchiguanliView:(id)sender{
    XudianchiguanliViewController *xudianchiguanliCtrl = [[XudianchiguanliViewController alloc]init];
    if([enterModuleName isEqualToString:module_xudianchiguanli]) {
        xudianchiguanliCtrl.backToHomePage = NO;
    }else {
        xudianchiguanliCtrl.backToHomePage = YES;
    }
    if([sender isKindOfClass:[UITapGestureRecognizer class ]]){
        [self.navigationController pushViewController:xudianchiguanliCtrl animated:YES];
    }else{
        [self.navigationController pushViewController:xudianchiguanliCtrl animated:NO];
    }
}

//跳转到资源核查视图
-(void)goToZiyuanhechaView:(id)sender{
    ZiyuanhechaViewController *ziyuanhechaCtrl = [[ZiyuanhechaViewController alloc]init];
    if([enterModuleName isEqualToString:module_ziyuanhecha]) {
        ziyuanhechaCtrl.backToHomePage = NO;
    }else {
        ziyuanhechaCtrl.backToHomePage = YES;
    }
    if([sender isKindOfClass:[UITapGestureRecognizer class ]]){
        [self.navigationController pushViewController:ziyuanhechaCtrl animated:YES];
    }else{
        [self.navigationController pushViewController:ziyuanhechaCtrl animated:NO];
    }
}

#pragma mark ----alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //我的网管alertview
    if(alertView.tag == 100 || alertView.tag == 101 ){
        //返回到i运维
        NSString *urlStr = @"telecom://iPower/launchTelecom";
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}

//获取我的待处理任务数量
-(void)getMyTaskAmount
{
    PowerDataService *service = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        weihuLogo.myTaskAmount = (NSString *)result;
    };
    [service getTaskAmountWithAccessToken:AccessToken
                            operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]taskScope:@"1" taskStatus:@"1" startDate:[PowerUtils getFirstDay:@"yyyy-MM-dd"] endDate:[PowerUtils getLastDay:@"yyyy-MM-dd"] completeBlock:block loadingView:nil showHUD:NO];
}

//获取组任务数量
-(void)getGroupTaskAmount {
    PowerDataService *service = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        weihuLogo.groupTaskAmount = (NSString *)result;
    };
    [service getTaskAmountWithAccessToken:AccessToken
                            operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]taskScope:@"2" taskStatus:@"1" startDate:[PowerUtils getFirstDay:@"yyyy-MM-dd"] endDate:[PowerUtils getLastDay:@"yyyy-MM-dd"] completeBlock:block loadingView:nil showHUD:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//站点更改
-(void)siteOnChanged:(NSNotification *)notification {
    NSString *res = notification.object;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    //弹出我的维护任务视图
    [self goToZhouqiweihuView:res];
//    ZhouqiweihuViewController *zhouqiweihuCtrl = [[ZhouqiweihuViewController alloc]init];
//    zhouqiweihuCtrl.siteDic = siteDic;
//    [self.navigationController pushViewController:zhouqiweihuCtrl animated:YES];
}


-(void)setModuleWithType:(NSString *)moduleType parameter:(NSDictionary *)dic{
    enterModuleName = moduleType;
    //首先跳到主页
    [self.navigationController popToViewController:self animated:NO];
    //如果是周期维护模块
    if([moduleType isEqualToString:module_zhouqiweihu] ) {
        //设置默认站点
        NSMutableDictionary *siteDic = [[NSMutableDictionary alloc]init];
        [siteDic setValue:[dic objectForKey:[@"siteId" uppercaseString]] forKey:@"siteId"];
        [siteDic setValue:[dic objectForKey:[@"siteName" uppercaseString]] forKey:@"siteName"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:siteDic forKey:@"siteDic"];
        [userDefaults synchronize];
        
        [self goToZhouqiweihuView:nil];
    }
    //如果是资源巡检模块
    if([moduleType isEqualToString:module_ziyuanxunjian]) {
        
        [self goToZiyuanView:nil];
    }
    //如果是我的网管
    if([moduleType isEqualToString:module_dongliwangguan]) {
        [self goToWangguanView:nil];
    }
    //如果是蓄电池测试
    if([moduleType isEqualToString:module_xudianchiguanli]) {
        [self goToXudianchiguanliView:nil];
    }
    //如果是动力资源核查
    if([moduleType isEqualToString:module_ziyuanhecha]) {
        [self goToZiyuanhechaView:nil];
    }
    //如果是供电管理
    if([moduleType isEqualToString:module_gongdiandengji]) {
        [self goToGongdianguanliView:nil];
    }
    //如果是动环境报
    if([moduleType isEqualToString:module_donghuanbaobiao]) {
        [self goToZhiliangfenxiView:nil];
    }
}


//跳转到主程序
-(void)backActionToMain {
//    NSString *urlStr;
//    if(enterModuleName != nil) {
//        urlStr = [NSString stringWithFormat:@"Telecom://iPower/returnTelecom?fnType=%@",enterModuleName];
//    }else {
//        urlStr = @"Telecom://iPower/launchTelecom";
//    }
//    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:url];
    NSString *urlStr = @"telecom://iPower/launchTelecom";
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    
}
@end
