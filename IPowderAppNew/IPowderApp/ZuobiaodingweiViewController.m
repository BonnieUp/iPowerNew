//
//  ZuobiaodingweiViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//-------------------
//坐标定位视图
//-------------------
#import "ZuobiaodingweiViewController.h"
#import "PowerDataService.h"
#import "SiteInfoCell.h"
@interface ZuobiaodingweiViewController ()

@end

@implementation ZuobiaodingweiViewController {
    //过滤栏
    UITextField *searchBar;
    NSArray *siteListOri;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"left" title:@"周期维护"];
        //监听键盘显示事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHandler:) name:UIKeyboardDidShowNotification object:nil];
        //监听键盘隐藏事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideHandler:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:searchBar];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //初始化siteArray
    _siteArray = [[NSMutableArray alloc]init];
    
    //初始化location
    locationManager = [[CLLocationManager alloc]init];
    if([CLLocationManager locationServicesEnabled]) {
        locationManager.delegate = self;
        locationManager.distanceFilter = 10;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if(IOS_LEVEL>=8.0){
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }else {
        NSLog(@"location disabled");
    }

//    locationService = [[BMKLocationService alloc]init];
//    locationService.delegate = self;
//    [locationService startUserLocationService];
//    
//    locationService = [[BMKLocationService alloc]init];
//    locationService.delegate = self;
//    [locationService startUserLocationService];
    
    //提示正在获取坐标数据
//    UIApplication *app =[UIApplication sharedApplication];
//    AppDelegate *delegate = app.delegate;
//    [delegate showHUD];
    
    //显示经度和纬度
    lngLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 90, 20)];
    lngLabel.textAlignment = NSTextAlignmentRight;
    latLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
    latLabel.textAlignment = NSTextAlignmentRight;
    lngLabel.font = [UIFont systemFontOfSize:12];
    lngLabel.textColor = [UIColor whiteColor];
    lngLabel.backgroundColor = [UIColor clearColor];
    latLabel.font = [UIFont systemFontOfSize:12];
    latLabel.textColor =[UIColor whiteColor];
    latLabel.backgroundColor = [UIColor clearColor];
    UIView *locationLabelView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth-100, 0, 90, 40)];
    [locationLabelView addSubview:lngLabel];
    [locationLabelView addSubview:latLabel];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationLabelView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    //搜索栏
    UIView *searchBarContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    searchBarContainer.backgroundColor = [UIColor colorWithRed:238/255.0 green:246/255.0 blue:249/255.0 alpha:1];
    [self.view addSubview:searchBarContainer];
    
    searchBar = [[UITextField alloc]initWithFrame:CGRectMake(10,5, ScreenWidth-20, 35)];
    searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchBar.borderStyle = UITextBorderStyleRoundedRect;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    searchBar.delegate = self;
    //设置左边放大镜图标
    //    UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0,0,45, 20)];
    //    UIImage *image = [UIImage imageNamed: @"ic_search.png"];
    //    UIImageView *iView = [[UIImageView alloc] initWithImage:image];
    //    iView.frame = CGRectMake(5, 0, 25, 25);
    //    [imageView addSubview:iView];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 35, 25);
    [leftBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"ic_search.png"] scaleToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    [leftBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"ic_search.png"] scaleToSize:CGSizeMake(25, 25)] forState:UIControlStateSelected];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0,0);
    searchBar.leftView = leftBtn;
    searchBar.placeholder = @"搜索";
    [searchBarContainer addSubview:searchBar];
//    UIView *searchBarContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
//    searchBarContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
//    [self.view addSubview:searchBarContainer];
//    
//    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 40)];
//    searchBar.backgroundColor = [UIColor clearColor];
//    searchBar.delegate = self;
//    for (UIView *view in searchBar.subviews) {
//        // for before iOS7.0
//        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            [view removeFromSuperview];
//            break;
//        }
//        // for later iOS7.0(include)
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
//            break;
//        }
//    }
//    searchBar.placeholder = @"搜索";
//    
//    [searchBarContainer addSubview:searchBar];
    
    //添加站点信息
    siteTable = [[UITableView alloc]initWithFrame:CGRectMake(0,45, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-45) style:UITableViewStylePlain];
    siteTable.delegate = self;
    siteTable.dataSource = self;
    siteTable.bounces = NO;
    [siteTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:siteTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark uisearchbar delegate
//当searchbar文字改变时，过滤siteList
-(void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    NSString *keyword;
    if([textField.text length]==0) {
        keyword = @"";
    }else {
        keyword = textField.text;
    }
    [self filterSiteList:keyword];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self closeKeyboard];
    return YES;
}

