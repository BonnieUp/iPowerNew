//
//  EditGonggongshuxingViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "EditGonggongshuxingViewController.h"
#import "PowerDataService.h"
#import "EditPropertyCell.h"
#import "BaseNavigationController.h"

@interface EditGonggongshuxingViewController () {
    //站点名称
    NSString *stationName;
    NSString *stationNum;
    
    EditPropertyCell *shebeimingchengCell;
    EditPropertyCell *suoshufangjianCell;
    EditPropertyCell *suoshuxitongCell;
    EditPropertyCell *shebeileixingCell;
    EditPropertyCell *shebeizhuangtaiCell;
    EditPropertyCell *zichanbianhaoCell;
    EditPropertyCell *shiwubianhaoCell;
    EditPropertyCell *touchanriqiCell;
    EditPropertyCell *shengchanriqiCell;
    EditPropertyCell *shengchanchangjiaCell;
    EditPropertyCell *shebeirongliangCell;
    EditPropertyCell *rongliangdanweiCell;
    EditPropertyCell *shebeixingzhiCell;
    EditPropertyCell *shoukongzhuangtaiCell;
    EditPropertyCell *shebeixinghaoCell;
    EditPropertyCell *xitongbiaoshiCell;
    EditPropertyCell *beizhuCell;
    UIScrollView *scroView;
    UIView *operationView;
    UIGlossyButton *submitBtn;
    
}

@end

@implementation EditGonggongshuxingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"公共属性";
        //监听键盘显示事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHandler:) name:UIKeyboardDidShowNotification object:nil];
        //监听键盘隐藏事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideHandler:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80)];
    scroView.contentSize = CGSizeMake(ScreenWidth, 680);
    scroView.bounces = NO;
    [self.view addSubview:scroView];
    
    //添加操作栏
    //添加操作按钮
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0,scroView.bottom,ScreenWidth,40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    //全选按钮
    submitBtn = [[UIGlossyButton alloc]init];
    submitBtn.frame = CGRectMake(5, 5, ScreenWidth-10, 30);
    [submitBtn setTitle:@"提交数据" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitBtn addTarget:self action:@selector(submitHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:submitBtn];
    [self.view addSubview:operationView];
    
    //添加tap事件
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(hideKeyboard) ];
    [self.view addGestureRecognizer:tapGes];
}



//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //当键盘显示时，重新设置scroller的contentsize;
    scroView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-keyboardSize.height-80);
    scroView.contentSize = CGSizeMake(ScreenWidth, 680);
    operationView.frame = CGRectMake(0, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-keyboardSize.height-80, ScreenWidth,40);
    
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    scroView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40);
    scroView.contentSize = CGSizeMake(ScreenWidth, 680);
    
    operationView.frame = CGRectMake(0,ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-80,ScreenWidth,40);
}

