//

//  IPowerQueryViewController.m

//  i动力

//

//  Created by 丁浪平 on 16/3/20.

//  Copyright © 2016年 Min.wang. All rights reserved.

//



#import "IPowerQueryViewController.h"
#import "IPowerExcelViewController.h"
#import "EditPropertyCell.h"

@interface IPowerQueryViewController (){
    
    
    
    UIScrollView *scroView;
    
    UIView *operationView;
    
    UIGlossyButton *submitBtn;
    
    UILabel *xudianchiTitleLabel;
    NSArray *shebeizichanList;
    
    NSArray *shebeishiwuList;
    
    //站点名称
    NSString *stationName;
    NSString *stationNum;

    
    BOOL isHaveShowUI;
    
    EditPropertyCell* qujuCell1;
    EditPropertyCell* qujuCell2;
    EditPropertyCell* qujuCell3;
    EditPropertyCell* qujuCell4;
    EditPropertyCell* qujuCell5;
    
    EditPropertyCell* qujuCell6;
    EditPropertyCell* qujuCell7;
    EditPropertyCell* qujuCell8;
    EditPropertyCell* qujuCell9;
    EditPropertyCell* qujuCell10;
    
    NSMutableArray *TotalCell;


}

@property(nonatomic,assign)    BOOL isHaveShowUI;

@property(nonatomic,strong)NSMutableArray *TotalCell;


@end



@implementation IPowerQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataSource = [[NSArray alloc]init];
        [self setTitleWithPosition:@"center" title:@"查询条件"];
        self.isHaveShowUI = NO;
        
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40)];
    scroView.bounces = NO;
    [self.view addSubview:scroView];
    //添加操作按钮
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0,scroView.bottom,ScreenWidth,40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    submitBtn = [[UIGlossyButton alloc]init];
    submitBtn.frame = CGRectMake(5, 5, ScreenWidth-10, 30);
        [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitBtn addTarget:self action:@selector(submitHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:submitBtn];
    [self.view addSubview:operationView];
    
    //添加tap事件
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(hideKeyboard) ];
    [scroView addGestureRecognizer:tapGes];
    
    
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    if (!self.isHaveShowUI) {
        [self getGonggongshuxingUI];

    }
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

-(void)getGonggongshuxingUI{

    
    self.TotalCell = [NSMutableArray arrayWithCapacity:3];
    NSLog(@"%@",self.dataSource);
    
    
    
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                int controllerType = [[obj objectForKey:@"CONTROL_TYPE"] intValue];

                __block NSMutableArray *arrayT = [NSMutableArray array];

                NSString *string_enum = obj[@"ENUM_VALUE"];
                
                
                if (string_enum&&![string_enum isKindOfClass:[NSNull class]])
                {
                    NSArray *listtemp = [string_enum componentsSeparatedByString:@";"];
                    
                    
                    

                    [listtemp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSArray *litetemp2 = [obj componentsSeparatedByString:@":"];
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                        [dic setValue:litetemp2[0] forKey:@"name"];
                        [dic setValue:litetemp2[1] forKey:@"value"];
                        [arrayT addObject:dic];

                    }];
                }

                NSMutableDictionary *oriValueDic = [[NSMutableDictionary alloc]init];
                
                
                
//                [oriValueDic setValue:[self isBlankString:[obj objectForKey:@"CURRENT_VALUE"]]?@"请输入":[obj objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];   [oriValueDic setValue:[self isBlankString:[obj objectForKey:@"CURRENT_VALUE"]]?@"请输入":[obj objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
//                [oriValueDic setValue:[self isBlankString:[obj objectForKey:@"CURRENT_VALUE"]]?@"":[obj objectForKey:@"CURRENT_VALUE"]  forKey:@"value"];
//
                
              __block  NSString *jjjj = obj[@"CURRENT_VALUE"];
                if ([self isBlankString:jjjj]) {
                    jjjj = @"请输入";
                    [oriValueDic setValue:jjjj forKey:@"name"];
                    [oriValueDic setValue:@""  forKey:@"value"];
                }
                
                
                if ([self isBlankString:obj[@"CURRENT_VALUE"]]&&controllerType==4) {
                    jjjj = @"请选择";
                    if ([obj[@"EN_NAME"] isEqualToString:@"STOP_TIME"]) {
                        jjjj = [self getCurrentDate];
                    }
                    if ([obj[@"EN_NAME"] isEqualToString:@"START_TIME"]) {
                        jjjj = [self getlastmonthDate];
                    }
                    
                    [oriValueDic setValue:jjjj forKey:@"name"];
                    [oriValueDic setValue:jjjj  forKey:@"value"];
                }
                
                if ([jjjj isEqualToString:@"''"]) {
                    jjjj= @"全部";
                    [oriValueDic setValue:jjjj forKey:@"name"];
                    [oriValueDic setValue:@"''"  forKey:@"value"];

                }else{
                
                    
                    [arrayT enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj[@"value"] isEqual:jjjj]) {
                            jjjj =  obj[@"name"];
                                     [oriValueDic setValue:obj[@"name"] forKey:@"name"];
                                     [oriValueDic setValue:obj[@"value"]  forKey:@"value"];
                        }
                    }];

                
                }
                
