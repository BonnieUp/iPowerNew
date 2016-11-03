//
//  WodewangguanViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "WodewangguanViewController.h"
#import "PowerDataService.h"

@interface WodewangguanViewController ()

@end

@implementation WodewangguanViewController {
    NSMutableArray *controllers;
    UIView *tabbarView;
    BOOL isComplete;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBar setHidden:YES];
        
    }
    return self;
}
//隐藏tabbar
- (void)makeTabBarHidden:(BOOL)hide {
    if ( [self.view.subviews count] < 2 )
        return;
    UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    
    if ( hide ){
        contentView.frame = self.view.bounds;
    }
    else{
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
    }
    self.tabBar.hidden = hide;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeTabBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(isComplete == NO){
        //首先获取该用户的区局信息
        PowerDataService *dataService = [[PowerDataService alloc]init];
        RequestCompleteBlock block = ^(id result) {
            NSMutableArray *legalAreaList = [[NSMutableArray alloc]init];
            NSArray *areaList = (NSArray *)result;
            for (NSDictionary *dic  in areaList ) {
                if([[dic objectForKey:@"IS_CAN_ACCESS"] isEqualToString:@"1"]) {
                    [legalAreaList addObject:dic];
                }
            }
            //如果区局为0，提示没有权限，点击确定返回到i运维
            if(legalAreaList.count == 0 ) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您无权访问.." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alertView.tag = 100;
                alertView.delegate = self;
                [alertView show];
                return;
            }else if(legalAreaList.count == 1 ) {
                NSString *areaName = [[legalAreaList objectAtIndex:0] objectForKey:@"REG_NAME"];
                self.titleStr = [NSString stringWithFormat:@"我的网管(%@)",areaName];
                self.siteList = legalAreaList;
            }else if(legalAreaList.count > 1 && legalAreaList.count < areaList.count ) {
                self.titleStr = @"我的网管(多区局)";
                self.siteList = legalAreaList;
            }else {
                self.titleStr = @"我的网管(全网)";
                self.siteList = legalAreaList;
            }
            
        };
        [dataService getUserAreaDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:nil showHUD:YES];
        isComplete = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isComplete = NO;
    controllers = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    gaojingCtrl = [[GaojingViewController alloc]init];
    guanchaCtrl = [[GuanchaViewController alloc]init];
    guzhangpaixiuCtrl = [[GuzhangpaixiuViewController alloc]init];
    [controllers addObject:gaojingCtrl];
    [controllers addObject:guanchaCtrl];
    [controllers addObject:guzhangpaixiuCtrl];
    
    self.viewControllers = controllers;
    
    //自定义tabbar
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40, ScreenWidth, 40)];
    tabbarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    float tabWidth = self.view.frame.size.width / [controllers count];
    _tabs = [[NSMutableArray alloc] init];
    for (int i=0; i < [controllers count]; i++)
    {
        UIViewController *controller = [controllers objectAtIndex:i];
        // Create button
        UIButton *tab = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, 40)];
        [tab setTitle:controller.title forState:UIControlStateNormal];
        tab.titleLabel.font = [UIFont systemFontOfSize:14];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        tab.backgroundColor = [UIColor colorWithRed:238/255.0 green:246/255.0 blue:249/255.0 alpha:1];
        [tab setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:185/255.0 green:217/255.0 blue:233/255.0 alpha:1] size:CGSizeMake(120, 40)] forState:UIControlStateSelected];
        [tab addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarView addSubview:tab];
        [_tabs addObject:tab];
        
        // Add separator
        if( i>0 )
        {
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(i*tabWidth,
                                                                   0,
                                                                   0.5,
                                                                   40)];
            [sep setBackgroundColor:[UIColor colorWithWhite:1 alpha:1.0]];
            [tabbarView addSubview:sep];
        }
    }
    [self.view addSubview:tabbarView];
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    [self selectTabNum:0];
    
    [self createSearchBtn];
}

//创建查询按钮
-(void)createSearchBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth-120, 0, 120,NAVIGATION_BAR_HEIGHT);
    [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"right_s.png"] scaleToSize:CGSizeMake(20,20)] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10,100, 10,0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 10, 20)];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(popSearchWindow) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if(IOS_LEVEL>=7){
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -15;
        
        self.navigationItem.rightBarButtonItems = @[negativeSeperator,buttonItem];
    }else{
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}

//弹出查询窗口
-(void)popSearchWindow {
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"测试" message:[NSString stringWithFormat:@"%i",self.selectedIndex] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alertView show];
    //告警查询
    if(self.selectedIndex == 0 ) {
        [gaojingCtrl popSearchWindow];
    }else if(self.selectedIndex == 1) {
        [guanchaCtrl popSearchWindow];
    }else if(self.selectedIndex == 2) {
        [guzhangpaixiuCtrl popSearchWindow];
    }
}

//设置tab
- (void)selectTab:(id)sender
{
    NSInteger selectIndex = [_tabs indexOfObject:sender];
    [self deselectAllTabs];
    [sender setSelected:YES];
    self.selectedIndex = selectIndex;
}

//设置tab
- (void)selectTabNum:(NSInteger)index
{
    if(index<0 || index>=[_tabs count])
    {
        return;
    }
    UIButton *tab = [_tabs objectAtIndex:index];
    [self selectTab:tab];
}

//去掉当前所有tab的选中状态
- (void)deselectAllTabs
{
    for (UIButton *tab in _tabs)
    {
        [tab setSelected:NO];
//        [tab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    [gaojingCtrl setTitleWithPosition:@"left" title:titleStr];
    [guanchaCtrl setTitleWithPosition:@"left" title:titleStr];
    [guzhangpaixiuCtrl setTitleWithPosition:@"left" title:titleStr];
    
}

-(void)setSiteList:(NSArray *)siteList {
    _siteList = siteList;
    gaojingCtrl.siteList = siteList;
    guanchaCtrl.siteList = siteList;
    guzhangpaixiuCtrl.siteList = siteList;
}

-(void)setBackToHomePage:(BOOL)backToHomePage {
    _backToHomePage = backToHomePage;
    gaojingCtrl.backToHomePage = _backToHomePage;
    guanchaCtrl.backToHomePage = _backToHomePage;
    guzhangpaixiuCtrl.backToHomePage = _backToHomePage;
}

#pragma mark ----alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //我的网管alertview
    //返回到i运维
    NSString *urlStr = @"telecom://iPower/launchTelecom";
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

@end
