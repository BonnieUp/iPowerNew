//
//  DeviceDetailMainViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-8.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "DeviceDetailMainViewController.h"
#import "DuanziDetailViewViewController.h"
#import "PowerDataService.h"
@interface DeviceDetailMainViewController ()

@end

@implementation DeviceDetailMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"设备详细信息"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _menuHeight = 40;
    gonggongshuxingCtrl = [[GonggongshuxingViewController alloc]init];
    
    kuozhanshuxingCtrl = [[KuozhanshuxingViewController alloc]init];
    
    shebeiduankouCtrl = [[ShebeiduanziViewController alloc]init];
    
    NSArray *viewControllers = [NSMutableArray arrayWithObjects:gonggongshuxingCtrl,kuozhanshuxingCtrl,shebeiduankouCtrl,nil];
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
    //创建滚动视图
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,_menuHeight,
                                                                        ScreenWidth,
                                                                        ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT - _menuHeight)];
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

#pragma mark ---- scrollerview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    float tabWidth = _indicatorView.frame.size.width;
    _indicatorView.frame = CGRectMake(page * tabWidth, _menuHeight  - 5.0, tabWidth, 5.0);
    [self deselectAllTabs];
    UIButton *tab = [_tabs objectAtIndex:page];
    [tab setSelected:YES];
}

#pragma mark --- shebeiduanzi delegate
-(void)popDuanziDetailWith:(NSDictionary *)dic {
    DuanziDetailViewViewController *duanziCtrl = [[DuanziDetailViewViewController alloc]init];
    duanziCtrl.duanziDic = dic;
    duanziCtrl.deviceName = [_deviceDic objectForKey:@"DEV_NAME"];
    [self.navigationController pushViewController:duanziCtrl animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    if(page == 0){
        [gonggongshuxingCtrl getGonggongshuxing];
    }else if(page == 1){
        [kuozhanshuxingCtrl getKuozhanshuxing];
    }else if(page == 2){
        [shebeiduankouCtrl getShebeiduanzi];
    }
}

//设置tab
- (void)selectTab:(id)sender
{
    selectedTab = [_tabs indexOfObject:sender];
    float tabWidth = self.view.frame.size.width / [_controllers count];
    CGRect rect = CGRectMake(self.view.frame.size.width * selectedTab,
                             0.0,
                             self.view.frame.size.width,
                             _contentScrollView.contentSize.height);
    [_contentScrollView scrollRectToVisible:rect animated:NO];
    [self deselectAllTabs];
    [sender setSelected:YES];
    _indicatorView.frame = CGRectMake(selectedTab*tabWidth, _menuHeight  - 5.0,tabWidth , 5.0);
    
    if(selectedTab == 0){
        [gonggongshuxingCtrl getGonggongshuxing];
    }else if(selectedTab == 1){
        [kuozhanshuxingCtrl getKuozhanshuxing];
    }else if(selectedTab == 2){
        [shebeiduankouCtrl getShebeiduanzi];
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

-(void)setDeviceDic:(NSDictionary *)deviceDic{
    if(![_deviceDic isEqual:deviceDic]) {
        _deviceDic = deviceDic;
        gonggongshuxingCtrl.deviceDic = deviceDic;
        kuozhanshuxingCtrl.deviceDic = deviceDic;
        shebeiduankouCtrl.deviceDic = deviceDic;
        shebeiduankouCtrl.delegate = self;
    }
}

-(void)setDeviceStatusList:(NSArray *)deviceStatusList {
    gonggongshuxingCtrl.deviceStatusList = deviceStatusList;
}


@end
