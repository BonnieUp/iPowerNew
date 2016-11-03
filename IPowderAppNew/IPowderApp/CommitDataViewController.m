//
//  CommitDataViewController.m
//  i动力
//
//  Created by 王敏 on 14-10-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "CommitDataViewController.h"
#import "UIGlossyButton.h"
#import "CustomSwitch.h"

@interface CommitDataViewController ()

@end

@implementation CommitDataViewController{
    UIView *containerView;
    UIButton *closeBtn;
    UIGlossyButton *submitBtn;
    UIGlossyButton *cancelBtn;
    CustomSwitch *isAutoSwitch;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
    tLabel.text = @"是否开始维护";
    [containerView addSubview:tLabel];
    
    UILabel *cLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, tLabel.bottom+10, 260, 40)];
    cLabel.numberOfLines = 2;
    cLabel.font = [UIFont systemFontOfSize:15];
    cLabel.textAlignment = NSTextAlignmentLeft;
    cLabel.text = @"手动:若产生告警会派单;自动:若产生告警不会派单";
    [containerView addSubview:cLabel];
    
    //关闭按钮
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(265, 5, 30, 30);
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_normal.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_pressed.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateSelected];
    [closeBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeBtn];
    
    //自动手动
    isAutoSwitch = [[CustomSwitch alloc]initWithFrame:CGRectMake(105,120,90, 30)];
    [isAutoSwitch setSwitchOnImage:[UIImage imageNamed:@"btn_switcher_on_auto.png"] offImage:[UIImage imageNamed:@"btn_switcher_off_auto.png"]];
    if([_isAuto isEqualToString:@"1"]){
        [isAutoSwitch setOn:YES];
    }else{
        [isAutoSwitch setOn:NO];
    }
    [containerView addSubview:isAutoSwitch];
    
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
    
}

//关闭窗口
-(void)closeWindow{
    [self disappearWinow];
}

//点击提交按钮
-(void)submitHandler {
    if(isAutoSwitch.on == YES){
        _isAuto = @"1";
    }else{
        _isAuto = @"0";
    }
    if(_delegate && [_delegate respondsToSelector:@selector(submitData:)]){
        [_delegate submitData:_isAuto];
        [self closeWindow];
    }
}


-(void)setIsAuto:(NSString *)isAuto{
    _isAuto = isAuto;
    if(isAutoSwitch!=nil){
        if([_isAuto isEqualToString:@"1"]){
            [isAutoSwitch setOn:YES];
        }else{
            [isAutoSwitch setOn:NO];
        }
    }
}
@end
