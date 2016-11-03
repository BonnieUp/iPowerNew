//
//  AppDelegate.h
//  IPowderApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPowerMainController.h"
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    MBProgressHUD * HUD;
    //版本号
    NSString *newVersion;
    //是否有新的版本号
    BOOL hasNewVersion;
    
    
    NSString *IPAURL;

    
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)NSString *IPAURL;

@property (strong,nonatomic) IPowerMainController *mainCtrl;

-(void)showHUD;
-(void)hideHUD;

//保存传递过来的token
@property (strong,nonatomic) NSString* token;
//保存传递过来的模块类型
@property (strong,nonatomic) NSString *passType;
//保存传递过来的参数
@property (strong,nonatomic) NSDictionary* passParameterDic;

@property (nonatomic) int currentLoadCount;
@end
