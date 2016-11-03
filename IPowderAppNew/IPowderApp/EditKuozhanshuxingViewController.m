//
//  EditKuozhanshuxingViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "EditKuozhanshuxingViewController.h"
#import "PowerDataService.h"
@interface EditKuozhanshuxingViewController ()

@end

@implementation EditKuozhanshuxingViewController {
    UIScrollView *scroView;
    NSMutableArray *propertyCellList;
    //存放扩展属性的列表
    NSArray *propertyList;
    UIView *operationView;
    UIGlossyButton *submitBtn;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"扩展属性";
        //监听键盘显示事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHandler:) name:UIKeyboardDidShowNotification object:nil];
        //监听键盘隐藏事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideHandler:) name:UIKeyboardWillHideNotification object:nil];
        
        //监听设备类型更改通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceTypeChangeHandler:) name:@"deviceTypeDidChange" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    propertyCellList = [[NSMutableArray alloc]init];
    scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80)];
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

-(void)setDeviceDic:(NSDictionary *)deviceDic{
    if(![_deviceDic isEqual:deviceDic]) {
        _deviceDic = deviceDic;
        NSString *devTypeNum = [_deviceDic objectForKey:@"DEV_TYPE_NUM"];
        [self getKuozhanshuxing:devTypeNum];
    }
}

//接受设备类型更改的通知
-(void)deviceTypeChangeHandler:(NSNotification *)notification{
    NSString *devType = (NSString *)notification.object;
    [self getKuozhanshuxing:devType];
}

//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //当键盘显示时，重新设置scroller的contentsize;
    scroView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-keyboardSize.height-80);
    scroView.contentSize = CGSizeMake(ScreenWidth, 40*propertyList.count);
    operationView.frame = CGRectMake(0, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-keyboardSize.height-80, ScreenWidth,40);
    
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    scroView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80);
    scroView.contentSize = CGSizeMake(ScreenWidth, 40*propertyList.count);
    
    operationView.frame = CGRectMake(0,ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-80,ScreenWidth,40);
}


-(void)hideKeyboard {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//获取设备扩展属性
-(void)getKuozhanshuxing:devTypeNum {
    if(devTypeNum==nil)
        devTypeNum = @"";
    RequestCompleteBlock block = ^(id result) {
        //首选移除所有子元素
        for (UIView *view in scroView.subviews) {
            [view removeFromSuperview];
        }
        //赋值
       propertyList = (NSArray *)result;
        //如果么有扩展属性
        if(propertyList.count == 0 ) {
            UILabel *noneProLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (scroView.height+10)/2,ScreenWidth, 30)];
            noneProLabel.text = @"无扩展属性";
            noneProLabel.textAlignment = NSTextAlignmentCenter;
            noneProLabel.backgroundColor = [UIColor clearColor];
            [scroView addSubview:noneProLabel];
        }else {
            [self createPropertyCell];
        }
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getDeviceExtendInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devNum:[_deviceDic objectForKey:@"DEV_NUM"]  devTypeNum:devTypeNum completeBlock:block loadingView:nil showHUD:YES];
}

//生成属性栏
-(void)createPropertyCell {
    for (int i=0;i<propertyList.count;i++) {
        NSDictionary *itemDic = (NSDictionary *)[propertyList objectAtIndex:i];
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
        CGRect frame = CGRectMake(0, 40*i, ScreenWidth, 40);
        EditPropertyCell *cell = [[EditPropertyCell alloc]initWithFrame:frame required:isRequired labelTitle:[itemDic objectForKey:@"EXT_ATTR_NAME"] oriValue:oriValueDic type:controllerType];
        [cell setTitleLabelWidth:120.0f];
        NSMutableArray *enumDataSource = [self createEnumList:[itemDic objectForKey:@"ENUM_VALUE"]];
        cell.enumDataSource = enumDataSource;
        cell.realationDic = itemDic;
        [propertyCellList addObject:cell];
        [scroView addSubview:cell];
    }
    scroView.contentSize = CGSizeMake(ScreenWidth, 40*propertyList.count);
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
        if(array2.count == 1 ) {
            [itemDic setValue:array2[0] forKey:@"value"];
            [itemDic setValue:array2[0] forKey:@"name"];
        }else {
            [itemDic setValue:array2[0] forKey:@"value"];
            [itemDic setValue:array2[1] forKey:@"name"];
        }

        [enumDataSource addObject:itemDic];
    }
    return enumDataSource;
}


//提交数据
-(void)submitHandler:(UIButton*)sender {
    [self hideKeyboard];
     //验证
    for (EditPropertyCell *cell in propertyCellList ) {
        if([cell validateReqiured] == NO ) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cell getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    
    BOOL isEdit = NO;
    for (EditPropertyCell *cell in propertyCellList ) {
        if(cell.isEdited == YES) {
            isEdit = YES;
            break;
        }
    }
    //如果修改过，将设备的modifyed设置为YES
    if(isEdit == YES ) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *localDeviceList = [userDefaults objectForKey:_stationNum];
        NSMutableArray *newDeviceList = [[NSMutableArray alloc]init];
        //找到当前的设备
        for (NSDictionary *dic in localDeviceList) {
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
            if([[newDic objectForKey:@"DEV_NUM"] isEqualToString:[_deviceDic objectForKey:@"DEV_NUM"]]) {
                [newDic setValue:@"YES" forKey:@"modifyed"];
            }
            [newDeviceList addObject:newDic];
        }
        [userDefaults setObject:newDeviceList forKey:_stationNum];
        [userDefaults synchronize];
    }
    
    //发送保存设备属性的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"saveExtendDeviceProperty" object:nil];
}

//生成json字典
-(NSMutableDictionary *)createJsonDictonry {
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
    [jsonDic setValue:[_deviceDic objectForKey:@"DEV_NUM"] forKey:@"PrimaryKeyData"];
    
    NSMutableArray *extendArray  = [[NSMutableArray alloc]init];
    for (EditPropertyCell *cell in propertyCellList) {
        NSDictionary *realationDic = cell.realationDic;
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
        [newDic setValue:[realationDic objectForKey:@"EXT_ATTR_NUM"] forKey:@"EXT_ATTR_NUM"];
        [newDic setValue:[realationDic objectForKey:@"EXT_ATTR_NAME"] forKey:@"EXT_ATTR_NAME"];
        [newDic setValue:[[cell getCurrentDic] objectForKey:@"value"] forKey:@"ATTR_VALUE"];
        [extendArray addObject:newDic];
    }
    
    [jsonDic setValue:extendArray forKey:@"DeviceExtenderData"];
    return jsonDic;
}

@end
