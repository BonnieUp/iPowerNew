//
//  XudianchiFilterConditionViewController.m
//  i动力
//
//  Created by 王敏 on 16/1/1.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "XudianchiFilterConditionViewController.h"
#import "EditPropertyCell.h"

@implementation XudianchiFilterConditionViewController{
    UIScrollView *scroView;
    UIView *operationView;
    UIGlossyButton *submitBtn;
    UILabel *xudianchiTitleLabel;
    EditPropertyCell *qujuCell;
    EditPropertyCell *juzhanCell;
    EditPropertyCell *biaoshiCell;
    EditPropertyCell *zichanCell;
    EditPropertyCell *shiwuCell;
    EditPropertyCell *kaishiDateCell;
    EditPropertyCell *jiesuDateCell;
    
    NSArray *shebeizichanList;
    NSArray *shebeishiwuList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"蓄电池测试数据管理";
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

    
    //title
    xudianchiTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 40)];
    [xudianchiTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [xudianchiTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:xudianchiTitleLabel];
    
    // Do any additional setup after loading the view.
    scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80)];
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

//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //当键盘显示时，重新设置scroller的contentsize;
    scroView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-keyboardSize.height-40);
    scroView.contentSize = CGSizeMake(ScreenWidth, 400);
    operationView.frame = CGRectMake(0, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-keyboardSize.height-40, ScreenWidth,40);
    
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    scroView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40);
    scroView.contentSize = CGSizeMake(ScreenWidth, 400);
    
    operationView.frame = CGRectMake(0,ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-40,ScreenWidth,40);
}

-(void)hideKeyboard {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


-(void)setXudianchiTitle:(NSString *)title{
    [xudianchiTitleLabel setText:title];
}


-(void)setQujuList:(NSArray *)qujuList{
    _qujuList = qujuList;
    [self changeQujuPiece];
}

-(void)changeQujuPiece {
        NSMutableArray *siteArray =[[NSMutableArray alloc]init];
        for (NSDictionary *itemDic in _qujuList) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[itemDic objectForKey:@"REG_NAME"] forKey:@"name"];
            [dic setValue:[itemDic objectForKey:@"REG_NUM"] forKey:@"value"];
            [siteArray addObject:dic];
        }
    
    //读取plist文件里设备大类信息
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Resource-Info" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSMutableDictionary *oriRegDic = [[NSMutableDictionary alloc]init];
    [oriRegDic setValue:@"全网" forKey:@"name"];
    [oriRegDic setValue:@"" forKey:@"value"];
    
    qujuCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) required:NO labelTitle:@"区局名称" oriValue:oriRegDic type:EDIT_PROPERTY_CELL_COMBOBOX];
    [qujuCell setTitleLabelWidth:80.0];
    [scroView addSubview:qujuCell];
    qujuCell.enumDataSource = siteArray;

    juzhanCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, qujuCell.bottom, ScreenWidth, 40) required:NO labelTitle:@"局站名称" oriValue:nil type:EDIT_PROPERTY_CELL_INPUT];
    [juzhanCell setTitleLabelWidth:80.0];
    [scroView addSubview:juzhanCell];
    
    biaoshiCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, juzhanCell.bottom, ScreenWidth, 40) required:NO labelTitle:@"系统标识" oriValue:nil type:EDIT_PROPERTY_CELL_INPUT];
    [biaoshiCell setTitleLabelWidth:80.0];
    [scroView addSubview:biaoshiCell];
    
    zichanCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, biaoshiCell.bottom, ScreenWidth, 40) required:NO labelTitle:@"资产编号" oriValue:nil type:EDIT_PROPERTY_CELL_INPUT_COMBOBOX];
    [zichanCell setTitleLabelWidth:80.0];
    [scroView addSubview:zichanCell];
    
    shebeizichanList = [data objectForKey:@"shebeizichan"];
    zichanCell.enumDataSource = shebeizichanList;
    
    shiwuCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, zichanCell.bottom, ScreenWidth, 40) required:NO labelTitle:@"实物编号" oriValue:nil type:EDIT_PROPERTY_CELL_INPUT_COMBOBOX];
    [shiwuCell setTitleLabelWidth:80.0];
    [scroView addSubview:shiwuCell];
    shebeishiwuList = [data objectForKey:@"shebeishiwu"];
    shiwuCell.enumDataSource = shebeishiwuList;
    
    kaishiDateCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, shiwuCell.bottom, ScreenWidth, 40) required:NO labelTitle:@"开始时间" oriValue:nil type:EDIT_PROPERTY_CELL_DATE];
    kaishiDateCell.dateFormatString =  @"yyyy-MM-dd-HH:mm:ss";
    [kaishiDateCell setTitleLabelWidth:80.0];
    [scroView addSubview:kaishiDateCell];
    
    jiesuDateCell = [[EditPropertyCell alloc]initWithFrame:CGRectMake(0, kaishiDateCell.bottom, ScreenWidth, 40) required:NO labelTitle:@"结束时间" oriValue:nil type:EDIT_PROPERTY_CELL_DATE];
    jiesuDateCell.dateFormatString = @"yyyy-MM-dd-HH:mm:ss";
    [jiesuDateCell setTitleLabelWidth:80.0];
    [scroView addSubview:jiesuDateCell];
    
    
}