-(void)hideKeyboard {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//设置contentScrollView的内容大小
//-(void)viewWillLayoutSubviews
//{
//    scroView.frame = CGRectMake(0.0,
//                                0,
//                                ScreenWidth,
//                                ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT - 80);
//    [scroView setShowsHorizontalScrollIndicator:NO];
//    [scroView setContentSize:CGSizeMake(ScreenWidth,680)];
//}

-(void)setDeviceDic:(NSDictionary *)deviceDic{
    if(![_deviceDic isEqual:deviceDic]) {
        _deviceDic = deviceDic;
        [self getGonggongshuxing];
    }
}

//提交数据
-(void)submitHandler:(UIButton*)sender {
    [self hideKeyboard];
    UIAlertView *alertView;
    //先检查必填的是否有值
    if([shebeimingchengCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shebeimingchengCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([suoshufangjianCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[suoshufangjianCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([suoshuxitongCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[suoshuxitongCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shebeileixingCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shebeileixingCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shebeizhuangtaiCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shebeizhuangtaiCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([zichanbianhaoCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[zichanbianhaoCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shiwubianhaoCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shiwubianhaoCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([touchanriqiCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[touchanriqiCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shengchanriqiCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shengchanriqiCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shengchanchangjiaCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shengchanchangjiaCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shebeirongliangCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shebeirongliangCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([rongliangdanweiCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[rongliangdanweiCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shebeixingzhiCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shebeixingzhiCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shoukongzhuangtaiCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shoukongzhuangtaiCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([shebeixinghaoCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[shebeixinghaoCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([xitongbiaoshiCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[xitongbiaoshiCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([beizhuCell validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[beizhuCell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    BOOL isEdit = shebeimingchengCell.isEdited ||
    suoshufangjianCell.isEdited  ||
    suoshuxitongCell.isEdited  ||
    shebeileixingCell.isEdited  ||
    shebeizhuangtaiCell.isEdited  ||
    zichanbianhaoCell.isEdited  ||
    shiwubianhaoCell.isEdited  ||
    touchanriqiCell.isEdited  ||
    shengchanchangjiaCell.isEdited  ||
    shengchanchangjiaCell.isEdited  ||
    shebeirongliangCell.isEdited  ||
    rongliangdanweiCell.isEdited  ||
    shebeixingzhiCell.isEdited  ||
    shoukongzhuangtaiCell.isEdited  ||
    shebeixinghaoCell.isEdited  ||
    xitongbiaoshiCell.isEdited ||
    beizhuCell.isEdited;
    //如果修改过，将设备的modifyed设置为YES
    if(isEdit == YES ) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *localDeviceList = [userDefaults objectForKey:stationNum];
        NSMutableArray *newDeviceList = [[NSMutableArray alloc]init];
        //找到当前的设备
        for (NSDictionary *dic in localDeviceList) {
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
            if([[newDic objectForKey:@"DEV_NUM"] isEqualToString:[_deviceDic objectForKey:@"DEV_NUM"]]) {
                [newDic setValue:@"YES" forKey:@"modifyed"];
                [newDic setValue:[[shebeileixingCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_TYPE_NUM"];
            }
            [newDeviceList addObject:newDic];
        }
        [userDefaults setObject:newDeviceList forKey:stationNum];
        [userDefaults synchronize];
    }

    //发送保存设备属性的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"saveCommonDeviceProperty" object:nil];
    
}

//获取设备公共属性信息
-(void)getGonggongshuxing{
    RequestCompleteBlock block = ^(id result) {
        //赋值
        for (NSDictionary *itemDic in (NSArray *)result) {
            //获取站点名称和站点编号
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"站点编号"]) {
                stationNum = [itemDic objectForKey:@"ORIGINAL_VALUE"];
            }
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"站点名称"]) {
                stationName = [itemDic objectForKey:@"ORIGINAL_VALUE"];
            }
            //设备名称
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备名称"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 0, ScreenWidth, 40);
                shebeimingchengCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"设备名称" oriValue:oriValueDic type:controllerType];
                [scroView addSubview:shebeimingchengCell];
                continue;
            }
            //所属房间
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"房间编号"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[_deviceDic objectForKey:@"ROOM_NAME"] forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 40, ScreenWidth, 40);
                suoshufangjianCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"所属房间" oriValue:oriValueDic type:controllerType];
                NSMutableArray *enumDatasource = [[NSMutableArray alloc]init];
                for (NSMutableDictionary *item in _roomList) {
                    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
                    [newDic setValue:[item objectForKey:@"ROOM_NAME"] forKey:@"name"];
                    [newDic setValue:[item objectForKey:@"ROOM_NUM"] forKey:@"value"];
                    [enumDatasource addObject:newDic];
                }
                suoshufangjianCell.enumDataSource = enumDatasource;
                [scroView addSubview:suoshufangjianCell];
                continue;
            }
            //所属系统
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"系统编号"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[_deviceDic objectForKey:@"SYS_NAME"] forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 80, ScreenWidth, 40);
                suoshuxitongCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"所属系统" oriValue:oriValueDic type:controllerType];
                NSMutableArray *enumDatasource = [[NSMutableArray alloc]init];
                for (NSMutableDictionary *item in _suoshuxitongList) {
                    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
                    [newDic setValue:[item objectForKey:@"SYS_NAME"] forKey:@"name"];
                    [newDic setValue:[item objectForKey:@"SYS_NUM"] forKey:@"value"];
                    [enumDatasource addObject:newDic];
                }
                suoshuxitongCell.enumDataSource = enumDatasource;
                [scroView addSubview:suoshuxitongCell];
                continue;
            }
            //设备类型
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备类型"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[_deviceDic objectForKey:@"DEV_TYPE_NAME"] forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 120, ScreenWidth, 40);
                shebeileixingCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"设备类型" oriValue:oriValueDic type:controllerType];
                EditPropertyPopWindowBlock block = ^(NSMutableDictionary *dic) {
                    EditShebeileixingViewController *editShebeileixingCtrl = [[EditShebeileixingViewController alloc]init];
                    editShebeileixingCtrl.oriTypeName = [dic objectForKey:@"name"];
                    editShebeileixingCtrl.delegate = self;
                    BaseNavigationController *rootController = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [rootController pushViewController:editShebeileixingCtrl animated:YES];
                    
                };
                shebeileixingCell.selfBlock = block;
                [scroView addSubview:shebeileixingCell];
                continue;
            }
            //设备状态
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备状态"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }

                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];


                NSMutableArray *enumDatasource = [[NSMutableArray alloc]init];
                for (NSMutableDictionary *item in _deviceStatusList) {
                    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
                    [newDic setValue:[item objectForKey:@"DEV_STATUS_NAME"] forKey:@"name"];
                    [newDic setValue:[item objectForKey:@"DEV_STATUS_NUM"] forKey:@"value"];
                    [enumDatasource addObject:newDic];
                    
                    if([[item objectForKey:@"DEV_STATUS_NUM"] isEqualToString:[itemDic objectForKey:@"CURRENT_VALUE"] ]) {
                        [oriValueDic setValue:[item objectForKey:@"DEV_STATUS_NAME"]  forKey:@"name"];
                    }
                }
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 160, ScreenWidth, 40);
                shebeizhuangtaiCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"设备状态" oriValue:oriValueDic type:controllerType];
                shebeizhuangtaiCell.enumDataSource = enumDatasource;
                [scroView addSubview:shebeizhuangtaiCell];
                continue;
            }
            //资产编号
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"资产编号"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 200, ScreenWidth, 40);
                
                NSMutableArray *enumDataSource = [self createEnumList:[itemDic objectForKey:@"ENUM_VALUE"]];
                zichanbianhaoCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"资产编号" oriValue:oriValueDic type:controllerType];
                zichanbianhaoCell.enumDataSource = enumDataSource;
                [scroView addSubview:zichanbianhaoCell];
                continue;
            }
            //实物编号
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"实物编号"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 240, ScreenWidth, 40);
                NSMutableArray *enumDataSource = [self createEnumList:[itemDic objectForKey:@"ENUM_VALUE"]];
                shiwubianhaoCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"实物编号" oriValue:oriValueDic type:controllerType];
                shiwubianhaoCell.enumDataSource = enumDataSource;
                [scroView addSubview:shiwubianhaoCell];
                continue;
            }
            //投产日期
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"投产日期"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 280, ScreenWidth, 40);
                touchanriqiCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"投产日期" oriValue:oriValueDic type:controllerType];
                [scroView addSubview:touchanriqiCell];
                continue;
            }
            //生产日期
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"生产日期"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 320, ScreenWidth, 40);
                shengchanriqiCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"生产日期" oriValue:oriValueDic type:controllerType];
                [scroView addSubview:shengchanriqiCell];
                continue;
            }
            //生产厂家
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"生产产家"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 360, ScreenWidth, 40);

                shengchanchangjiaCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"生产厂家" oriValue:oriValueDic type:controllerType];
                EditPropertyPopWindowBlock block = ^(NSMutableDictionary *dic) {
                    PowerDataService *dataService = [[PowerDataService alloc]init];
                    RequestCompleteBlock block = ^(id result) {
                        NSMutableArray *enumDatasource = [[NSMutableArray alloc]init];
                        for (NSMutableDictionary *item in (NSArray *)result) {
                            NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
                            [newDic setValue:[item objectForKey:@"DEV_MAKER_NAME"] forKey:@"name"];
                            [newDic setValue:[item objectForKey:@"DEV_MAKER_NAME"] forKey:@"value"];
                            [enumDatasource addObject:newDic];
                            
                            if([[item objectForKey:@"DEV_MAKER_NAME"] isEqualToString:[itemDic objectForKey:@"CURRENT_VALUE"] ]) {
                                [oriValueDic setValue:[item objectForKey:@"DEV_MAKER_NAME"]  forKey:@"name"];
                            }
                        }
                        [shengchanchangjiaCell popWindowWithDataSource:enumDatasource];

                    };
                    [dataService GetDeviceBFDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devNum:@"" devTypeNum:[[shebeileixingCell getCurrentDic] objectForKey:@"value"] devSubClassNum:@"" devClassNum:@"" devSubClassName:@"" devTypeName:@"" devMaker:@"" completeBlock:block loadingView:nil showHUD:NO];
                    
                };
                shengchanchangjiaCell.selfBlock = block;
