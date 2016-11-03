//
//  FilterWayViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "FilterWayViewController.h"
#import "UIGlossyButton.h"
@interface FilterWayViewController ()

@end

@implementation FilterWayViewController {
    UIView *containerView;
    //手动筛选按钮
    UIGlossyButton * manualFilterBtn;
    //设备扫描筛选按钮
    UIGlossyButton * saomiaoFilterBtn;
    //显示全部设备按钮
    UIGlossyButton * showAllBtn;
    //关闭按钮
    UIButton *closeBtn;
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
    
    containerView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-280)/2, (ScreenHeight-STATUS_BAR_HEIGHT-150)/2, 280, 210)];
    containerView.layer.cornerRadius = 5;
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    //名称
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, containerView.width-10, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设备筛选";
    [containerView addSubview:titleLabel];
    
    //关闭按钮
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(245, 5, 30, 30);
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_normal.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_pressed.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateSelected];
    [closeBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeBtn];
    //显示全部设备
    showAllBtn = [[UIGlossyButton alloc]init];
    showAllBtn.frame = CGRectMake(15,50,250, 35);
    [showAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
//    [showAllBtn setBackgroundImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_green.9.png"] scaleToSize:showAllBtn.frame.size] forState:UIControlStateNormal];
    [showAllBtn setNavigationButtonWithColor:[UIColor colorWithRed:55.0/255 green:173.0/255	 blue:68.0/255 alpha:1]];
    [showAllBtn addTarget:self action:@selector(showAllDeviceHandler) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:showAllBtn];
    
    //手动筛选
    manualFilterBtn = [[UIGlossyButton alloc]init];
    manualFilterBtn.frame = CGRectMake(15,100,250, 35);
    [manualFilterBtn setTitle:@"手动筛选" forState:UIControlStateNormal];
    [manualFilterBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [manualFilterBtn addTarget:self action:@selector(manualFilterHandler) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:manualFilterBtn];
    
    //设备扫描
    saomiaoFilterBtn = [[UIGlossyButton alloc]init];
    saomiaoFilterBtn.frame = CGRectMake(15,150,250, 35);
    [saomiaoFilterBtn setTitle:@"条形码扫描设备" forState:UIControlStateNormal];
    [saomiaoFilterBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [saomiaoFilterBtn addTarget:self action:@selector(saomiaoFilterHandler) forControlEvents:UIControlEventTouchUpInside];
    [containerView  addSubview:saomiaoFilterBtn];
}

//关闭窗口
-(void)closeWindow {
    [self disappearWinow];
}

//显示所有设备
-(void)showAllDeviceHandler {
    if(_delegate && [_delegate respondsToSelector:@selector(chooseShowAllButton)]) {
        [_delegate chooseShowAllButton];
    }
    [self disappearWinow];
}

//切换到手动筛选视图
-(void)manualFilterHandler {
    if(_delegate && [_delegate respondsToSelector:@selector(chooseManualFilter)]) {
        [_delegate chooseManualFilter];
    }
    [self disappearWinow];
}

//切换到扫描视图
-(void)saomiaoFilterHandler {
    if(_delegate && [_delegate respondsToSelector:@selector(chooseSaomiaoFilter)]) {
        [_delegate chooseSaomiaoFilter];
    }
    [self disappearWinow];
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
