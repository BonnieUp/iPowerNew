//
//  FilterConditionListViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "FilterConditionListViewController.h"

@interface FilterConditionListViewController ()

@end

@implementation FilterConditionListViewController {
    UIView *operationView ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"设备筛选"];
        
        //监听键盘显示事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHandler:) name:UIKeyboardDidShowNotification object:nil];
        //监听键盘隐藏事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideHandler:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

//-(void)viewDidDisappear:(BOOL)animated {
//    //监听键盘显示事件
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    //监听键盘隐藏事件
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //过滤条件视图
    _conditionView = [FilterCondition instanceFilterCondition];
    _conditionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-STATUS_BAR_HEIGHT);
//    _conditionView.layer.borderColor = [UIColor redColor].CGColor;
//    _conditionView.layer.borderWidth = 1;
    [self.view addSubview:_conditionView];
//    //操作按钮视图
//    operationView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40, ScreenWidth, 40)];
//    operationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
//    //提交按钮
//    submitBtn = [[UIGlossyButton alloc]init];
//    submitBtn.frame = CGRectMake(5, 5,ScreenWidth-10,30);
//    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
//    [submitBtn addTarget:self action:@selector(submitHandler) forControlEvents:UIControlEventTouchUpInside];
//    submitBtn.enabled = NO;
//    [operationView addSubview:submitBtn];
//    [self.view addSubview:operationView];
    
    //添加tap事件
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(hideKeyboard) ];
    [self.view addGestureRecognizer:tapGes];
    
}

-(void)setStationNum:(NSString *)stationNum {
    _stationNum = stationNum;
    _conditionView.stationNum = stationNum;
}

//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    [_conditionView keyboardShowHandler:sender];
    
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    [_conditionView keyboardHideHandler:sender];
}

-(void)hideKeyboard {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)submitHandler {
    
}

@end
