//
//  XunjianDeviceMainViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "XunjianDeviceMainViewController.h"
#import "DeviceDetailEditMainViewController.h"
@interface XunjianDeviceMainViewController ()

@end

@implementation XunjianDeviceMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"left" title:@"资源巡检"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _menuHeight = 40;
    weichaCtrl = [[WeichaDeviceListViewController alloc]init];
    weichaCtrl.delegate = self;
    yichaCtrl = [[YichaDeviceListViewController alloc]init];
    yichaCtrl.delegate = self;
    NSArray *viewControllers = [NSMutableArray arrayWithObjects:weichaCtrl,yichaCtrl,nil];
    self.controllers = viewControllers;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [weichaCtrl getWeichaDeviceList];
    [yichaCtrl getYichaDeviceList];
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
    _amountLabels = [[NSMutableArray alloc]init];
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
        
        // Create label
        UIImageView *labelImageView = [[UIImageView alloc]initWithFrame:CGRectMake((i+1) * tabWidth-50, 5, 25, 25)];
        [labelImageView setHidden:YES];
        labelImageView.image = [UIImage imageNamed:@"bg_num_red.9.png"];
        UILabel *labelView = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 25, 25)];
        labelView.font = [UIFont systemFontOfSize:12];
        labelView.textAlignment = NSTextAlignmentCenter;
        labelView.textColor = [UIColor whiteColor];
        labelView.backgroundColor = [UIColor clearColor];
        labelView.tag = 101;
        [labelImageView addSubview:labelView];
        [self.view addSubview:labelImageView];
        [_amountLabels addObject:labelImageView];
        
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

#pragma mark ---- weichaDeviceList delegate
-(void)setWeichaDeviceAmount:(NSString *)amount {
//    UIButton *tab = [_tabs objectAtIndex:0];
//    if(![amount isEqualToString:@"0"]) {
//        [tab setTitle:[NSString stringWithFormat:@"未查(%@)",amount] forState:UIControlStateNormal];
//        [tab setTitle:[NSString stringWithFormat:@"未查(%@)",amount] forState:UIControlStateSelected];
//    }else {
//        [tab setTitle:@"未查" forState:UIControlStateNormal];
//        [tab setTitle:@"未查" forState:UIControlStateSelected];
//    }
    UIImageView *amountImageView = [_amountLabels objectAtIndex:0];
    if([amount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = amount;
}

-(void)popEditDeivceController:(NSDictionary *)dic {
    DeviceDetailEditMainViewController *editDeviceCtrl = [[DeviceDetailEditMainViewController alloc]init];
    editDeviceCtrl.deviceDic = dic;
    editDeviceCtrl.deviceStatusList = _deviceStatusList;
    editDeviceCtrl.roomList = _roomList;
    editDeviceCtrl.suoshuxitongList = _suoshuxitongList;
//    editDeviceCtrl.shengchanchangjiaList = _shengchanchangjiaList;
    editDeviceCtrl.stationNum = [_stationDic objectForKey:@"STATION_NUM"];;
    [self.navigationController pushViewController:editDeviceCtrl animated:YES];
}

-(void)setYichaDeviceAmount:(NSString *)amount {
//    UIButton *tab = [_tabs objectAtIndex:1];
//    if(![amount isEqualToString:@"0"]) {
//        [tab setTitle:[NSString stringWithFormat:@"已查(%@)",amount] forState:UIControlStateNormal];
//    }else {
//        [tab setTitle:@"已查" forState:UIControlStateNormal];
//    }
    UIImageView *amountImageView = [_amountLabels objectAtIndex:1];
    if([amount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = amount;
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

//获取本地存储的巡检设备信息
-(void)getLocalXunjianDevice {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray *localDeviceList = [userDefaults objectForKey:_stationNum];
//    NSMutableArray *newLocalDeviceList = [NSMutableArray arrayWithArray:localDeviceList];
//    NSMutableArray *checkedDevice = [[NSMutableArray alloc]init];
//    NSMutableArray *unCheckedDevice = [[NSMutableArray alloc]init];
//    for (NSDictionary *dic in newLocalDeviceList) {
//        if([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
//            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//            [unCheckedDevice addObject:newDic];
//        }else {
//            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//            [checkedDevice addObject:newDic];
//        }
//    }
    weichaCtrl.stationNum = [_stationDic objectForKey:@"STATION_NUM"];
    yichaCtrl.stationNum = [_stationDic objectForKey:@"STATION_NUM"];
}

-(void)setStationDic:(NSDictionary *)stationDic {
    _stationDic = stationDic;
    [self getLocalXunjianDevice];
    [self loadData];
}

//获取数据
-(void)loadData {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth-120, 0, 120,NAVIGATION_BAR_HEIGHT);
    [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"right_s.png"] scaleToSize:CGSizeMake(20,20)] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10,100, 10,0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 10, 20)];
    [btn setTitle:[_stationDic objectForKey:@"STATION_NAME"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(siteOnChangeHandler) forControlEvents:UIControlEventTouchUpInside];
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

-(void)siteOnChangeHandler {
    //发送改变选择站点的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeStation" object:nil];
}
@end
