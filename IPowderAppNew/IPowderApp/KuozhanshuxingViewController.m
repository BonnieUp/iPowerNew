//
//  KuozhanshuxingViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-8.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "KuozhanshuxingViewController.h"
#import "PowerDataService.h"

@interface KuozhanshuxingViewController ()

@end

@implementation KuozhanshuxingViewController {
    UIScrollView *scroView;
    //存放扩展属性的列表
    NSArray *propertyList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"扩展属性";
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
}

//获取设备扩展属性
-(void)getKuozhanshuxing {
    RequestCompleteBlock block = ^(id result) {
        propertyList = (NSArray *)result;
        //如果么有扩展属性
        if(propertyList.count == 0 ) {
            UILabel *noneProLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (scroView.height-30)/2,ScreenWidth, 30)];
            noneProLabel.text = @"无扩展属性";
            noneProLabel.textAlignment = NSTextAlignmentCenter;
            noneProLabel.backgroundColor = [UIColor clearColor];
            [scroView addSubview:noneProLabel];
        }else {
            [self createPropertyCell];
        }
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getDeviceExtendInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devNum:[_deviceDic objectForKey:@"DEV_NUM"]  devTypeNum:@"" completeBlock:block loadingView:nil showHUD:YES];
    
    
}

-(void)createPropertyCell {
    float cellHei = 40;
    for (int i=0;i<propertyList.count; i++) {
        NSDictionary *dic = (NSDictionary *)[propertyList objectAtIndex:i];
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, cellHei*i+1, ScreenWidth, 38)];
        //创建title
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 38)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
        titleLabel.text = [dic objectForKey:@"EXT_ATTR_NAME"];
        
        //创建属性
        UILabel *proLabel = [[UILabel alloc]initWithFrame:CGRectMake(135, 0, 180,38 )];
        proLabel.textAlignment = NSTextAlignmentLeft;
        proLabel.font = [UIFont systemFontOfSize:14];
        proLabel.text = [dic objectForKey:@"CURRENT_VALUE"];
        
        [cellView addSubview:titleLabel];
        [cellView addSubview:proLabel];
        [scroView addSubview:cellView];
        
        //创建下划线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, cellHei*(i+1), ScreenWidth, 0.5)];
        seperateView.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
        [scroView addSubview:seperateView];
    }
    
    
    scroView.contentSize = CGSizeMake(ScreenWidth, cellHei*propertyList.count+1);
}

-(void)setDeviceDic:(NSDictionary *)deviceDic{
    if(![_deviceDic isEqual:deviceDic]) {
        _deviceDic = deviceDic;
        [self getKuozhanshuxing];
    }
}

@end
