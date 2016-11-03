//
//  GongdianguanliViewController.m
//  i动力
//
//  Created by 王敏 on 15/12/26.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "GongdianguanliViewController.h"
#import "PowerDataService.h"
#import "UserRegionViewController.h"
#import "XIYI_MBProgressHUD.h"

@implementation GongdianguanliViewController{
    BOOL isComplete;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleWithPosition:@"center" title:@"动力系统供电等级"];
        _regionList = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    _menuHeight = 40;
    isComplete = NO;
    
    juzhanCtrl = [[JuzhangongdianguanliViewController alloc]init];

    jifangCtrl = [[JifanggongdianguanliViewController alloc]init];

    xitongCtrl = [[XitonggongdianguanliViewController alloc]init];

    shebeiCtrl = [[ShebeigongdianguanliViewController alloc]init];

    NSArray *viewControllers = [NSMutableArray arrayWithObjects:juzhanCtrl,jifangCtrl,xitongCtrl,shebeiCtrl,nil];
    self.controllers = viewControllers;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
}

//设置contentScrollView的内容大小
-(void)viewWillLayoutSubviews
{
    _contentScrollView.frame = CGRectMake(0.0,
                                          _menuHeight,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height-_menuHeight);
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
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width * [_controllers count], self.view.frame.size.height - _menuHeight)];
}


//布局视图
- (void)loadUI
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,_menuHeight,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height - _menuHeight)];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setDelegate:self];
    _contentScrollView.bounces = NO;
    
    float tabWidth = self.view.frame.size.width / [_controllers count];
    _tabs = [[NSMutableArray alloc] init];
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];
        
        if(i==0||i==1) {
            [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                                   0.0,
                                                   _contentScrollView.frame.size.width,
                                                   _contentScrollView.frame.size.height-40)];
        }else {
            [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                                   0.0,
                                                   _contentScrollView.frame.size.width,
                                                   _contentScrollView.frame.size.height)];
        }
        
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
    
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    selectedTab = 0;
    
    UIView *bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, _menuHeight- 1.0, self.view.frame.size.width, 1.0)];
    //    bottomHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    bottomHeaderView.backgroundColor = [UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1];
    [self.view addSubview:bottomHeaderView];
    
    [self.view addSubview:_contentScrollView];
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

//设置tab
- (void)selectTab:(id)sender
{
    selectedTab = [_tabs indexOfObject:sender];
    CGRect rect = CGRectMake(self.view.frame.size.width * selectedTab,
                             0.0,
                             self.view.frame.size.width,
                             _contentScrollView.contentSize.height);
    [_contentScrollView scrollRectToVisible:rect animated:YES];
    [self deselectAllTabs];
    [sender setSelected:YES];
    
    if(selectedTab == 0){
        
        if (![juzhanCtrl ishaveData]) {
               [juzhanCtrl getLevelData];

        }
    }else if(selectedTab == 1){
        if (![jifangCtrl ishaveData]) {
            [jifangCtrl getLevelData];
            
        }
    }else if(selectedTab == 2){
        if (![xitongCtrl ishaveData]) {
            [xitongCtrl getLevelData];
            
        }
    }else if(selectedTab == 3){
    if (![shebeiCtrl ishaveData]) {
        [shebeiCtrl getLevelData];
        
    }
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(isComplete == NO ){
        //请求服务器，查看是否有权限访问
    
        [XIYI_MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        PowerDataService *dataService = [[PowerDataService alloc]init];
        RequestCompleteBlock block = ^(id result) {
            [XIYI_MBProgressHUD hideHUDForView:self.view.window animated:YES];
            NSMutableArray *returnArray = [[NSMutableArray alloc]initWithArray:(NSArray *)result];
            
            
            //如果不为空，将第一个作为默认选择区局
            NSMutableDictionary *defaultDic = [[NSMutableDictionary alloc]init];
            [defaultDic setValue:@"全网" forKey:@"REG_NAME"];
            [defaultDic setValue:@"" forKey:@"REG_NUM"];
            [returnArray insertObject:defaultDic atIndex:0];
            _regionList = returnArray;
            selectRegionDic = [_regionList objectAtIndex:0];
            [self setCurrentRegion];
            
            [juzhanCtrl setRegNO:[selectRegionDic objectForKey:@"REG_NUM"]];
            [juzhanCtrl getLevelData];

            [jifangCtrl setRegNO:[selectRegionDic objectForKey:@"REG_NUM"]];
            [xitongCtrl setRegNO:[selectRegionDic objectForKey:@"REG_NUM"]];
            [shebeiCtrl setRegNO:[selectRegionDic objectForKey:@"REG_NUM"]];
        };
        [dataService getUserRegionDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:nil showHUD:NO];
        
        isComplete = YES;
    }
}

//设置当前区局
-(void)setCurrentRegion{
    if(selectRegionDic == nil)
        return;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth-80, 0, 80,NAVIGATION_BAR_HEIGHT);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10,100, 10,0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 10, 20)];
    [btn setTitle:[selectRegionDic objectForKey:@"REG_NAME"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn addTarget:self action:@selector(popRegionView) forControlEvents:UIControlEventTouchUpInside];
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

//弹出选择区局视图
-(void)popRegionView{
    UserRegionViewController *regionCtrl = [[UserRegionViewController alloc]init];
    regionCtrl.regionList = _regionList;
    regionCtrl.selectRegionDic = selectRegionDic;
    regionCtrl.delegate = self;
    regionCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:regionCtrl animated:YES completion:nil];
}

#pragma mark ---- scrollerview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self deselectAllTabs];
    UIButton *tab = [_tabs objectAtIndex:page];
    [tab setSelected:YES];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    if(page == 0){
        if (![juzhanCtrl ishaveData]) {
            [juzhanCtrl getLevelData];
        }
    }else if(page == 1){
        if (![jifangCtrl ishaveData]) {
            [jifangCtrl getLevelData];
        }
    }else if(page == 2 ){
        if (![xitongCtrl ishaveData]) {
            [xitongCtrl getLevelData];
        }
    }else if(page == 3){
        if (![shebeiCtrl ishaveData]) {
            [shebeiCtrl getLevelData];
        }
    }
}

#pragma mark ---userRegionCtrl delegate
-(void)regionOnSelect:(BaseModalViewController *)ctrl regionDic:(NSDictionary *)regionDic {
    [ctrl disappearWinow];
    selectRegionDic = regionDic;
    [self setCurrentRegion];
    [juzhanCtrl setRegNO:[selectRegionDic objectForKey:@"REG_NUM"]];
    [jifangCtrl setRegNO:[selectRegionDic objectForKey:@"REG_NUM"]];
    [xitongCtrl setRegNO:[selectRegionDic objectForKey:@"REG_NUM"]];
    [shebeiCtrl setRegNO:[selectRegionDic objectForKey:@"REG_NUM"]];
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
