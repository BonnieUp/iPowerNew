//
//  JinxingzhongContentView.m
//  i动力
//
//  Created by 王敏 on 16/1/11.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "JinxingzhongContentView.h"
#import "PowerDataService.h"
#import "EditPropertyCell.h"
#import "PowerDataService.h"

@implementation JinxingzhongContentView{
    NSString *recordNum;
    NSMutableDictionary *planDic;
    UILabel *titleLabel;
    UIScrollView *scrollView;
    UIGlossyButton *submitbtn;
    UIView *operationView;
    
    //editpropertycell
    EditPropertyCell *jianchashebeizongshucell;
    EditPropertyCell *cunzaiwentishebeishuliangcell;
    EditPropertyCell *donglixitongwentishucell;
    EditPropertyCell *shebeileixingwentishucell;
    EditPropertyCell *fangjianwentishucell;
    EditPropertyCell *zichanbianhaowentishucell;
    EditPropertyCell *shiwubianhaowentishucell;
    EditPropertyCell *touchanriqiwentishucell;
    EditPropertyCell *rongliangwentishucell;
    EditPropertyCell *xinghaowentishucell;
    EditPropertyCell *changjiawentishucell;
    EditPropertyCell *shengchanriqiwentishucell;
    EditPropertyCell *beizhucell;
    EditPropertyCell *shijipeitongrenyuancell;
    EditPropertyCell *jianchawanchengshijiancell;
    EditPropertyCell *xitongkuozhanshuxingchouchashucell;
    EditPropertyCell *xitongkuozhanshuxingcuowushucell;
    EditPropertyCell *shebeikuozhanshuxingchouchashucell;
    EditPropertyCell *shebeikuozhanshuxingcuowushucell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //监听键盘显示事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHandler:) name:UIKeyboardDidShowNotification object:nil];
        //监听键盘隐藏事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideHandler:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initViews];
    // Do any additional setup after loading the view.
}

-(void)_initViews{
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.layer.borderWidth = 0.5f;
    titleLabel.layer.borderColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1].CGColor;
    titleLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80)];
    scrollView.bounces = YES;
    [self.view addSubview:scrollView];
    
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0,scrollView.bottom,ScreenWidth,40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    submitbtn = [[UIGlossyButton alloc]init];
    submitbtn.frame = CGRectMake(5, 5, ScreenWidth-10, 30);
    [submitbtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitbtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitbtn addTarget:self action:@selector(submitHandler) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:submitbtn];
    [self.view addSubview:operationView];
    
    //添加tap事件
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(closeKeyboard) ];
    [scrollView addGestureRecognizer:tapGes];
    
}

-(void)setRecordNum:(NSString *)num{
    recordNum = num;
    RequestCompleteBlock block = ^(id result) {
        NSDictionary *oriDic = (NSDictionary *)result;
        planDic = [[NSMutableDictionary alloc]initWithDictionary:oriDic];
        [self redrawViews];
    };
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    [dataService getPrCheckStationDetailWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] recordNum:num isEdit:@"1" completeBlock:block loadingView:self.view showHUD:YES];
}

-(void)setTitleStr:(NSString *)titleStr{
    titleLabel.text = titleStr;
}