//                shengchanchangjiaCell.enumDataSource = enumDatasource;
                [scroView addSubview:shengchanchangjiaCell];
                continue;
            }
            //设备容量
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备容量"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 400, ScreenWidth, 40);
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:@"非标" forKey:@"name"];
                [dic setValue:@"非标" forKey:@"value"];
                NSMutableArray *enumDataSource = [[NSMutableArray alloc]initWithObjects:dic, nil];
                shebeirongliangCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"设备容量" oriValue:oriValueDic type:controllerType];
                shebeirongliangCell.enumDataSource = enumDataSource;
                EditPropertySetCurrentValueBlock block = ^(NSDictionary *dic) {
                    if([[dic objectForKey:@"value"] isEqualToString:@"非标"]) {
                        NSMutableDictionary *mDic = [[NSMutableDictionary alloc]init];
                        [mDic setValue:@"--" forKey:@"name"];
                        [mDic setValue:@"--" forKey:@"value"];
                        [rongliangdanweiCell setCurrentDic:mDic];
                    }
                };
                shebeirongliangCell.setValueBlock = block;
                [scroView addSubview:shebeirongliangCell];
                continue;
            }
            //容量单位
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"容量单位"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 440, ScreenWidth, 40);
                NSMutableArray *enumDataSource = [self createEnumList:[itemDic objectForKey:@"ENUM_VALUE"]];
                rongliangdanweiCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"容量单位" oriValue:oriValueDic type:controllerType];
                rongliangdanweiCell.enumDataSource = enumDataSource;
                [scroView addSubview:rongliangdanweiCell];
                continue;
            }
            //设备性质
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备性质"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = EDITCELL_WITCH_CON;
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 480, ScreenWidth, 40);
                shebeixingzhiCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"设备性质" oriValue:oriValueDic type:controllerType];
                [shebeixingzhiCell setSwitchOnImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_switcher_on_nature.png"] scaleToSize:CGSizeMake(100, 33)] offImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_switcher_off_nature.png"] scaleToSize:CGSizeMake(100, 33)]];
                [scroView addSubview:shebeixingzhiCell];
                continue;
            }
            //受控状态
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"受控状态"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = EDITCELL_WITCH_CON;
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 520, ScreenWidth, 40);
                shoukongzhuangtaiCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"受控状态" oriValue:oriValueDic type:controllerType];
                [shoukongzhuangtaiCell setSwitchOnImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_switcher_on_control.png"] scaleToSize:CGSizeMake(100, 33)] offImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_switcher_off_control.png"] scaleToSize:CGSizeMake(100, 33)]];
                [scroView addSubview:shoukongzhuangtaiCell];
                continue;
            }
            //设备型号
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"设备型号"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 560, ScreenWidth, 40);
                shebeixinghaoCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"设备型号" oriValue:oriValueDic type:controllerType];
                [scroView addSubview:shebeixinghaoCell];
                continue;
            }
            //系统标识
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"系统标识"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 600, ScreenWidth, 40);
                xitongbiaoshiCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"系统标识" oriValue:oriValueDic type:controllerType];
                [scroView addSubview:xitongbiaoshiCell];
                continue;
            }
            //备注
            if([[itemDic objectForKey:@"CN_NAME"] isEqualToString:@"备注"]) {
                BOOL isRequired;
                if([[itemDic objectForKey:@"IS_NULL"] isEqualToString:@"0"]) {
                    isRequired = YES;
                }else {
                    isRequired = NO;
                }
                int controllerType = [[itemDic objectForKey:@"CONTROL_TYPE"] intValue];
                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                [oriValueDic setValue:[itemDic objectForKey:@"CURRENT_VALUECURRENT_VALUE"] forKey:@"value"];
                CGRect frame = CGRectMake(0, 640, ScreenWidth, 40);
                beizhuCell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:@"备注" oriValue:oriValueDic type:controllerType];
                [scroView addSubview:beizhuCell];
                continue;
            }
        }
        
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getDeviceCommonInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]  devNum:[_deviceDic objectForKey:@"DEV_NUM"] completeBlock:block loadingView:nil showHUD:YES];
}