//                [oriValueDic setValue:jjjj forKey:@"name"];
//                [oriValueDic setValue:jjjj  forKey:@"value"];

                
                EditPropertyCell* qujuCell;
                if (controllerType==5) {
                 
                     qujuCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, idx*40, ScreenWidth, 40) required:NO labelTitle:[obj objectForKey:@"CN_NAME"] oriValue:oriValueDic type:controllerType];
                    [qujuCell setTitleLabelWidth:120.0];
                    qujuCell.enumDataSource = arrayT;

                    [scroView addSubview:qujuCell];
                    
                }
                
                if (controllerType==4) {
                     qujuCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, idx*40, ScreenWidth, 40) required:NO labelTitle:obj[@"CN_NAME"] oriValue:oriValueDic type:EDIT_PROPERTY_CELL_DATE];
                    qujuCell.dateFormatString =  @"yyyy-MM-dd-HH:mm:ss";
                    [qujuCell setTitleLabelWidth:120.0];
                    [scroView addSubview:qujuCell];
                    
                    
                }  if (controllerType==3) {
                    [oriValueDic setValue:[self isBlankString:[obj objectForKey:@"CURRENT_VALUE"]]?@"":[obj objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];
                    [oriValueDic setValue:@1  forKey:@"value"];

                    qujuCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, idx*40, ScreenWidth, 40) required:NO labelTitle:[obj objectForKey:@"CN_NAME"] oriValue:oriValueDic type:EDIT_PROPERTY_CELL_INPUT_NUM];
                    [qujuCell setTitleLabelWidth:120.0];
                    [scroView addSubview:qujuCell];
                    
                }
                if (controllerType==2) {
                    [oriValueDic setValue:[self isBlankString:[obj objectForKey:@"CURRENT_VALUE"]]?@"":[obj objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];

                    qujuCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, idx*40, ScreenWidth, 40) required:NO labelTitle:[obj objectForKey:@"CN_NAME"] oriValue:oriValueDic type:EDIT_PROPERTY_CELL_INPUT];
                    [qujuCell setTitleLabelWidth:120.0];
                    [scroView addSubview:qujuCell];
                    
                }if (controllerType==1) {
                    [oriValueDic setValue:[self isBlankString:[obj objectForKey:@"CURRENT_VALUE"]]?@"":[obj objectForKey:@"CURRENT_VALUE"]  forKey:@"name"];

                    qujuCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, idx*40, ScreenWidth, 40) required:NO labelTitle:[obj objectForKey:@"CN_NAME"] oriValue:oriValueDic type:EDIT_PROPERTY_CELL_LABEL];
                    [qujuCell setTitleLabelWidth:120.0];
                    [scroView addSubview:qujuCell];
                    
                }else
                {
                    qujuCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, idx*40, ScreenWidth, 40) required:NO labelTitle:[obj objectForKey:@"CN_NAME"] oriValue:oriValueDic type:controllerType];
                    [qujuCell setTitleLabelWidth:120.0];
                    qujuCell.enumDataSource = arrayT;
                    
                    [scroView addSubview:qujuCell];
                }
                
                
                if (idx==0) {
                    qujuCell1 = qujuCell;
                    [self.TotalCell addObject:qujuCell1];
                }if (idx==1) {
                    qujuCell2 = qujuCell;
                    [self.TotalCell addObject:qujuCell2];

                }if (idx==2) {
                    qujuCell3 = qujuCell;
                    [self.TotalCell addObject:qujuCell3];

                }if (idx==3) {
                    qujuCell4 = qujuCell;
                    [self.TotalCell addObject:qujuCell4];

                }if (idx==4) {
                    qujuCell5 = qujuCell;
                    [self.TotalCell addObject:qujuCell5];

                }
                if (idx==5) {
                    qujuCell6 = qujuCell;
                    [self.TotalCell addObject:qujuCell6];

                }if (idx==6) {
                    qujuCell7 = qujuCell;
                    [self.TotalCell addObject:qujuCell7];

                }if (idx==7) {
                    qujuCell8 = qujuCell;
                    [self.TotalCell addObject:qujuCell8];

                }if (idx==8) {
                    qujuCell9 = qujuCell;
                    [self.TotalCell addObject:qujuCell9];

                }if (idx==9) {
                    qujuCell10 = qujuCell;
                    [self.TotalCell addObject:qujuCell10];

                }
                
                

                
            }];
            
            
           
//    }
    self.isHaveShowUI = YES;

    

}
//获取当前时间
-(NSString*)getCurrentDate
{
  
    NSDateFormatter * formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    return [formater stringFromDate:[NSDate date]];
}
//毫秒时间戳转化时间
-(NSString*)getlastmonthDate{
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //设置时间间隔（秒）（这个我是计算出来的，不知道有没有简便的方法 )
    NSTimeInterval time = 365 * 24 * 60 * 60;//一年的秒数
    //得到一年之前的当前时间（-：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
    time  =  time -60*60*24*30;
    NSDate * lastYear = [date dateByAddingTimeInterval:-60*60*24*30];
    
    //转化为字符串
    NSString * startDate = [dateFormatter stringFromDate:lastYear];
    
    return startDate;
}

