//
//  IPowerMainController.h
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ZhouqiweihuLogoView.h"
#import "WodeziyuanLogoView.h"
#import "WodewangguanLogoView.h"
#import "ZhouqiweihuViewController.h"
#import "WodewangguanViewController.h"
#import "ZiyuanhechaLogoView.h"
#import "GongdianguanliLogoView.h"
#import "XudianchiguanliLogoView.h"
#import "ZhiliangfenxiLogoView.h"
#import "DongliWorkOrder.h"
#import "DongliNetworkElementView.h"
@interface IPowerMainController :  BaseViewController<UIAlertViewDelegate>{
    //中国电信LOGO
    UIImageView *logoView;
    //周期维护图标视图
    ZhouqiweihuLogoView *weihuLogo;
    //我的资源图标视图
    WodeziyuanLogoView *ziyuanLogo;
    //我的网管图标视图
    WodewangguanLogoView *wangguanLogo;
    //资源核查图标视图
    ZiyuanhechaLogoView *ziyuanhechaLogo;
    //供电管理图标视图
    GongdianguanliLogoView *gongdianguanliLogo;
    //蓄电池管理图标视图
    XudianchiguanliLogoView *xudianchiguanliLogo;
    //蓄电池管理图标视图
    ZhiliangfenxiLogoView *zhiliangfenxiLogo;
    //动力工单图标视图
    DongliWorkOrder *dongliWorkOrderLogo;
    //动力网元图标视图
    DongliNetworkElementView *dongliNetworkElementLogo;
    //跳转进来的默认模块
    NSString *enterModuleName;
    
}

//根据传递的参数来判断默认显示的是哪个模块
-(void)setModuleWithType:(NSString *)moduleType
               parameter:(NSDictionary *)dic;
@end
