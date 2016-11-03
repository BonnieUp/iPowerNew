//
//  GaojingViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GaojingViewController.h"
#import "PowerDataService.h"

@interface GaojingViewController ()

@end

@implementation GaojingViewController {
    //存放设备大类列表
    NSMutableArray *deviceClassList;
    //存放告警级别列表
    NSArray *gaojingjibieList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"告警";
        [self setTitleWithPosition:@"left" title:@"我的网管"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Resource-Info" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    gaojingjibieList = [data objectForKey:@"gaojingdengji"];
    
    deviceClassList = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    _menuHeight = 40;
    dangqianCtrl = [[DangqiangaojingViewController alloc]init];
    dangqianCtrl.delegate =self;
    lishiCtrl = [[LishigaojingViewController alloc]init];
    lishiCtrl.delegate = self;
    NSArray *viewControllers = [NSMutableArray arrayWithObjects:dangqianCtrl,lishiCtrl,nil];
    self.controllers = viewControllers;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
    
    [self getShebeidaleiForWangguan];
}




//设置contentScrollView的内容大小
-(void)viewWillLayoutSubviews
{
    _contentScrollView.frame = CGRectMake(0.0,
                                          _menuHeight,
                                          ScreenWidth,
                                          ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-_menuHeight-40);
    [_contentScrollView setShowsHorizontalScrollIndicator:NO];
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];
        
        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
    }
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width * [_controllers count], ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-_menuHeight-40)];
}

//布局视图
- (void)loadUI
{
    //创建滚动视图
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,_menuHeight,
                                                                        ScreenWidth,
                                                                        ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT - _menuHeight-40)];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setDelegate:self];
    _contentScrollView.bounces = NO;
    float tabWidth = self.view.frame.size.width / [_controllers count];
    _tabs = [[NSMutableArray alloc] init];
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];
        
        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
        [_contentScrollView addSubview:[controller view]];
        
        // Create button
        UIButton *tab = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, _menuHeight)];
        [tab setTitle:controller.title forState:UIControlStateNormal];
        tab.titleLabel.font = [UIFont systemFontOfSize:13];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tab.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        //        [tab setBackgroundImage:[UIImage imageNamed:@"tabbar_background.png"] forState:UIControlStateSelected];
        [tab setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1] size:tab.size] forState:UIControlStateSelected];
        [tab addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tab];
        [_tabs addObject:tab];
        
        //添加显示数量的图标
        UIImageView *amoutView = [[UIImageView alloc]initWithFrame:CGRectMake(tab.right-40, 2,35, 35)];
        amoutView.tag = 200+i;
        amoutView.hidden = YES;
        amoutView.image = [UIImage imageNamed:@"bg_num_red.9.png"];
        UILabel *amountLabel = [[UILabel alloc]initWithFrame:amoutView.bounds];
        amountLabel.font = [UIFont systemFontOfSize:11];
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.textColor = [UIColor whiteColor];
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.tag = 100;
        [amoutView addSubview:amountLabel];
        [self.view addSubview:amoutView];
        
        // Add separator
        if( i>0 )
        {
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(i*tabWidth,
                                                                   0,
                                                                   0.5,
                                                                   40)];
            [sep setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]];
            [self.view addSubview:sep];
        }
    }
    UIView *bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, _menuHeight- 1.0, self.view.frame.size.width, 1.0)];
    //    bottomHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    bottomHeaderView.backgroundColor = [UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1];
    [self.view addSubview:bottomHeaderView];
    
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    selectedTab = 0;
    [self.view addSubview:_contentScrollView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if(selectedTab == 0 ) {
//        [dangqianCtrl viewDidAppear:YES];
//    }
//    else if(selectedTab == 1) {
//        [lishiCtrl viewDidAppear:YES];
//    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self deselectAllTabs];
    UIButton *tab = [_tabs objectAtIndex:page];
    [tab setSelected:YES];
    if(selectedTab != page ) {
        selectedTab = page;
        if(selectedTab==0) {
            [dangqianCtrl viewDidAppear:YES];
        }else if(selectedTab==1) {
            [lishiCtrl viewDidAppear:YES];
        }
    }
    selectedTab = page;
    
}

#pragma mark --dangqiangaojing delegate
-(void)setDangqiangaojingAmount:(NSString *)amount {
//    UIButton *tab = [_tabs objectAtIndex:0];
    if(![amount isEqualToString:@"0"]){
        UIImageView *amountImageView = (UIImageView *)[self.view viewWithTag:200];
        amountImageView.hidden = NO;
        UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:100];
        amountLabel.text = amount;
    }else{
        UIImageView *amountImageView = (UIImageView *)[self.view viewWithTag:200];
        amountImageView.hidden = YES;
        UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:100];
        amountLabel.text = @"";
    }