-(NSMutableArray *)createEnumList:(NSString *)enumStr {
    if([enumStr isEqualToString:@""]){
        return nil;
    }
    NSMutableArray *enumDataSource = [[NSMutableArray alloc]init];
    NSArray *array1 = [enumStr componentsSeparatedByString:@";"];
    for (NSString *itemStr in array1) {
        NSArray *array2 = [itemStr componentsSeparatedByString:@":"];
        NSMutableDictionary *itemDic = [[NSMutableDictionary alloc]init];
        [itemDic setValue:array2[0] forKey:@"value"];
        [itemDic setValue:array2[1] forKey:@"name"];
        [enumDataSource addObject:itemDic];
    }
    return enumDataSource;
}

//生成json字典
-(NSMutableDictionary *)createJsonDictonry {
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
    [jsonDic setValue:[_deviceDic objectForKey:@"DEV_NUM"] forKey:@"PrimaryKeyData"];
    
    
    NSMutableDictionary *commonDic  = [[NSMutableDictionary alloc]init];
    [commonDic setValue:stationNum forKey:@"STA_NUM"];
    [commonDic setValue:stationName forKey:@"STA_NAME"];
    [commonDic setValue:[[suoshufangjianCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_ROOM_NUM"];
    [commonDic setValue:[[suoshuxitongCell getCurrentDic] objectForKey:@"value"] forKey:@"SYS_NUM"];
    [commonDic setValue:[[shebeileixingCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_TYPE_NUM"];
    [commonDic setValue:[[shebeizhuangtaiCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_STATUS_NUM"];
    [commonDic setValue:[[shebeimingchengCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_NAME"];
    [commonDic setValue:[[zichanbianhaoCell getCurrentDic] objectForKey:@"value"] forKey:@"ASSETS_NUM"];
    [commonDic setValue:[[shiwubianhaoCell getCurrentDic] objectForKey:@"value"] forKey:@"ARTICLE_NUM"];
    [commonDic setValue:[[touchanriqiCell getCurrentDic] objectForKey:@"value"] forKey:@"START_USE_DATE"];
    [commonDic setValue:[[shebeixingzhiCell getCurrentDic] objectForKey:@"value"] forKey:@"IS_PHYSICAL_DEVICE"];
    [commonDic setValue:[[shoukongzhuangtaiCell getCurrentDic] objectForKey:@"value"] forKey:@"IS_MONITORED_DEVICE"];
    [commonDic setValue:[[shebeirongliangCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_CAPACITY"];
    [commonDic setValue:[[rongliangdanweiCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_CAPACITY_UNIT"];
    [commonDic setValue:[[shengchanchangjiaCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_MAKER"];
    [commonDic setValue:[[shengchanriqiCell getCurrentDic] objectForKey:@"value"] forKey:@"MADE_DATE"];
    [commonDic setValue:[[shebeixinghaoCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_MODEL"];
    [commonDic setValue:[[xitongbiaoshiCell getCurrentDic] objectForKey:@"value"] forKey:@"SYS_NAME"];
    [commonDic setValue:[[beizhuCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_REMARK"];
    
    [jsonDic setValue:commonDic forKey:@"DeviceCommonData"];
    
    return jsonDic;
}

#pragma mark --- 设备类型delegate
-(void)submitDeviceleixing:(NSDictionary *)dic {
    [shebeileixingCell setCurrentDic:dic];
    BaseNavigationController *rootController = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController popViewControllerAnimated:YES];
    
    //设备类型修改以后需要重新加载扩展属性，因此将新选择的设备类型作为参数发送通知给扩展属性
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deviceTypeDidChange" object:[dic objectForKey:@"value"]];
    
    
//    //设备类型修改以后还需要修改本地保存的设备属性，因为设备类型更新会影像扩展属性的值
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray *localDeviceList = [userDefaults objectForKey:stationNum];
//    NSMutableArray *newLocalDeviceList = [[NSMutableArray alloc]init];
//    //找到当前的设备
//    for (NSDictionary *localDic in localDeviceList) {
//        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:localDic];
//        if([[newDic objectForKey:@"DEV_NUM"] isEqualToString:[_deviceDic objectForKey:@"DEV_NUM"]]) {
//            //设置为已查
//            [newDic setValue:[dic objectForKey:@"value"] forKey:@"DEV_TYPE_NUM"];
//        }
//        [newLocalDeviceList addObject:newDic];
//    }
//    [userDefaults setObject:newLocalDeviceList forKey:stationNum];
//    [userDefaults synchronize];
    
}
@end
