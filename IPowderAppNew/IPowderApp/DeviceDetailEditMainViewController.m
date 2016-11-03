//
//  DeviceDetailEditMainViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "DeviceDetailEditMainViewController.h"
#import "PowerDataService.h"
@interface DeviceDetailEditMainViewController ()

@end

@implementation DeviceDetailEditMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"设备详细信息"];
        
        //监听保存设备属性的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCommonDeviceProperty) name:@"saveCommonDeviceProperty" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveExtendDeviceProperty) name:@"saveExtendDeviceProperty" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveConnectorDeviceProperty) name:@"saveConnectorDeviceProperty" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _menuHeight = 40;
    gonggongshuxingCtrl = [[EditGonggongshuxingViewController alloc]init];
    kuozhanshuxingCtrl = [[EditKuozhanshuxingViewController alloc]init];
    
    shebeiduankouCtrl = [[EditShebeiduanziViewController alloc]init];
    
    NSArray *viewControllers = [NSMutableArray arrayWithObjects:gonggongshuxingCtrl,kuozhanshuxingCtrl,shebeiduankouCtrl,nil];
    self.controllers = viewControllers;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
//    [self getChangejiaList];
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    if(page == 0){
        [gonggongshuxingCtrl getGonggongshuxing];
    }else if(page == 2){
        [shebeiduankouCtrl getDuanzixinxi];
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
    }else if(selectedTab == 2){
        [shebeiduankouCtrl getDuanzixinxi];
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
        gonggongshuxingCtrl.deviceDic = _deviceDic;
        kuozhanshuxingCtrl.deviceDic = _deviceDic;
        shebeiduankouCtrl.deviceDic = _deviceDic;
    }
}

-(void)setStationNum:(NSString *)stationNum {
    _stationNum = stationNum;
    kuozhanshuxingCtrl.stationNum = stationNum;
    shebeiduankouCtrl.stationNum = stationNum;
}

//获取设备厂家数据
//-(void)getChangejiaList {
//    PowerDataService *dataService = [[PowerDataService alloc]init];
//    RequestCompleteBlock block = ^(id result) {
//        gonggongshuxingCtrl.shengchanchangjiaList = (NSArray *)result;
//    };
//    
//    [dataService GetDeviceBFDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devNum:@"" devTypeNum:@"" devSubClassNum:@"" devClassNum:@"" devSubClassName:@"" devTypeName:@"" devMaker:@"" completeBlock:block loadingView:nil showHUD:NO];
//}

-(void)setDeviceStatusList:(NSArray *)deviceStatusList {
    _deviceStatusList = deviceStatusList;
    gonggongshuxingCtrl.deviceStatusList = deviceStatusList;
}

-(void)setRoomList:(NSArray *)roomList {
    _roomList = roomList;
    gonggongshuxingCtrl.roomList = roomList;
}

-(void)setSuoshuxitongList:(NSArray *)suoshuxitongList {
    _suoshuxitongList = suoshuxitongList;
    gonggongshuxingCtrl.suoshuxitongList = suoshuxitongList;
}

//-(void)setShengchanchangjiaList:(NSArray *)shengchanchangjiaList {
//    _shengchanchangjiaList = shengchanchangjiaList;
//    gonggongshuxingCtrl.shengchanchangjiaList = shengchanchangjiaList;
//}

-(void)saveLocalDeviceProperty {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *localDeviceList = [userDefaults objectForKey:_stationNum];
    NSMutableArray *newLocalDeviceList = [[NSMutableArray alloc]init];
    //找到当前的设备
    for (NSDictionary *dic in localDeviceList) {
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if([[newDic objectForKey:@"DEV_NUM"] isEqualToString:[_deviceDic objectForKey:@"DEV_NUM"]]) {
            //设置为已查
            [newDic setValue:@"YES" forKey:@"checked"];
        }
        [newLocalDeviceList addObject:newDic];
    }
    [userDefaults setObject:newLocalDeviceList forKey:_stationNum];
    [userDefaults synchronize];
}

//保存设备属性
-(void)saveCommonDeviceProperty {
    //首先生成json
    NSDictionary *commonJsonDic = [gonggongshuxingCtrl createJsonDictonry];
    NSError *error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:commonJsonDic
                                                      options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str;
    if(jsonData.length > 0 && error == nil ) {
        str= [[NSString alloc] initWithData:jsonData
                                   encoding:NSUTF8StringEncoding];
    }else {
        NSLog(@"生成json格式有误");
    }
    //保存设备属性
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:(NSString *)result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    };
    
    [dataService saveDevicePropertyWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devInfo:str completeBlock:block loadingView:nil showHUD:NO];
    
    [self saveLocalDeviceProperty];
}

-(void)saveExtendDeviceProperty {
    //首先生成json
    NSDictionary *commonJsonDic = [kuozhanshuxingCtrl createJsonDictonry];
    NSError *error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:commonJsonDic
                                                      options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str;
    if(jsonData.length > 0 && error == nil ) {
        str= [[NSString alloc] initWithData:jsonData
                                   encoding:NSUTF8StringEncoding];
    }else {
        NSLog(@"生成json格式有误");
    }
    //保存设备属性
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:(NSString *)result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    };
    
    [dataService saveDevicePropertyWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devInfo:str completeBlock:block loadingView:nil showHUD:NO];
    
    [self saveLocalDeviceProperty];
}

-(void)saveConnectorDeviceProperty {
    //首先生成json
    NSDictionary *commonJsonDic = [shebeiduankouCtrl createJsonDictonry];
    NSError *error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:commonJsonDic
                                                      options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str;
    if(jsonData.length > 0 && error == nil ) {
        str= [[NSString alloc] initWithData:jsonData
                                   encoding:NSUTF8StringEncoding];
    }else {
        NSLog(@"生成json格式有误");
    }
    //保存设备属性
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:(NSString *)result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    };
    
    [dataService saveDevicePropertyWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devInfo:str completeBlock:block loadingView:nil showHUD:NO];
    
    [self saveLocalDeviceProperty];
}
@end
