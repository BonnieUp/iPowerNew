//
//  BaseModalViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-1.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"

@interface BaseModalViewController ()

@end

@implementation BaseModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加一个半透明的UIVIEW
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,ScreenHeight)];
    backgroundView.backgroundColor  = [UIColor blackColor];
    backgroundView.alpha = 0.5;
    //添加点击事件
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearWinow)];
    [backgroundView addGestureRecognizer:recognizer];
    [self.view addSubview:backgroundView];
}

//隐藏弹出框
-(void)disappearWinow {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
