//
//  EditDuanziDetailViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "EditDuanziDetailViewController.h"

@interface EditDuanziDetailViewController ()

@end

@implementation EditDuanziDetailViewController {
    UIScrollView *scrolView;
    UILabel *deviceNameLabel;
    NSArray *inoutTypeArray;
    NSArray *duanzileixingArray;
    NSArray *duanzifenleiArray;
    NSArray *statusArray;
    NSArray *fujieArray;
    NSArray *xuniArray;
    UIView *operationView;
    UIGlossyButton *submitBtn;
    
    EditPropertyCell *cellRow;
    EditPropertyCell *cellColumn;
    EditPropertyCell *cellIO;
    EditPropertyCell *cellDuanziType;
    EditPropertyCell *cellFenlei;
    EditPropertyCell *cellStatus;
    EditPropertyCell *cellFujie;
    EditPropertyCell *cellXuni;
    EditPropertyCell *cellXinghao;
    EditPropertyCell *cellRongliang;
    EditPropertyCell *cellLiuliang;
    EditPropertyCell *cellBeizhu;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"端子信息"];
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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Resource-Info" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    duanzileixingArray = [data objectForKey:@"duanzileixing"];
    inoutTypeArray = [data objectForKey:@"IOleixing"];
    duanzifenleiArray = [data objectForKey:@"duanzifenlei"];
    statusArray = [data objectForKey:@"duanzizhuangtai"];
    fujieArray = [data objectForKey:@"shifoufujie"];
    xuniArray = [data objectForKey:@"shifouxuni"];

    //添加设备名称label
    deviceNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    deviceNameLabel.font = [UIFont systemFontOfSize:15];
    deviceNameLabel.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
    deviceNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:deviceNameLabel];
    
    
    scrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80)];
    scrolView.bounces = NO;
    [self.view addSubview:scrolView];
    
    //添加操作按钮
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0,scrolView.bottom,ScreenWidth,40)];
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


-(void)setDeviceDic:(NSDictionary *)deviceDic {
    _deviceDic = deviceDic;
    deviceNameLabel.text = [_deviceDic objectForKey:@"DEV_NAME"];
}

-(void)setDuanziDic:(NSDictionary *)duanziDic {
    if(![_duanziDic isEqual:duanziDic]) {
        _duanziDic = duanziDic;
        [self createDuanziInfo];
    }
}


//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //当键盘显示时，重新设置scroller的contentsize;
    scrolView.frame = CGRectMake(0,40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-keyboardSize.height-80);
    scrolView.contentSize = CGSizeMake(ScreenWidth, 481);
    operationView.frame = CGRectMake(0, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-keyboardSize.height-40, ScreenWidth,40);
    
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    scrolView.frame = CGRectMake(0,40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80);
    scrolView.contentSize = CGSizeMake(ScreenWidth, 481);
    
    operationView.frame = CGRectMake(0,ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-40,ScreenWidth,40);
}