//    if(![amount isEqualToString:@"0"]) {
//        [tab setTitle:[NSString stringWithFormat:@"当前告警(%@)",amount] forState:UIControlStateNormal];
//        [tab setTitle:[NSString stringWithFormat:@"当前告警(%@)",amount] forState:UIControlStateSelected];
//    }else {
//        [tab setTitle:@"当前告警" forState:UIControlStateNormal];
//        [tab setTitle:@"当前告警" forState:UIControlStateSelected];
//    }
}

-(void)setLishigaojingAmount:(NSString *)amount {
//    UIButton *tab = [_tabs objectAtIndex:1];
//    if(amount!=nil && ![amount isEqualToString:@"0"]) {
//        [tab setTitle:[NSString stringWithFormat:@"历史告警(%@)",amount] forState:UIControlStateNormal];
//        [tab setTitle:[NSString stringWithFormat:@"历史告警(%@)",amount] forState:UIControlStateSelected];
//    }else {
//        [tab setTitle:@"历史告警" forState:UIControlStateNormal];
//        [tab setTitle:@"历史告警" forState:UIControlStateSelected];
//    }
    if(![amount isEqualToString:@"0"]){
        UIImageView *amountImageView = (UIImageView *)[self.view viewWithTag:201];
        amountImageView.hidden = NO;
        UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:100];
        amountLabel.text = amount;
    }else{
        UIImageView *amountImageView = (UIImageView *)[self.view viewWithTag:200];
        amountImageView.hidden = YES;
        UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:100];
        amountLabel.text = @"";
    }
}

//设置tab
- (void)selectTab:(id)sender
{
    selectedTab = [_tabs indexOfObject:sender];
    CGRect rect = CGRectMake(self.view.frame.size.width * selectedTab,
                             0.0,
                             self.view.frame.size.width,
                             _contentScrollView.contentSize.height);
    [_contentScrollView scrollRectToVisible:rect animated:NO];
    [self deselectAllTabs];
    [sender setSelected:YES];
    if(selectedTab==0){
        [dangqianCtrl viewDidAppear:YES];
    }
    else if(selectedTab == 1 ) {
        [lishiCtrl viewDidAppear:YES];
    }
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
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void)popSearchWindow {
    GaojingFilterConditionViewController *conditionCtrl = [[GaojingFilterConditionViewController alloc]init];
    conditionCtrl.siteList = _siteList;
    conditionCtrl.deviceClassList = deviceClassList;
    conditionCtrl.gaojingdengjiList = gaojingjibieList;
    conditionCtrl.delegate = self;
    if(selectedTab == 0 ) {
        [conditionCtrl setTitleWithPosition:@"center" title:@"当前告警查询"];
        conditionCtrl.selectTabIndex = @"1";
    }else if(selectedTab == 1) {
        [conditionCtrl setTitleWithPosition:@"center" title:@"历史告警查询"];
        conditionCtrl.selectTabIndex = @"2";
    }
    [self.navigationController pushViewController:conditionCtrl animated:YES];
        
}

#pragma  mark --- gaojingfilter delegate
-(void)gaojingFilterOnChange:(NSDictionary *)dic {
    if(selectedTab == 0 ) {
        [dangqianCtrl searchGaojingWithFilter:dic];
    }else if(selectedTab == 1) {
        [lishiCtrl searchGaojingWithFilter:dic];
    }
}

//获取网管模块里的设备大类列表
-(void)getShebeidaleiForWangguan {
    RequestCompleteBlock block = ^(id result ) {
        for (NSDictionary *dic in result) {
            NSMutableDictionary *itemDic = [[NSMutableDictionary alloc]init];
            [itemDic setValue:[dic objectForKey:@"DEV_CLASS_NAME"] forKey:@"name"];
            [itemDic setValue:[dic objectForKey:@"DEV_CLASS_NUM"] forKey:@"value"];
            [deviceClassList addObject:itemDic];
        }
        
        
    };
    PowerDataService *dataService = [[PowerDataService alloc]init];
    [dataService getDeviceClassForWangguanWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:nil showHUD:NO];
}

-(void)setSiteList:(NSArray *)siteList {
    _siteList = siteList;
    dangqianCtrl.siteList = siteList;
    lishiCtrl.siteList = siteList;
}

//重写backAction
-(void)backAction {
    //如果可以跳转到主界面
    if(_backToHomePage==YES){
        [super backAction];
    }
    //跳转到i运维
    else {
        NSString *urlStr = @"telecom://iPower/returnTelecom?fnType=iPowerPR";
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