-(void)redrawViews{
    NSArray *commonArray = (NSArray *)[planDic objectForKey:@"CommonInfoList"];
    NSArray *extendArray = (NSArray *)[planDic objectForKey:@"ExtenderInfoList"];
    
    NSDictionary *chouchashebeizongshuDic;
    NSDictionary *cunzaiwentishebeishuDic;
    NSDictionary *donglixitongwentishuDic;
    NSDictionary *shebeileixingwentishuDic;
    NSDictionary *fangjianwentishuDic;
    NSDictionary *zichanbianhaowentishuDic;
    NSDictionary *shiwubianhaowentishuDic;
    NSDictionary *touchanriqiwentishuDic;
    NSDictionary *rongliangwentishuDic;
    NSDictionary *xinghaowentishuDic;
    NSDictionary *changjiawentishuDic;
    NSDictionary *shengchanriqiwentishuDic;
    NSDictionary *beizhuDic;
    NSDictionary *shijipeitongrenyuanDic;
    NSDictionary *chouchawanchengshijianDic;
    NSDictionary *xitongkuozhanshuxingchouchashuDic;
    NSDictionary *xitongkuozhanshuxingcuowushuDic;
    NSDictionary *shebeikuozhanshuxingchouchashuDic;
    NSDictionary *shebeikuozhanshuxingcuowushuDic;
    
    //common property
    for(NSDictionary *commonDic in commonArray){
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"1"]){
            chouchashebeizongshuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"2"]){
            cunzaiwentishebeishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"3"]){
            donglixitongwentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"4"]){
            shebeileixingwentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"5"]){
            fangjianwentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"6"]){
            zichanbianhaowentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"7"]){
            shiwubianhaowentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"8"]){
            touchanriqiwentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"9"]){
            rongliangwentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"10"]){
            xinghaowentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"11"]){
            changjiawentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"12"]){
            shengchanriqiwentishuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"13"]){
            beizhuDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"14"]){
            shijipeitongrenyuanDic = commonDic;
        }
        if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"15"]){
            chouchawanchengshijianDic = commonDic;
        }
    }
    
    for(NSDictionary *extendDic in extendArray){
        if([[[extendDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"16"]){
            xitongkuozhanshuxingchouchashuDic = extendDic;
        }
        if([[[extendDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"17"]){
            xitongkuozhanshuxingcuowushuDic = extendDic;
        }
        if([[[extendDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"18"]){
            shebeikuozhanshuxingchouchashuDic = extendDic;
        }
        if([[[extendDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"19"]){
            shebeikuozhanshuxingcuowushuDic = extendDic;
        }
    }
    
    //layout property cell
    //检查设备总数
    float cellLabelWidth = 140;
    NSMutableDictionary *jianchashebeizongshuCellDic = [[NSMutableDictionary alloc]init];
    [jianchashebeizongshuCellDic setValue:[chouchashebeizongshuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [jianchashebeizongshuCellDic setValue:[chouchashebeizongshuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect1 = CGRectMake(0, 0, ScreenWidth, 40);
    jianchashebeizongshucell = [[EditPropertyCell alloc]initWithFrame:rect1 required:YES labelTitle:@"检查设备总数" oriValue:jianchashebeizongshuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [jianchashebeizongshucell setTitleLabelWidth:cellLabelWidth];
    [jianchashebeizongshucell setNumbericMin:[[chouchashebeizongshuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[chouchashebeizongshuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:jianchashebeizongshucell];
    //存在问题的设备数量
    NSMutableDictionary *cunzaiwentishebeizongshuCellDic = [[NSMutableDictionary alloc]init];
    [cunzaiwentishebeizongshuCellDic setValue:[cunzaiwentishebeishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [cunzaiwentishebeizongshuCellDic setValue:[cunzaiwentishebeishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect2 = CGRectMake(0, jianchashebeizongshucell.bottom, ScreenWidth, 40);
    cunzaiwentishebeishuliangcell = [[EditPropertyCell alloc]initWithFrame:rect2 required:YES labelTitle:@"存在问题的设备数量" oriValue:cunzaiwentishebeizongshuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [cunzaiwentishebeishuliangcell setTitleLabelWidth:cellLabelWidth];
    [cunzaiwentishebeishuliangcell setNumbericMin:[[cunzaiwentishebeishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[cunzaiwentishebeishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:cunzaiwentishebeishuliangcell];
    
    UILabel *gonggongLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, cunzaiwentishebeishuliangcell.bottom, ScreenWidth-30, 40)];
    gonggongLabel.text = @"公共属性";
    gonggongLabel.font = [UIFont boldSystemFontOfSize:14];
    [scrollView addSubview:gonggongLabel];
    
    //动力系统问题数
    NSMutableDictionary *donglixitongwentishuCellDic = [[NSMutableDictionary alloc]init];
    [donglixitongwentishuCellDic setValue:[donglixitongwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [donglixitongwentishuCellDic setValue:[donglixitongwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect3 = CGRectMake(0, gonggongLabel.bottom, ScreenWidth, 40);
    donglixitongwentishucell = [[EditPropertyCell alloc]initWithFrame:rect3 required:YES labelTitle:@"动力系统问题数" oriValue:donglixitongwentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [donglixitongwentishucell setTitleLabelWidth:cellLabelWidth];
    [donglixitongwentishucell setNumbericMin:[[donglixitongwentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[donglixitongwentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:donglixitongwentishucell];
    
    //设备类型问题数
    NSMutableDictionary *shebeileixingwentishuCellDic = [[NSMutableDictionary alloc]init];
    [shebeileixingwentishuCellDic setValue:[shebeileixingwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [shebeileixingwentishuCellDic setValue:[shebeileixingwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect4 = CGRectMake(0, donglixitongwentishucell.bottom, ScreenWidth, 40);
    shebeileixingwentishucell = [[EditPropertyCell alloc]initWithFrame:rect4 required:YES labelTitle:@"设备类型问题数" oriValue:shebeileixingwentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [shebeileixingwentishucell setTitleLabelWidth:cellLabelWidth];
    [shebeileixingwentishucell setNumbericMin:[[shebeileixingwentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[shebeileixingwentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:shebeileixingwentishucell];
    
    //房间问题数
    NSMutableDictionary *fangjianwentishuCellDic = [[NSMutableDictionary alloc]init];
    [fangjianwentishuCellDic setValue:[fangjianwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [fangjianwentishuCellDic setValue:[fangjianwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect5 = CGRectMake(0, shebeileixingwentishucell.bottom, ScreenWidth, 40);
    fangjianwentishucell = [[EditPropertyCell alloc]initWithFrame:rect5 required:YES labelTitle:@"房间问题数" oriValue:fangjianwentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [fangjianwentishucell setTitleLabelWidth:cellLabelWidth];
    [fangjianwentishucell setNumbericMin:[[fangjianwentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[fangjianwentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:fangjianwentishucell];
    
    //资产编号问题数
    NSMutableDictionary *zichanbianhaowentishuCellDic = [[NSMutableDictionary alloc]init];
    [zichanbianhaowentishuCellDic setValue:[zichanbianhaowentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [zichanbianhaowentishuCellDic setValue:[zichanbianhaowentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect6 = CGRectMake(0, fangjianwentishucell.bottom, ScreenWidth, 40);
    zichanbianhaowentishucell = [[EditPropertyCell alloc]initWithFrame:rect6 required:YES labelTitle:@"资产编号问题数" oriValue:zichanbianhaowentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [zichanbianhaowentishucell setTitleLabelWidth:cellLabelWidth];
    [zichanbianhaowentishucell setNumbericMin:[[zichanbianhaowentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[zichanbianhaowentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:zichanbianhaowentishucell];
    
    //实物编号问题数
    NSMutableDictionary *shiwubianhaowentishuCellDic = [[NSMutableDictionary alloc]init];
    [shiwubianhaowentishuCellDic setValue:[shiwubianhaowentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [shiwubianhaowentishuCellDic setValue:[shiwubianhaowentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect7 = CGRectMake(0, zichanbianhaowentishucell.bottom, ScreenWidth, 40);
    shiwubianhaowentishucell = [[EditPropertyCell alloc]initWithFrame:rect7 required:YES labelTitle:@"实物编号问题数" oriValue:shiwubianhaowentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [shiwubianhaowentishucell setTitleLabelWidth:cellLabelWidth];
    [shiwubianhaowentishucell setNumbericMin:[[shiwubianhaowentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[shiwubianhaowentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:shiwubianhaowentishucell];
    
    //投产日期问题数
    NSMutableDictionary *touchanriqiwentishuCellDic = [[NSMutableDictionary alloc]init];
    [touchanriqiwentishuCellDic setValue:[touchanriqiwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [touchanriqiwentishuCellDic setValue:[touchanriqiwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect8 = CGRectMake(0, shiwubianhaowentishucell.bottom, ScreenWidth, 40);
    touchanriqiwentishucell = [[EditPropertyCell alloc]initWithFrame:rect8 required:YES labelTitle:@"投产日期问题数" oriValue:touchanriqiwentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [touchanriqiwentishucell setTitleLabelWidth:cellLabelWidth];
    [touchanriqiwentishucell setNumbericMin:[[touchanriqiwentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[touchanriqiwentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:touchanriqiwentishucell];
    
    //容量问题数
    NSMutableDictionary *rongliangwentishuCellDic = [[NSMutableDictionary alloc]init];
    [rongliangwentishuCellDic setValue:[rongliangwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [rongliangwentishuCellDic setValue:[rongliangwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect9 = CGRectMake(0, touchanriqiwentishucell.bottom, ScreenWidth, 40);
    rongliangwentishucell = [[EditPropertyCell alloc]initWithFrame:rect9 required:YES labelTitle:@"容量问题数" oriValue:rongliangwentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [rongliangwentishucell setTitleLabelWidth:cellLabelWidth];
    [rongliangwentishucell setNumbericMin:[[rongliangwentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[rongliangwentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:rongliangwentishucell];
    
    //型号问题数
    NSMutableDictionary *xinghaowentishuCellDic = [[NSMutableDictionary alloc]init];
    [xinghaowentishuCellDic setValue:[xinghaowentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [xinghaowentishuCellDic setValue:[xinghaowentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect10 = CGRectMake(0, rongliangwentishucell.bottom, ScreenWidth, 40);
    xinghaowentishucell = [[EditPropertyCell alloc]initWithFrame:rect10 required:YES labelTitle:@"型号问题数" oriValue:xinghaowentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [xinghaowentishucell setTitleLabelWidth:cellLabelWidth];
    [xinghaowentishucell setNumbericMin:[[xinghaowentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[xinghaowentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:xinghaowentishucell];
    
    //厂家问题数
    NSMutableDictionary *changjiawentishuCellDic = [[NSMutableDictionary alloc]init];
    [changjiawentishuCellDic setValue:[changjiawentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [changjiawentishuCellDic setValue:[changjiawentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect11 = CGRectMake(0, xinghaowentishucell.bottom, ScreenWidth, 40);
    changjiawentishucell = [[EditPropertyCell alloc]initWithFrame:rect11 required:YES labelTitle:@"厂家问题数" oriValue:changjiawentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [changjiawentishucell setTitleLabelWidth:cellLabelWidth];
    [changjiawentishucell setNumbericMin:[[changjiawentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[changjiawentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:changjiawentishucell];
    
    //生产日期问题数
    NSMutableDictionary *shengchanriqiwentishuCellDic = [[NSMutableDictionary alloc]init];
    [shengchanriqiwentishuCellDic setValue:[shengchanriqiwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [shengchanriqiwentishuCellDic setValue:[shengchanriqiwentishuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect12 = CGRectMake(0, changjiawentishucell.bottom, ScreenWidth, 40);
    shengchanriqiwentishucell = [[EditPropertyCell alloc]initWithFrame:rect12 required:YES labelTitle:@"生产日期问题数" oriValue:shengchanriqiwentishuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [shengchanriqiwentishucell setTitleLabelWidth:cellLabelWidth];
    [shengchanriqiwentishucell setNumbericMin:[[shengchanriqiwentishuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[shengchanriqiwentishuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:shengchanriqiwentishucell];
    
    //备注
    NSMutableDictionary *beizhuCellDic = [[NSMutableDictionary alloc]init];
    [beizhuCellDic setValue:[beizhuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [beizhuCellDic setValue:[beizhuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect13 = CGRectMake(0, shengchanriqiwentishucell.bottom, ScreenWidth, 40);
    beizhucell = [[EditPropertyCell alloc]initWithFrame:rect13 required:NO labelTitle:@"备注" oriValue:beizhuCellDic type:EDIT_PROPERTY_CELL_INPUT];
    [beizhucell setTitleLabelWidth:cellLabelWidth];
    [scrollView addSubview:beizhucell];
    
    //实际陪同人员
    NSMutableDictionary *shijipeitongrenyuanCellDic = [[NSMutableDictionary alloc]init];
    [shijipeitongrenyuanCellDic setValue:[shijipeitongrenyuanDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [shijipeitongrenyuanCellDic setValue:[shijipeitongrenyuanDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect14 = CGRectMake(0, beizhucell.bottom, ScreenWidth, 40);
    shijipeitongrenyuancell = [[EditPropertyCell alloc]initWithFrame:rect14 required:YES labelTitle:@"实际陪同人员" oriValue:shijipeitongrenyuanCellDic type:EDIT_PROPERTY_CELL_INPUT_COMBOBOX];
    NSArray *shijipeitongList = [(NSString *)[shijipeitongrenyuanDic objectForKey:@"ENUM_VALUE"] componentsSeparatedByString:@";"];
    NSMutableArray *shijipeitongEnumArray = [[NSMutableArray alloc]init];
    for(NSString *peitongStr in shijipeitongList){
        NSArray *peitongArray = [peitongStr componentsSeparatedByString:@":"];
        NSMutableDictionary *peitongEnumDic = [[NSMutableDictionary alloc]init];
        [peitongEnumDic setValue:[peitongArray objectAtIndex:0] forKey:@"name"];
        [peitongEnumDic setValue:[peitongArray objectAtIndex:1] forKey:@"value"];
        [shijipeitongEnumArray addObject:peitongEnumDic];
    }
    shijipeitongrenyuancell.enumDataSource = shijipeitongEnumArray;
    [shijipeitongrenyuancell setTitleLabelWidth:cellLabelWidth];
    [scrollView addSubview:shijipeitongrenyuancell];
    
    //检查完成时间
    NSMutableDictionary *jianchawanchengshijianCellDic = [[NSMutableDictionary alloc]init];
    [jianchawanchengshijianCellDic setValue:[chouchawanchengshijianDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [jianchawanchengshijianCellDic setValue:[chouchawanchengshijianDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect15 = CGRectMake(0, shijipeitongrenyuancell.bottom, ScreenWidth, 40);
    jianchawanchengshijiancell = [[EditPropertyCell alloc]initWithFrame:rect15 required:NO labelTitle:@"核查完成时间" oriValue:jianchawanchengshijianCellDic type:EDIT_PROPERTY_CELL_LABEL];
    [jianchawanchengshijiancell setTitleLabelWidth:cellLabelWidth];
    [scrollView addSubview:jianchawanchengshijiancell];
    
    UILabel *kuozhanLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, jianchawanchengshijiancell.bottom, ScreenWidth-30, 40)];
    kuozhanLabel.text = @"扩展属性";
    kuozhanLabel.font = [UIFont boldSystemFontOfSize:14];
    [scrollView addSubview:kuozhanLabel];
    
    //系统扩展属性抽查数
    NSMutableDictionary *xitongkuozhanshuxingchouchashuCellDic = [[NSMutableDictionary alloc]init];
    [xitongkuozhanshuxingchouchashuCellDic setValue:[xitongkuozhanshuxingchouchashuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [xitongkuozhanshuxingchouchashuCellDic setValue:[xitongkuozhanshuxingchouchashuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect16 = CGRectMake(0, kuozhanLabel.bottom, ScreenWidth, 40);
    xitongkuozhanshuxingchouchashucell = [[EditPropertyCell alloc]initWithFrame:rect16 required:YES labelTitle:@"系统扩展属性抽查数" oriValue:xitongkuozhanshuxingchouchashuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [xitongkuozhanshuxingchouchashucell setTitleLabelWidth:cellLabelWidth];
    [xitongkuozhanshuxingchouchashucell setNumbericMin:[[xitongkuozhanshuxingchouchashuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[xitongkuozhanshuxingchouchashuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:xitongkuozhanshuxingchouchashucell];
    
    //系统扩展属性错误数
    NSMutableDictionary *xitongkuozhanshuxingcuowushuCellDic = [[NSMutableDictionary alloc]init];
    [xitongkuozhanshuxingcuowushuCellDic setValue:[xitongkuozhanshuxingcuowushuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [xitongkuozhanshuxingcuowushuCellDic setValue:[xitongkuozhanshuxingcuowushuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect17 = CGRectMake(0, xitongkuozhanshuxingchouchashucell.bottom, ScreenWidth, 40);
    xitongkuozhanshuxingcuowushucell = [[EditPropertyCell alloc]initWithFrame:rect17 required:YES labelTitle:@"系统扩展属性错误数" oriValue:xitongkuozhanshuxingcuowushuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [xitongkuozhanshuxingcuowushucell setTitleLabelWidth:cellLabelWidth];
    [xitongkuozhanshuxingcuowushucell setNumbericMin:[[xitongkuozhanshuxingcuowushuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[xitongkuozhanshuxingcuowushuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:xitongkuozhanshuxingcuowushucell];
    
    //设备扩展属性抽查数
    NSMutableDictionary *shebeikuozhanshuxingchouchashuCellDic = [[NSMutableDictionary alloc]init];
    [shebeikuozhanshuxingchouchashuCellDic setValue:[shebeikuozhanshuxingchouchashuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [shebeikuozhanshuxingchouchashuCellDic setValue:[shebeikuozhanshuxingchouchashuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect18 = CGRectMake(0, xitongkuozhanshuxingcuowushucell.bottom, ScreenWidth, 40);
    shebeikuozhanshuxingchouchashucell = [[EditPropertyCell alloc]initWithFrame:rect18 required:YES labelTitle:@"设备扩展属性抽查数" oriValue:shebeikuozhanshuxingchouchashuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [shebeikuozhanshuxingchouchashucell setTitleLabelWidth:cellLabelWidth];
    [shebeikuozhanshuxingchouchashucell setNumbericMin:[[shebeikuozhanshuxingchouchashuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[shebeikuozhanshuxingchouchashuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:shebeikuozhanshuxingchouchashucell];
    
    //设备扩展属性错误数
    NSMutableDictionary *shebeikuozhanshuxingcuowushuCellDic = [[NSMutableDictionary alloc]init];
    [shebeikuozhanshuxingcuowushuCellDic setValue:[shebeikuozhanshuxingcuowushuDic objectForKey:@"CURRENT_VALUE"] forKey:@"name"];
    [shebeikuozhanshuxingcuowushuCellDic setValue:[shebeikuozhanshuxingcuowushuDic objectForKey:@"CURRENT_VALUE"] forKey:@"value"];
    CGRect rect19 = CGRectMake(0, shebeikuozhanshuxingchouchashucell.bottom, ScreenWidth, 40);
    shebeikuozhanshuxingcuowushucell = [[EditPropertyCell alloc]initWithFrame:rect19 required:YES labelTitle:@"设备扩展属性错误数" oriValue:shebeikuozhanshuxingcuowushuCellDic type:EDIT_PROPERTY_CELL_NUMBERIC];
    [shebeikuozhanshuxingcuowushucell setTitleLabelWidth:cellLabelWidth];
    [shebeikuozhanshuxingcuowushucell setNumbericMin:[[shebeikuozhanshuxingcuowushuDic objectForKey:@"MIN_VALUE"] intValue] Max:[[shebeikuozhanshuxingcuowushuDic objectForKey:@"MAX_VALUE"] intValue]];
    [scrollView addSubview:shebeikuozhanshuxingcuowushucell];
    
    //设置contentsize
    [scrollView setContentSize:CGSizeMake(ScreenWidth, 19*40+80)];
}

-(void)submitHandler{
//    if([[qujuCell getCurrentDic] objectForKey:@"value"]==nil){
//        [dic setValue:@"" forKey:@"REG_NUM"];
//        [dic setValue:@"全网" forKey:@"REG_NAME"];
//    }else{
//        [dic setValue:[[qujuCell getCurrentDic] objectForKey:@"value"] forKey:@"REG_NUM"];
//        [dic setValue:[[qujuCell getCurrentDic] objectForKey:@"name"] forKey:@"REG_NAME"];
//    }
    
    //commonDic
    NSMutableDictionary *commonDic = [[NSMutableDictionary alloc]init];
    //检查设备总数
    [commonDic setValue:[[jianchashebeizongshucell getCurrentDic] objectForKey:@"value"] forKey:@"CHECK_COUNT"];
    //存在问题设备数量
    [commonDic setValue:[[cunzaiwentishebeishuliangcell getCurrentDic] objectForKey:@"value"] forKey:@"ERROR_COUNT"];
    //动力系统问题数
    [commonDic setValue:[[donglixitongwentishucell getCurrentDic] objectForKey:@"value"] forKey:@"SYS_ERROR_COUNT"];
    //设备类型问题数
    [commonDic setValue:[[shebeileixingwentishucell getCurrentDic] objectForKey:@"value"] forKey:@"DEVTYPE_ERROR_COUNT"];
    //房间问题数
    [commonDic setValue:[[fangjianwentishucell getCurrentDic] objectForKey:@"value"] forKey:@"ROOM_ERROR_COUNT"];
    //资产编号问题数
    [commonDic setValue:[[zichanbianhaowentishucell getCurrentDic] objectForKey:@"value"] forKey:@"ASSETS_ERROR_COUNT"];
    //实物编号问题数
    [commonDic setValue:[[shiwubianhaowentishucell getCurrentDic] objectForKey:@"value"] forKey:@"ARTICLE_ERROR_COUNT"];
    //投产日期问题数
    [commonDic setValue:[[touchanriqiwentishucell getCurrentDic] objectForKey:@"value"] forKey:@"USEDATE_ERROR_COUNT"];
    //容量问题数
    [commonDic setValue:[[rongliangwentishucell getCurrentDic] objectForKey:@"value"] forKey:@"CAPACITY_ERROR_COUNT"];
    //型号问题数
    [commonDic setValue:[[xinghaowentishucell getCurrentDic] objectForKey:@"value"] forKey:@"MODEL_ERROR_COUNT"];
    //厂家问题数
    [commonDic setValue:[[changjiawentishucell getCurrentDic] objectForKey:@"value"] forKey:@"MAKER_ERROR_COUNT"];
    //生产日期问题数
    [commonDic setValue:[[shengchanriqiwentishucell getCurrentDic] objectForKey:@"value"] forKey:@"MADEDATE_ERROR_COUNT"];
    //备注
    [commonDic setValue:[[beizhucell getCurrentDic] objectForKey:@"value"] forKey:@"REMARK"];
    //实际陪同人员
    [commonDic setValue:[[shijipeitongrenyuancell getCurrentDic] objectForKey:@"value"] forKey:@"REAL_CONTACT_PERSON"];
    
    //extendDic
    NSMutableDictionary *extendDic = [[NSMutableDictionary alloc]init];
    //系统扩展属性抽查数
    [extendDic setValue:[[xitongkuozhanshuxingchouchashucell getCurrentDic] objectForKey:@"value"] forKey:@"CHECK_SYS_COUNT"];
    //系统扩展属性错误数
    [extendDic setValue:[[xitongkuozhanshuxingcuowushucell getCurrentDic] objectForKey:@"value"] forKey:@"SYS_ERROR_COUNT"];
    //设备扩展属性抽查数
    [extendDic setValue:[[shebeikuozhanshuxingchouchashucell getCurrentDic] objectForKey:@"value"] forKey:@"CHECK_DEVICE_COUNT"];
    //设备扩展属性错误数
    [extendDic setValue:[[shebeikuozhanshuxingcuowushucell getCurrentDic] objectForKey:@"value"] forKey:@"DEVICE_ERROR_COUNT"];

    
    RequestCompleteBlock block = ^(id result) {
        if(_delegate && [_delegate respondsToSelector:@selector(popToJinxingzhongDetailViewController)]){
            [_delegate popToJinxingzhongDetailViewController];
        }
    };
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    [dataService savePrCheckResultWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] recordNum:recordNum commonInfoDic:commonDic extendDic:extendDic completeBlock:block loadingView:self.view showHUD:YES];
}

#pragma mark ----- inputview 
//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //当键盘显示时，重新设置scroller的contentsize;
    scrollView.frame = CGRectMake(0,40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-keyboardSize.height-80);
    scrollView.contentSize = CGSizeMake(ScreenWidth, 19*40+80);
    
    operationView.frame = CGRectMake(0, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-keyboardSize.height-40, ScreenWidth,40);
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    scrollView.frame = CGRectMake(0,40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80);
    scrollView.contentSize = CGSizeMake(ScreenWidth, 19*40+80);
    
    operationView.frame = CGRectMake(0,ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-40,ScreenWidth,40);
}

//关闭键盘
-(void)closeKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
@end