-(void)hideKeyboard {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
//创建端子属性字段
-(void)createDuanziInfo {
    //行
    NSMutableDictionary *oriValueDicRow = [[NSMutableDictionary alloc]init];
    [oriValueDicRow setValue:[_duanziDic objectForKey:@"CONTR_ROW"] forKey:@"name"];
    [oriValueDicRow setValue:[_duanziDic objectForKey:@"CONTR_ROW"] forKey:@"value"];
    CGRect frameRow = CGRectMake(0, 0, ScreenWidth, 40);
    cellRow = [[EditPropertyCell alloc]initWithFrame:frameRow required:YES labelTitle:@"行" oriValue:oriValueDicRow type:EDITCELL_INPUT];
    [scrolView addSubview:cellRow];
    
    //列
    NSMutableDictionary *oriValueDicColumn = [[NSMutableDictionary alloc]init];
    [oriValueDicColumn setValue:[_duanziDic objectForKey:@"CONTR_COLUMN"] forKey:@"name"];
    [oriValueDicColumn setValue:[_duanziDic objectForKey:@"CONTR_COLUMN"] forKey:@"value"];
    CGRect frameColumn = CGRectMake(0, 40, ScreenWidth, 40);
    cellColumn = [[EditPropertyCell alloc]initWithFrame:frameColumn required:YES labelTitle:@"列" oriValue:oriValueDicColumn type:EDITCELL_INPUT];
    [scrolView addSubview:cellColumn];
    
    //i/o类型
    NSMutableDictionary *oriValueIO = [[NSMutableDictionary alloc]init];
    [oriValueIO setValue:[self getIONameWithValue:[_duanziDic objectForKey:@"INOUT_TYPE"]] forKey:@"name"];
    [oriValueIO setValue:[_duanziDic objectForKey:@"INOUT_TYPE"] forKey:@"value"];
    CGRect frameIO = CGRectMake(0, 80, ScreenWidth, 40);
    cellIO = [[EditPropertyCell alloc]initWithFrame:frameIO required:YES labelTitle:@"I/O类型" oriValue:oriValueIO type:EDITCELL_COMBOBOX];
    cellIO.enumDataSource = inoutTypeArray;
    [scrolView addSubview:cellIO];
    
    //端子类型
    NSMutableDictionary *oriValueDuanziType = [[NSMutableDictionary alloc]init];
    [oriValueDuanziType setValue:[self getDuanzileixingWithValue:[_duanziDic objectForKey:@"CONTR_TYPE"]] forKey:@"name"];
    [oriValueDuanziType setValue:[_duanziDic objectForKey:@"CONTR_TYPE"] forKey:@"value"];
    CGRect frameDuanziType = CGRectMake(0, 120, ScreenWidth, 40);
    cellDuanziType = [[EditPropertyCell alloc]initWithFrame:frameDuanziType required:YES labelTitle:@"端子类型" oriValue:oriValueDuanziType type:EDITCELL_COMBOBOX];
    cellDuanziType.enumDataSource = duanzileixingArray;
    [scrolView addSubview:cellDuanziType];
    
    //端子分类
    NSMutableDictionary *oriValueFenlei = [[NSMutableDictionary alloc]init];
    [oriValueFenlei setValue:[self getDuanzifenleiWithValue:[_duanziDic objectForKey:@"CONTR_SORT"]] forKey:@"name"];
    [oriValueFenlei setValue:[_duanziDic objectForKey:@"CONTR_SORT"] forKey:@"value"];
    CGRect frameFenlei = CGRectMake(0, 160, ScreenWidth, 40);
    cellFenlei = [[EditPropertyCell alloc]initWithFrame:frameFenlei required:YES labelTitle:@"端子分类" oriValue:oriValueFenlei type:EDITCELL_COMBOBOX];
    cellFenlei.enumDataSource = duanzifenleiArray;
    [scrolView addSubview:cellFenlei];
    
    //使用状态
    NSMutableDictionary *oriValueStatus = [[NSMutableDictionary alloc]init];
    [oriValueStatus setValue:[self getzhuangtaiWithValue:[_duanziDic objectForKey:@"CONTR_STATUS"]] forKey:@"name"];
    [oriValueStatus setValue:[_duanziDic objectForKey:@"CONTR_STATUS"] forKey:@"value"];
    CGRect frameStatus = CGRectMake(0, 200, ScreenWidth, 40);
    cellStatus = [[EditPropertyCell alloc]initWithFrame:frameStatus required:YES labelTitle:@"使用状态" oriValue:oriValueStatus type:EDITCELL_COMBOBOX];
    cellStatus.enumDataSource = statusArray;
    [scrolView addSubview:cellStatus];
    
    //是否复接
    NSMutableDictionary *oriValueFujie = [[NSMutableDictionary alloc]init];
    [oriValueFujie setValue:[_duanziDic objectForKey:@"IS_REUSE"] forKey:@"name"];
    [oriValueFujie setValue:[_duanziDic objectForKey:@"IS_REUSE"] forKey:@"value"];
    CGRect frameFujie = CGRectMake(0, 240, ScreenWidth, 40);
    cellFujie = [[EditPropertyCell alloc]initWithFrame:frameFujie required:YES labelTitle:@"是否复接" oriValue:oriValueFujie type:EDITCELL_WITCH_CON];
    [scrolView addSubview:cellFujie];
    
    //是否虚拟端子
    NSMutableDictionary *oriValueXuni = [[NSMutableDictionary alloc]init];
    [oriValueXuni setValue:[_duanziDic objectForKey:@"IS_DUMMY_CONTR"] forKey:@"name"];
    [oriValueXuni setValue:[_duanziDic objectForKey:@"IS_DUMMY_CONTR"] forKey:@"value"];
    CGRect frameXuni = CGRectMake(0, 280, ScreenWidth, 40);
    cellXuni = [[EditPropertyCell alloc]initWithFrame:frameXuni required:YES labelTitle:@"是否虚拟端子" oriValue:oriValueXuni type:EDITCELL_WITCH_CON];
    [scrolView addSubview:cellXuni];
    
    //端子型号
    NSMutableDictionary *oriValuexinghao = [[NSMutableDictionary alloc]init];
    [oriValuexinghao setValue:[_duanziDic objectForKey:@"CONTR_MODEL"] forKey:@"name"];
    [oriValuexinghao setValue:[_duanziDic objectForKey:@"CONTR_MODEL"] forKey:@"value"];
    CGRect frameXinghao = CGRectMake(0, 320, ScreenWidth, 40);
    cellXinghao = [[EditPropertyCell alloc]initWithFrame:frameXinghao required:NO labelTitle:@"端子型号" oriValue:oriValuexinghao type:EDITCELL_INPUT];
    [scrolView addSubview:cellXinghao];
    
    //额定容量
    NSMutableDictionary *oriValuerongliang = [[NSMutableDictionary alloc]init];
    [oriValuerongliang setValue:[_duanziDic objectForKey:@"CONTR_CAPACITY"] forKey:@"name"];
    [oriValuerongliang setValue:[_duanziDic objectForKey:@"CONTR_CAPACITY"] forKey:@"value"];
    CGRect frameRongliang = CGRectMake(0, 360, ScreenWidth, 40);
    cellRongliang = [[EditPropertyCell alloc]initWithFrame:frameRongliang required:NO labelTitle:@"额定容量" oriValue:oriValuerongliang type:EDITCELL_INPUT];
    [scrolView addSubview:cellRongliang];
    
    //载流量
    NSMutableDictionary *oriValueliuliang = [[NSMutableDictionary alloc]init];
    [oriValueliuliang setValue:[_duanziDic objectForKey:@"MAX_LOAD"] forKey:@"name"];
    [oriValueliuliang setValue:[_duanziDic objectForKey:@"MAX_LOAD"] forKey:@"value"];
    CGRect frameLiuliang = CGRectMake(0, 400, ScreenWidth, 40);
    cellLiuliang = [[EditPropertyCell alloc]initWithFrame:frameLiuliang required:NO labelTitle:@"载流量" oriValue:oriValueliuliang type:EDITCELL_INPUT];
    [scrolView addSubview:cellLiuliang];
    
    //备注
    NSMutableDictionary *oriValuebeizhu = [[NSMutableDictionary alloc]init];
    [oriValuebeizhu setValue:[_duanziDic objectForKey:@"CONTR_REMARK"] forKey:@"name"];
    [oriValuebeizhu setValue:[_duanziDic objectForKey:@"CONTR_REMARK"] forKey:@"value"];
    CGRect frameBeizhu = CGRectMake(0, 440, ScreenWidth, 40);
    cellBeizhu = [[EditPropertyCell alloc]initWithFrame:frameBeizhu required:NO labelTitle:@"备注" oriValue:oriValuebeizhu type:EDITCELL_INPUT];
    [scrolView addSubview:cellBeizhu];
    
    scrolView.contentSize = CGSizeMake(ScreenWidth, 481);
}

-(NSString *)getIONameWithValue:(NSString *)value {
    for (NSDictionary *dic in inoutTypeArray) {
        if([value isEqualToString:[dic objectForKey:@"value"]]) {
            return [dic objectForKey:@"name"];
        }
    }
    return value;
}

-(NSString *)getDuanzileixingWithValue:(NSString *)value {
    for (NSDictionary *dic in duanzileixingArray) {
        if([value isEqualToString:[dic objectForKey:@"value"]]) {
            return [dic objectForKey:@"name"];
        }
    }
    return value;
}

-(NSString *)getDuanzifenleiWithValue:(NSString *)value {
    for (NSDictionary *dic in duanzifenleiArray) {
        if([value isEqualToString:[dic objectForKey:@"value"]]) {
            return [dic objectForKey:@"name"];
        }
    }
    return value;
}

-(NSString *)getzhuangtaiWithValue:(NSString *)value {
    for (NSDictionary *dic in statusArray) {
        if([value isEqualToString:[dic objectForKey:@"value"]]) {
            return [dic objectForKey:@"name"];
        }
    }
    return value;
}

//提交数据
-(void)submitHandler:(UIButton*)sender {
    [self hideKeyboard];
    //验证
    UIAlertView *alertView;
    if([cellRow validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cellRow getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([cellColumn validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cellColumn getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([cellIO validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cellIO getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([cellDuanziType validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cellDuanziType getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([cellFenlei validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cellFenlei getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([cellStatus validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cellStatus getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([cellFujie validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cellFujie getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if([cellXuni validateReqiured]==NO) {
        alertView = [[UIAlertView alloc]initWithTitle:@"" message:[cellXuni getInvalidaString] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    BOOL isEdit = cellRow.isEdited ||
    cellColumn.isEdited  ||
    cellIO.isEdited  ||
    cellDuanziType.isEdited  ||
    cellFenlei.isEdited  ||
    cellStatus.isEdited  ||
    cellFujie.isEdited  ||
    cellXuni.isEdited  ||
    cellXinghao.isEdited  ||
    cellRongliang.isEdited  ||
    cellLiuliang.isEdited  ||
    cellBeizhu.isEdited;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"saveConnectorDeviceProperty" object:nil];
}

-(NSDictionary *)getEditedDuanziDic {
    NSDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[_duanziDic objectForKey:@"CONTR_NUM"] forKey:@"CONTR_NUM"];
    [dic setValue:[[cellRow getCurrentDic] objectForKey:@"value"] forKey:@"CONTR_ROW"];
    [dic setValue:[[cellColumn getCurrentDic] objectForKey:@"value"] forKey:@"CONTR_COLUMN"];
    [dic setValue:[[cellIO getCurrentDic] objectForKey:@"value"] forKey:@"INOUT_TYPE"];
    [dic setValue:[[cellDuanziType getCurrentDic] objectForKey:@"value"] forKey:@"CONTR_TYPE"];
    [dic setValue:[[cellFenlei getCurrentDic] objectForKey:@"value"] forKey:@"CONTR_SORT"];
    [dic setValue:[[cellStatus getCurrentDic] objectForKey:@"value"] forKey:@"CONTR_STATUS"];
    [dic setValue:[[cellXinghao getCurrentDic] objectForKey:@"value"] forKey:@"CONTR_MODEL"];
    [dic setValue:[[cellRongliang getCurrentDic] objectForKey:@"value"] forKey:@"CONTR_CAPACITY"];
    [dic setValue:[[cellLiuliang getCurrentDic] objectForKey:@"value"] forKey:@"MAX_LOAD"];
    [dic setValue:[[cellBeizhu getCurrentDic] objectForKey:@"value"] forKey:@"CONTR_REMARK"];
    [dic setValue:[[cellFujie getCurrentDic] objectForKey:@"value"] forKey:@"IS_REUSE"];
    [dic setValue:[[cellXuni getCurrentDic] objectForKey:@"value"] forKey:@"IS_DUMMY_CONTR"];
    [dic setValue:[_duanziDic objectForKey:@"CONTR_POSITION"] forKey:@"CONTR_POSITION"];
    
    return dic;
}
@end