//过滤siteList
-(void)filterSiteList:(NSString *)keyword {
    
    if([keyword isEqualToString:@""]) {
        _siteArray = siteListOri;
    }else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"siteName contains[c] %@", keyword];
        _siteArray = [siteListOri filteredArrayUsingPredicate:predicate];
    }
    [siteTable reloadData];
}

//关闭键盘
-(void)closeKeyboard {
    [searchBar resignFirstResponder];
}

//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //当键盘显示时，重新设置scroller的contentsize;
    siteTable.frame = CGRectMake(0,45, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-keyboardSize.height-45);
    
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    siteTable.frame = CGRectMake(0,45, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-45);
}
#pragma mark ---location delegate
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    location = [locations objectAtIndex:0];
//    //获取地理位置以后关闭
//    [locationManager stopUpdatingLocation];
//    //显示当前坐标
//    lngLabel.text = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
//    latLabel.text = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
//    //拿到地理坐标以后获取该坐标附近的站点
//    [self getSiteWithLocation];
//}

//处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//        NSLog(@"heading is %@",userLocation.heading);
//}
////处理位置坐标更新
//- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
//{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    [self getSiteWithLocationWithLat:userLocation.location.coordinate.latitude Lon:userLocation.location.coordinate.longitude];
//    //显示当前坐标
//    lngLabel.text = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
//    latLabel.text = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
//    [locationService stopUserLocationService];
//    //获取坐标以后，关闭HUD
//    UIApplication *app =[UIApplication sharedApplication];
//    AppDelegate *delegate = app.delegate;
//    [delegate hideHUD];
//}
//
//- (void)didFailToLocateUserWithError:(NSError *)error {
//    //获取坐标异常后，关闭HUD
//    UIApplication *app =[UIApplication sharedApplication];
//    AppDelegate *delegate = app.delegate;
//    [delegate hideHUD];
//    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无法进行定位，请检查您的GPS设置" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alertView show];
//}
#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    // 获取经纬度
//    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
//    NSLog(@"经度:%f",newLocation.coordinate.longitude);
//    [self getSiteWithLocationWithLat:newLocation.coordinate.latitude Lon:newLocation.coordinate.longitude];
//        //显示当前坐标
//        lngLabel.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
//        latLabel.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
//        //获取坐标以后，关闭HUD
//        UIApplication *app =[UIApplication sharedApplication];
//        AppDelegate *delegate = app.delegate;
//        [delegate hideHUD];
//    // 停止位置更新
//    [manager stopUpdatingLocation];
//}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * currLocation = [locations lastObject];
    float longitude = currLocation.coordinate.longitude;
    float latitude = currLocation.coordinate.latitude;
    NSLog(@"纬度:%f",longitude);
    NSLog(@"经度:%f",latitude);
    [self getSiteWithLocationWithLat:latitude Lon:longitude];
    //显示当前坐标
    lngLabel.text = [NSString stringWithFormat:@"%f",longitude];
    latLabel.text = [NSString stringWithFormat:@"%f",latitude];
    //获取坐标以后，关闭HUD
//    UIApplication *app =[UIApplication sharedApplication];
//    AppDelegate *delegate = app.delegate;
//    [delegate hideHUD];
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

//获取附近的站点信息
-(void)getSiteWithLocationWithLat:(float) lat Lon:(float)lon{
    RequestCompleteBlock block = ^(id result) {
        _siteArray = result;
        siteListOri = result;
        [siteTable reloadData];
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getSiteInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] lng:[NSString stringWithFormat:@"%f", lon ] lat:[NSString stringWithFormat:@"%f",lat ]  resNo:nil completeBlock:block loadingView:siteTable showHUD:YES];
}

#pragma mark-----alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0 ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark--- tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //将选择的站点信息保存到本地
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *siteInfoDic = [_siteArray objectAtIndex:indexPath.row];
    [userDefaults setObject:siteInfoDic forKey:@"siteDic"];
    [userDefaults synchronize];
    
    //发送通知，选择站点信息已更改
    [[NSNotificationCenter defaultCenter] postNotificationName:KSiteChanged object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _siteArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"siteCell";
    SiteInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[SiteInfoCell alloc]init];
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [_siteArray objectAtIndex:indexPath.row];
    cell.infoDic = dic;
    
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
