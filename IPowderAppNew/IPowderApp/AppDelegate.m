//
//  AppDelegate.m
//  IPowderApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "PowerUtils.h"

@implementation AppDelegate {
    UIAlertView *alertToken;
    
    
}


@synthesize token;
@synthesize passType;
@synthesize passParameterDic;
@synthesize currentLoadCount;
#define PLIST_URL @"https://dn-zyplist.qbox.me/ipower.plist"
#define VERS_FMT @"itms-services://?action=download-manifest&url=%@"




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//测试账号
    token = @"CCE05E55F95D1C9EAB08057F3E6D9426BF061608C1F65F06E0CFCC941AAE1091";
//    
    //版本更新
    [self checkVersion];
    //初始化hud
    HUD = [[MBProgressHUD alloc]initWithWindow:self.window];
    [self.window addSubview:HUD];
    currentLoadCount = 0;

    
    //设置主控制器
    self.mainCtrl = [[IPowerMainController alloc]init];
    BaseNavigationController *mainNavCtrl = [[BaseNavigationController alloc]initWithRootViewController:self.mainCtrl];
    self.window.rootViewController = mainNavCtrl;
    
    [self.window bringSubviewToFront:HUD];
    
    // Override point for customization after application launch.
    //设置navigationbar的背景图片，IOS7下需要65像素
//    UIImageView *navigationBarImage;
//    if(IOS_LEVEL<7) {
//        navigationBarImage = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NAVIGATION_BAR_HEIGHT)];
//        navigationBarImage.image = [UIImage imageNamed:@"bg_actionbar_blue.png"];
//        
//    }else {
//        navigationBarImage = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NAVIGATION_BAR_HEIGHT+STATUS_BAR_HEIGHT)];
//        navigationBarImage.image = [UIImage imageNamed:@"bg_actionbar_blue.png"];
//    }
    
    
//    [[UINavigationBar appearance] setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:33.0/255 green:63.0/255 blue:124.0/255 alpha:1] size:CGSizeMake(ScreenWidth, NAVIGATION_BAR_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    if(IOS_LEVEL<7) {
        [[UINavigationBar appearance] setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:51.0/255 green:158.0/255 blue:226.0/255 alpha:1] size:CGSizeMake(ScreenWidth, NAVIGATION_BAR_HEIGHT)] forBarMetrics:UIBarMetricsDefault];
    }else {
        UIImage *backImage = [PowerUtils createImageWithColor:[UIColor colorWithRed:51.0/255 green:158.0/255 blue:226.0/255 alpha:1] size:CGSizeMake(ScreenWidth, NAVIGATION_BAR_HEIGHT)];
        [[UINavigationBar appearance] setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];

    }

    // 要使用百度地图，请先启动BaiduMapManager
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //如果没有token，退出程序
    if(token == nil) {
        //弹出提示框
//        alertToken = [[UIAlertView alloc]initWithTitle:@"" message:@"获取认证信息失败,是否要转到i运维?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil, nil];
//        alertToken.tag = 100;
//        [alertToken show];
        
        NSString *urlStr = @"telecom://iPower/launchTelecom";
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//获取从外部app传送过来的AccessonToken
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if(!url)
        return NO;
    NSString *urlString = [url absoluteString];
    NSDictionary *passDic = [PowerUtils parsePassType:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([passDic allKeys].count != 0 ) {
        token = [passDic objectForKey:[@"accesstoken" uppercaseString]];
        passType = [passDic objectForKey:[@"passType" uppercaseString]];
        passParameterDic = passDic;
    }
    [alertToken dismissWithClickedButtonIndex:1 animated:NO];
    if(self.mainCtrl != nil ) {
        [self.mainCtrl setModuleWithType:passType parameter:passParameterDic];
    }
    
    
    return YES;
}

//显示加载指示器
-(void)showHUD {
    if(currentLoadCount == 0 ) {
        [HUD show:YES];
    }
    ++currentLoadCount;
}

//隐藏加载指示器
-(void)hideHUD {
    --currentLoadCount;
    if(currentLoadCount == 0 ) {
        [HUD hide:YES];
    }
}


//alert delegate
#pragma alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //更新版本的alertView
    if(alertView.tag  == 101) {
        if(buttonIndex == 1) {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:VERS_FMT,PLIST_URL]]];
            NSLog(@"%@",self.IPAURL);
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.IPAURL]];
            
            
            
        }
    }
    //确认
    if(alertView.tag == 100 ) {
        if(buttonIndex == 0 ) {
            NSString *urlStr = @"telecom://iPower/launchTelecom";
            NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if([[UIApplication sharedApplication] canOpenURL:url]){
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }else {
            if(token==nil)
                exit(0);
            else
                NSLog(@"enter app");
        }
    }

}

//检查版本更新
-(void)checkVersion {
//    正式：http://main.telecomsh.cn/ywglappUpdate/release/plist/ipower.plist
//    测试：http://test0.telecomsh.cn:9091/ywglappUpdate/release/plist/ipower.plist
    
    
    NSDictionary *vDic = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:UPDATE_URL]];
    
    if(vDic!=nil) {
        
        NSDictionary *item = vDic[@"items"][0];
        NSDictionary *metadata = item[@"metadata"];
        NSDictionary *assetsitem1 = item[@"assets"][0];
        
        self.IPAURL = assetsitem1[@"url"];

        
        
        
        NSString *str_net_v = metadata[@"bundle-version"];
        NSString *descriptionStr = metadata[@"version-description"];
//        if(descriptionStr == nil ) {
//            descriptionStr = @"我的资源模块添加了编辑设备详情功能 \n添加了设备巡检报告提交功能 \n修复了一些BUG";
//        }
        NSString *str_app_v = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSArray *net_v = [str_net_v componentsSeparatedByString:@"."];
        NSArray *app_v = [str_app_v componentsSeparatedByString:@"."];
        newVersion = str_net_v;
        hasNewVersion = NO;
//        for(int i=0;i<net_v.count;i++) {
//            if([net_v[i] intValue]>[app_v[i] intValue]) {
//                hasNewVersion = YES;
//                break;
//            }
//        }
        if ([str_net_v floatValue] > [str_app_v floatValue]) {
            hasNewVersion = YES;

        }
        
        if(hasNewVersion == YES ) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"有新版本，是否需要更新？" message:descriptionStr delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alertView.tag  = 101;
            [alertView show];
        }
    }

    
}
@end
