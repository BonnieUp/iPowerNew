//
//  DeviceReportViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-16.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "DeviceReportViewController.h"
#import "PowerDataService.h"

@interface DeviceReportViewController ()

@end

@implementation DeviceReportViewController {
    //抽查设备数量
    int deviceAmount;
    //存在问题的设备数量
    int faultAmount;
    //设备信息准确率;
    int correctPrecent;
    
    
    UILabel *deviceAmountLabel;
    UILabel *faultAmountLabel;
    UILabel *precentLabel;
    UITextField *faultDetailField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"巡检结果"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    deviceAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, ScreenWidth, 30)];
    deviceAmountLabel.font = [UIFont systemFontOfSize:14];
    deviceAmountLabel.textAlignment = NSTextAlignmentLeft;
    deviceAmountLabel.text = @"抽查设备数量:";
    [self.view addSubview:deviceAmountLabel];
    
    faultAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, ScreenWidth, 30)];
    faultAmountLabel.font = [UIFont systemFontOfSize:14];
    faultAmountLabel.textAlignment = NSTextAlignmentLeft;
    faultAmountLabel.text = @"存在问题的设备数量:";
    [self.view addSubview:faultAmountLabel];
    
    precentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 65, ScreenWidth, 30)];
    precentLabel.font = [UIFont systemFontOfSize:14];
    precentLabel.textAlignment = NSTextAlignmentLeft;
    precentLabel.text = @"设备信息准确率:";
    [self.view addSubview:precentLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 95, ScreenWidth, 30)];
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.text = @"存在具体问题:";
    [self.view addSubview:descriptionLabel];
    
    
//    faultDetailField = [[UITextField alloc]initWithFrame:CGRectMake(5, 125, ScreenWidth-10, 200)];
//    faultDetailField.layer.borderWidth = 0.5f;
//    faultDetailField.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1].CGColor;
//    faultDetailField.font = [UIFont systemFontOfSize:14];
//    faultDetailField.textAlignment = NSTextAlignmentLeft;
//    faultDetailField.placeholder = @"存在的问题描述";
//    faultDetailField.delegate = self;
//    [self.view addSubview:faultDetailField];
    
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40, ScreenWidth, 40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    UIGlossyButton *submitReportBtn = [[UIGlossyButton alloc]init];
    submitReportBtn.frame = CGRectMake(10, 5,ScreenWidth-20, 30);
    [submitReportBtn setTitle:@"提交巡检结果" forState:UIControlStateNormal];
    [submitReportBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitReportBtn addTarget:self action:@selector(submitReportHandler) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:submitReportBtn];
    
    [self.view addSubview:operationView];
    
    //添加tap事件
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
//    [tapGes addTarget:self action:@selector(hideKeyboard) ];
//    [self.view addGestureRecognizer:tapGes];
    
}

//-(void)hideKeyboard {
//    // 发送resignFirstResponder.
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//}


-(void)setStationNum:(NSString *)stationNum {
    _stationNum = stationNum;
    [self getReportData];
}
-(void)getReportData {
    deviceAmount = 0;
    faultAmount = 0;
    correctPrecent = 100;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *localDeviceList = [userDefaults objectForKey:_stationNum];
    //找到当前的设备
    for (NSDictionary *dic in localDeviceList) {
        deviceAmount++;
        if([[dic objectForKey:@"modifyed"] isEqualToString:@"YES"]) {
            faultAmount++;
        }
    }
    
    if(deviceAmount!=0) {
        correctPrecent = (deviceAmount-faultAmount)*100/deviceAmount;
    }
    
    deviceAmountLabel.text = [NSString stringWithFormat:@"抽查设备数量:  %i",deviceAmount];
    faultAmountLabel.text = [NSString stringWithFormat:@"存在问题的设备数量:  %i",faultAmount];
    precentLabel.text = [NSString stringWithFormat:@"设备信息准确率:  %i%% ",correctPrecent];
}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [faultDetailField resignFirstResponder];
//    return YES;
//}

-(void)submitReportHandler {
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *localDeviceList = [userDefaults objectForKey:_stationNum];
    //找到当前的设备
    for (NSDictionary *dic in localDeviceList) {
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
        [newDic setValue:[dic objectForKey:@"DEV_NUM"] forKey:@"DEV_NUM"];
        if([[dic objectForKey:@"modifyed"] isEqualToString:@"YES"]) {
            [newDic setValue:@"2" forKey:@"CHECK_STATUS"];
        }else {
            [newDic setValue:@"1" forKey:@"CHECK_STATUS"];
        }
        [jsonArray addObject:newDic];
    }
    [jsonDic setValue:jsonArray forKey:@"CheckData"];
    
    NSError *error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:jsonDic
                                                      options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str;
    if(jsonData.length > 0 && error == nil ) {
        str= [[NSString alloc] initWithData:jsonData
                                   encoding:NSUTF8StringEncoding];
    }else {
        NSLog(@"生成json格式有误--巡检报告");
    }
    
    //提交巡检报告
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:(NSString *)result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    };
    [dataService saveDeviceReportWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] checkInfo:str completeBlock:block loadingView:nil showHUD:NO];
}

@end