-(void)submitHandler:(id)sender{
    
    
    [self hideKeyboard];
    
    __block NSMutableDictionary *parm = [NSMutableDictionary dictionary];

    [self.TotalCell enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        EditPropertyCell *cell = (EditPropertyCell*)obj;
        
        
     
        
        NSDictionary *info = [cell getCurrentDic];
        
        
        NSString *keystring = self.dataSource[idx][@"EN_NAME"];
        NSString *valuestring = info[@"value"];
        
        NSLog(@"%@",valuestring);
        if ([keystring isEqualToString:@"START_TIME"]||[keystring isEqualToString:@"STOP_TIME"]) {
        
            
            valuestring = [valuestring substringWithRange:NSMakeRange(0, 10)];
        }
        
       
        [parm setObject:valuestring forKey:keystring];
        
   
       }
     ];
    
    
    
    
    
        RequestCompleteBlock block1 = ^(id result) {
            [MBProgressHUD hideHUDForView:self.view.window animated:NO];

            NSDictionary *dicInfo = (NSDictionary*)result;
            NSLog(@"--%@",dicInfo);
            IPowerExcelViewController *vc =[[IPowerExcelViewController alloc]initWithNibName:nil bundle:nil];
            vc.stringName = self.stringName;
            vc.dicInfo = dicInfo;
            [self.navigationController pushViewController:vc animated:NO];
            
            
        };
    
    
    
        PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
        [dataService getData:AccessToken Type:self.stringNameMETHOD_NAME EnNamedic:parm operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block1 loadingView:self.view.window showHUD:YES];
        [MBProgressHUD showHUDAddedTo:self.view.window animated:NO];
    

    
    
    
    
    
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
//    [jsonDic setValue:[_deviceDic objectForKey:@"DEV_NUM"] forKey:@"PrimaryKeyData"];
    
    
//    NSMutableDictionary *commonDic  = [[NSMutableDictionary alloc]init];
//    [commonDic setValue:stationNum forKey:@"STA_NUM"];
//    [commonDic setValue:stationName forKey:@"STA_NAME"];
//    [commonDic setValue:[[suoshufangjianCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_ROOM_NUM"];
//    [commonDic setValue:[[suoshuxitongCell getCurrentDic] objectForKey:@"value"] forKey:@"SYS_NUM"];
//    [commonDic setValue:[[shebeileixingCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_TYPE_NUM"];
//    [commonDic setValue:[[shebeizhuangtaiCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_STATUS_NUM"];
//    [commonDic setValue:[[shebeimingchengCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_NAME"];
//    [commonDic setValue:[[zichanbianhaoCell getCurrentDic] objectForKey:@"value"] forKey:@"ASSETS_NUM"];
//    [commonDic setValue:[[shiwubianhaoCell getCurrentDic] objectForKey:@"value"] forKey:@"ARTICLE_NUM"];
//    [commonDic setValue:[[touchanriqiCell getCurrentDic] objectForKey:@"value"] forKey:@"START_USE_DATE"];
//    [commonDic setValue:[[shebeixingzhiCell getCurrentDic] objectForKey:@"value"] forKey:@"IS_PHYSICAL_DEVICE"];
//    [commonDic setValue:[[shoukongzhuangtaiCell getCurrentDic] objectForKey:@"value"] forKey:@"IS_MONITORED_DEVICE"];
//    [commonDic setValue:[[shebeirongliangCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_CAPACITY"];
//    [commonDic setValue:[[rongliangdanweiCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_CAPACITY_UNIT"];
//    [commonDic setValue:[[shengchanchangjiaCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_MAKER"];
//    [commonDic setValue:[[shengchanriqiCell getCurrentDic] objectForKey:@"value"] forKey:@"MADE_DATE"];
//    [commonDic setValue:[[shebeixinghaoCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_MODEL"];
//    [commonDic setValue:[[xitongbiaoshiCell getCurrentDic] objectForKey:@"value"] forKey:@"SYS_NAME"];
//    [commonDic setValue:[[beizhuCell getCurrentDic] objectForKey:@"value"] forKey:@"DEV_REMARK"];
//    
//    [jsonDic setValue:commonDic forKey:@"DeviceCommonData"];
    
    return jsonDic;
}

#pragma mark --- 设备类型delegate
-(void)submitDeviceleixing:(NSDictionary *)dic {
//    [shebeileixingCell setCurrentDic:dic];
//    BaseNavigationController *rootController = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [rootController popViewControllerAnimated:YES];
//    
//    //设备类型修改以后需要重新加载扩展属性，因此将新选择的设备类型作为参数发送通知给扩展属性
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"deviceTypeDidChange" object:[dic objectForKey:@"value"]];
//    
    
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


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}
-(BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


/*
 
 #pragma mark - Navigation
 
 
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 // Get the new view controller using [segue destinationViewController].
 
 // Pass the selected object to the new view controller.
 
 }
 
 */



@end