-(void)submitHandler:(id)sender{
    NSDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if([[qujuCell getCurrentDic] objectForKey:@"value"]==nil){
        [dic setValue:@"" forKey:@"REG_NUM"];
        [dic setValue:@"全网" forKey:@"REG_NAME"];
    }else{
        [dic setValue:[[qujuCell getCurrentDic] objectForKey:@"value"] forKey:@"REG_NUM"];
        [dic setValue:[[qujuCell getCurrentDic] objectForKey:@"name"] forKey:@"REG_NAME"];
    }
    
    if([[juzhanCell getCurrentDic] objectForKey:@"value"]==nil){
         [dic setValue:@"" forKey:@"STA_NAME"];
    }else{
         [dic setValue:[[juzhanCell getCurrentDic] objectForKey:@"value"] forKey:@"STA_NAME"];
    }
    
    if([[biaoshiCell getCurrentDic] objectForKey:@"value"]==nil){
        [dic setValue:@"" forKey:@"SYS_NAME"];
    }else{
        [dic setValue:[[biaoshiCell getCurrentDic] objectForKey:@"value"] forKey:@"SYS_NAME"];
    }
    
    if([[zichanCell getCurrentDic] objectForKey:@"value"]==nil){
        [dic setValue:@"" forKey:@"ASSETS_NAME"];
    }else{
        [dic setValue:[[zichanCell getCurrentDic] objectForKey:@"value"] forKey:@"ASSETS_NAME"];
    }
    
    if([[shiwuCell getCurrentDic] objectForKey:@"value"]==nil){
        [dic setValue:@"" forKey:@"ARTICLE_NAME"];
    }else{
        [dic setValue:[[shiwuCell getCurrentDic] objectForKey:@"value"] forKey:@"ARTICLE_NAME"];
    }
    
    if([[kaishiDateCell getCurrentDic] objectForKey:@"value"]==nil){
        [dic setValue:[PowerUtils getFirstDay:@"yyyy-MM-dd-HH:mm:ss"] forKey:@"START_TIME"];
    }else{
        [dic setValue:[[kaishiDateCell getCurrentDic] objectForKey:@"value"] forKey:@"START_TIME"];
    }
    
    if([[jiesuDateCell getCurrentDic] objectForKey:@"value"]==nil){
        [dic setValue:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] forKey:@"END_TIME"];
    }else{
        [dic setValue:[[jiesuDateCell getCurrentDic] objectForKey:@"value"] forKey:@"END_TIME"];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(submitFilterHandler:)]){
        [_delegate submitFilterHandler:dic];
    }
}

@end
