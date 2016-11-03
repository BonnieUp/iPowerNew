//
//  ProcessCommitDataViewController.m
//  i动力
//
//  Created by 王敏 on 14-10-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "ProcessCommitDataViewController.h"
#import "UIGlossyButton.h"
#import "CustomSwitch.h"

@interface ProcessCommitDataViewController ()

@end

@implementation ProcessCommitDataViewController{
    UIView *containerView;
    UIButton *closeBtn;
    UIGlossyButton *submitBtn;
    UIGlossyButton *cancelBtn;
    CustomSwitch *isNormalSwitch;
    UITextField *flowNOinput;
    NSString *flowNo;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:flowNOinput];
        
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
    
    //容器
    containerView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-300)/2, (ScreenHeight-210)/2, 300,210)];
    containerView.layer.cornerRadius = 5;
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    //名称
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, containerView.width-20, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"提交数据";
    [containerView addSubview:titleLabel];
    
    //横线
    UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(5, titleLabel.bottom+5, containerView.width-10, 1)];
    seperateView.backgroundColor = [UIColor colorWithRed:102.0/255 green:136.0/255 blue:197.0/255 alpha:1];
    [containerView addSubview:seperateView];
    
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, seperateView.bottom+5, 200, 20)];
    tLabel.font = [UIFont systemFontOfSize:15];
    tLabel.textAlignment = NSTextAlignmentLeft;
    tLabel.text = @"是否提交维护数据";
    [containerView addSubview:tLabel];
    
    //关闭按钮
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(265, 5, 30, 30);
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_normal.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_pressed.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateSelected];
    [closeBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeBtn];
    
    //是否正常
    isNormalSwitch = [[CustomSwitch alloc]initWithFrame:CGRectMake(105,tLabel.bottom+10,90, 30)];
    [isNormalSwitch setSwitchOnImage:[UIImage imageNamed:@"btn_switcher_on_error.png"] offImage:[UIImage imageNamed:@"btn_switcher_off_error.png"]];
    [isNormalSwitch setOn:YES];
    [isNormalSwitch addTarget:self action:@selector(customSwitchChangeOnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:isNormalSwitch];
    
    //故障流水号
    flowNOinput = [[UITextField alloc]initWithFrame:CGRectMake(20, isNormalSwitch.bottom+10, 260, 30)];
    flowNOinput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    flowNOinput.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    flowNOinput.borderStyle = UITextBorderStyleLine;
    flowNOinput.layer.masksToBounds=YES;
    flowNOinput.layer.borderColor=[[UIColor colorWithRed:102.0/255 green:136.0/255 blue:197.0/255 alpha:1] CGColor];
    flowNOinput.layer.borderWidth= 1.0f;
    flowNOinput.delegate = self;
    flowNOinput.placeholder = @"请输入故障流水号";
    [containerView addSubview:flowNOinput];
    
    //提交按钮和取消按钮
    submitBtn = [[UIGlossyButton alloc]initWithFrame:CGRectMake(20, 160, 120, 35)];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor colorWithRed:255.0/255 green:101.0/255	 blue:88.0/255 alpha:1]];
    [submitBtn addTarget:self action:@selector(submitHandler) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:submitBtn];
    
    cancelBtn = [[UIGlossyButton alloc]initWithFrame:CGRectMake(160, 160, 120, 35)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setNavigationButtonWithColor:[UIColor colorWithRed:55.0/255 green:173.0/255	 blue:68.0/255 alpha:1]];
    [cancelBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cancelBtn];
    
    //添加tap事件
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(closeKeyboard) ];
    [containerView addGestureRecognizer:tapGes];
}

-(void)customSwitchChangeOnHandler:(CustomSwitch *)sender{
    //不显示故障流水号
    if(sender.on == YES){
        flowNOinput.hidden = YES;
        flowNo = @"";
        containerView.frame = CGRectMake((ScreenWidth-300)/2, (ScreenHeight-170)/2, 300,170);
        submitBtn.frame = CGRectMake(20, 120, 120, 35);
        cancelBtn.frame = CGRectMake(160, 120, 120, 35);
    }
    //显示故障流水号
    else{
        flowNOinput.hidden = NO;
        flowNo = @"";
        containerView.frame = CGRectMake((ScreenWidth-300)/2, (ScreenHeight-200)/2, 300,200);
        flowNOinput.frame = CGRectMake(20, isNormalSwitch.bottom+10, 260, 30);
        submitBtn.frame = CGRectMake(20, 150, 120, 35);
        cancelBtn.frame = CGRectMake(160, 150, 120, 35);
    }
}

//关闭窗口
-(void)closeWindow{
    [self disappearWinow];
}

//点击提交按钮
-(void)submitHandler {
    if(_delegate && [_delegate respondsToSelector:@selector(submitData:)]){
        [_delegate submitData:flowNo];
        [self closeWindow];
    }
}

-(void)setHasFinish:(BOOL)hasFinish{
    //显示switch
    if(hasFinish==YES){
        isNormalSwitch.hidden = NO;
        flowNOinput.hidden = YES;
        flowNo = @"";
        containerView.frame = CGRectMake((ScreenWidth-300)/2, (ScreenHeight-170)/2, 300,170);
        submitBtn.frame = CGRectMake(20, 120, 120, 35);
        cancelBtn.frame = CGRectMake(160, 120, 120, 35);
    }
    //不显示switch
    else{
        isNormalSwitch.hidden = YES;
        flowNOinput.hidden = YES;
        flowNo = @"";
        containerView.frame = CGRectMake((ScreenWidth-300)/2, (ScreenHeight-130)/2, 300,130);
        submitBtn.frame = CGRectMake(20, 80, 120, 35);
        cancelBtn.frame = CGRectMake(160, 80, 120, 35);
    }
}

//关闭键盘
-(void)closeKeyboard {
    [flowNOinput resignFirstResponder];
}

#pragma mark uisearchbar delegate
-(void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    NSString *keyword;
    if(![textField isEqual:flowNOinput])
        return;
    if([textField.text length]==0) {
        keyword = @"";
    }else {
        keyword = textField.text;
    }
    flowNo = keyword;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self closeKeyboard];
    return YES;
}

//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    CGRect oriFrame = containerView.frame;
    oriFrame.origin.y-=50;
    containerView.frame = oriFrame;
}

-(void)keyboardHideHandler:(id)sender {
    CGRect oriFrame = containerView.frame;
    oriFrame.origin.y+=50;
    containerView.frame = oriFrame;
}


@end
