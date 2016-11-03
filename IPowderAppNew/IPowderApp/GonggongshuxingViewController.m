//
//  GonggongshuxingViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-8.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GonggongshuxingViewController.h"
#import "PowerDataService.h"
@interface GonggongshuxingViewController ()

@end

@implementation GonggongshuxingViewController {
    GonggongshuxingView *infoView;
    UIScrollView *scroView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"公共属性";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40)];
    scroView.bounces = NO;
    [self.view addSubview:scroView];
    
    infoView = [GonggongshuxingView instanceGonggongshuxingView];
    [scroView addSubview:infoView];
}

//设置contentScrollView的内容大小
-(void)viewWillLayoutSubviews
{
    scroView.frame = CGRectMake(0.0,
                                    0,
                                    ScreenWidth,
                                    ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT - 40);
    [scroView setShowsHorizontalScrollIndicator:NO];
    [scroView setContentSize:CGSizeMake(ScreenWidth,676)];
}

//获取设备公共属性信息
-(void)getGonggongshuxing{
    RequestCompleteBlock block = ^(id result) {
        //赋值
        infoView.suoshufangjianLabel.text = [_deviceDic objectForKey:@"ROOM_NAME"];
        infoView.suoshuxingtongLabel.text = [_deviceDic objectForKey:@"SYS_NAME"];
        infoView.shebeileixingLabel.text = [_deviceDic objectForKey:@"DEV_TYPE_NAME"];
        infoView.touchanriqiLabel.text = [_deviceDic objectForKey:@"START_USE_DATE"];
        
        for (NSDictionary *itemDic in (NSArray *)result) {
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备名称"]) {
                infoView.shebeimingchengLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"资产编号"]) {
                infoView.zichanbianhaoLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"实物编号"]) {
                infoView.shiwubianhaoLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备型号"]) {
                infoView.shebeixinghaoLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备容量"]) {
                infoView.shebeirongliangLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"容量单位"]) {
                infoView.rongliangdanweiLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"生产日期"]) {
                infoView.shengchanriqiLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"生产产家"]) {
                infoView.shengchanchangjiaLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"备注"]) {
                infoView.beizhuLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"系统标识"]) {
                infoView.xitongbiaoshiLabel.text = [itemDic objectForKey:@"CURRENT_VALUE"];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备状态"]) {
                [self getZhuangtaiNameWithNum:[itemDic objectForKey:@"CURRENT_VALUE"]];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备性质"]) {
                NSString *enumStr = [itemDic objectForKey:@"ENUM_VALUE"];
                NSArray *enumList = [enumStr componentsSeparatedByString:@";"];
                NSMutableDictionary *enumDic = [[NSMutableDictionary alloc]init];
                for (NSString *ennumItemStr in enumList) {
                    NSArray *itemList = [ennumItemStr componentsSeparatedByString:@":"];
                    [enumDic setValue:itemList[1] forKey:itemList[0]];
                }
                
                infoView.shebeixingzhiLabel.text = [enumDic objectForKey:[itemDic objectForKey:@"CURRENT_VALUE"]];
                continue;
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"受控状态"]) {
                NSString *enumStr = [itemDic objectForKey:@"ENUM_VALUE"];
                NSArray *enumList = [enumStr componentsSeparatedByString:@";"];
                NSMutableDictionary *enumDic = [[NSMutableDictionary alloc]init];
                for (NSString *ennumItemStr in enumList) {
                    NSArray *itemList = [ennumItemStr componentsSeparatedByString:@":"];
                    [enumDic setValue:itemList[1] forKey:itemList[0]];
                }
                
                infoView.shoukongzhuangtaiLabel.text = [enumDic objectForKey:[itemDic objectForKey:@"CURRENT_VALUE"]];
                continue;
            }
        }
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getDeviceCommonInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]  devNum:[_deviceDic objectForKey:@"DEV_NUM"] completeBlock:block loadingView:nil showHUD:YES];
}

//获取设备状态
-(void)getZhuangtaiNameWithNum:(NSString *)num {
    if(_deviceStatusList) {
        for (NSDictionary *statusDic in _deviceStatusList) {
            if([[statusDic objectForKey:@"DEV_STATUS_NUM"] isEqualToString:num]) {
                infoView.shebeizhuangtaiLabel.text = [statusDic objectForKey:@"DEV_STATUS_NAME"];
                break;
            }
        }
    }
}

-(void)setDeviceDic:(NSDictionary *)deviceDic{
    if(![_deviceDic isEqual:deviceDic]) {
        _deviceDic = deviceDic;
        [self getGonggongshuxing];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
