//
//  WodeziyuanViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "WodeziyuanViewController.h"
#import "PowerDataService.h"
#import "DeviceListViewController.h"

@interface WodeziyuanViewController ()

@end

@implementation WodeziyuanViewController {
    BOOL isComplete;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = @"我的资源";
        [self setTitleWithPosition:@"left" title:@"资源巡检"];
    //监听键盘显示事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHandler:) name:UIKeyboardDidShowNotification object:nil];
    //监听键盘隐藏事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideHandler:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:searchBar];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStation) name:@"changeStation" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isComplete = NO;
	// Do any additional setup after loading the view.
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    tapBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,40, ScreenWidth, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-80)];
//    tapBackgroundView.backgroundColor = [UIColor clearColor];
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundTapHandler)];
//    [tapBackgroundView addGestureRecognizer:tapGes];
//    [self.view addSubview:tapBackgroundView];
    
    //搜索栏
    UIView *searchBarContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    searchBarContainer.backgroundColor =  [UIColor colorWithRed:238/255.0 green:246/255.0 blue:249/255.0 alpha:1];
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
//    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 40)];
//    searchBar.backgroundColor = [UIColor clearColor];
//    searchBar.delegate = self;
//
//    for (UIView *view in searchBar.subviews) {
//        // for before iOS7.0
//        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            [view removeFromSuperview];
//        }
//        //修改左边放大镜图标
//        if([view isKindOfClass:NSClassFromString(@"UITextField")]) {
//            UIImage *image = [UIImage imageNamed: @"ic_search.png"];
//            UIImageView *iView = [[UIImageView alloc] initWithImage:image];
//            iView.frame = CGRectMake(0, 0, 25, 25);
//            ((UITextField *)view).leftView = iView;
//        }
//        // for later iOS7.0(include)
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
//            break;
//        }
//    }
//    searchBar.placeholder = @"搜索";
    
    [searchBarContainer addSubview:searchBar];
    
    //站点列表
    siteTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0,45, ScreenWidth, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-85) style:UITableViewStylePlain];
    siteTableView.bounces = NO;
    siteTableView.dataSource = self;
    siteTableView.delegate  = self;
    siteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:siteTableView];
    
    //设备扫描按钮
    UIView *operateView = [[UIView alloc]initWithFrame:CGRectMake(0, siteTableView.bottom, ScreenWidth, 40)];
    operateView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    saomiaoBtn = [[UIGlossyButton alloc]init];
    saomiaoBtn.frame = CGRectMake(5,5,ScreenWidth-10, 30);
    [saomiaoBtn setTitle:@"条码扫描查询设备" forState:UIControlStateNormal];
    [saomiaoBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [saomiaoBtn addTarget:self action:@selector(scanHandler) forControlEvents:UIControlEventTouchUpInside];
    [operateView addSubview:saomiaoBtn];
    [self.view addSubview:operateView];

    
    
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary* siteDic = [userDefaults objectForKey:@"resourceSiteDic"];
//    //如果本地没有站点信息，那么弹出定位视图
//    if( siteDic == nil) {
//        [self popUserRegionData];
//
//    }else {
//        [self getSiteList];
//    }
//    UserRegionViewController *regionCtrl = [[UserRegionViewController alloc]init];
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    regionCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:regionCtrl animated:YES completion:^(void){
//    }];
    //获取地区信息,并将第一个作为选中的地区
//    [self getUserRegionData];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(isComplete == NO ){
        //请求服务器，查看是否有权限访问
        PowerDataService *dataService = [[PowerDataService alloc]init];
        RequestCompleteBlock block = ^(id result) {
            _regionList = (NSArray *)result;
            //如果不为空，将第一个作为默认选择区局
            if(_regionList.count > 0) {
                selectRegionDic = [_regionList objectAtIndex:0];
                [self setCurrentRegion:YES];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您无权访问.." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alertView.tag = 101;
                alertView.delegate = self;
                [alertView show];
            }
        };
        [dataService getUserRegionDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:nil showHUD:YES];

        isComplete = YES;
    }
}

//-(void)setRegionList:(NSArray *)regionList {
//    _regionList = regionList;
//}



//获取用户所能访问的区局信息列表
//-(void)getUserRegionData {
//    //先获取区局列表数据
//    PowerDataService *dataService = [[PowerDataService alloc]init];
//    RequestCompleteBlock block = ^(id result) {
//        regionList = (NSArray *)result;
//        //如果不为空，将第一个作为默认选择区局
//        if(regionList.count > 0) {
//            selectRegionDic = [regionList objectAtIndex:0];
//            [self setCurrentRegion:YES];
//        }
//        
//    };
//    [dataService getUserRegionDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:siteTableView showHUD:NO];
//}

//设置当前区局
-(void)setCurrentRegion:(BOOL)needJump{
    if(selectRegionDic == nil)
        return;
    //设置当前区局
//    UIBarButtonItem *button  = [[UIBarButtonItem alloc] initWithTitle:[selectRegionDic objectForKey:@"REG_NAME"] style:UIBarButtonItemStyleBordered target:self action:@selector(popRegionView)];
//    self.navigationItem.rightBarButtonItem = button;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 80, 20);
//    [btn setImage:[UIImage imageNamed:@"widget_right.png"] forState:UIControlStateNormal];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
//    [btn setTitle:[selectRegionDic objectForKey:@"REG_NAME"] forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [btn addTarget:self action:@selector(popRegionView) forControlEvents:UIControlEventTouchUpInside];
//    [btn.titleLabel setTextColor:[UIColor whiteColor]];
//    
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = buttonItem;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth-120, 0, 120,NAVIGATION_BAR_HEIGHT);
    [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"right_s.png"] scaleToSize:CGSizeMake(20,20)] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10,100, 10,0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 10, 20)];
    [btn setTitle:[selectRegionDic objectForKey:@"REG_NAME"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
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
    
    //清空searchbar
    searchBar.text = @"";
    [self filterSiteList:@"" ];
    [searchBar resignFirstResponder];
    //获取当前区局的站点
    [self getSiteList:needJump];
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

//获取当前区域的站点列表
-(void)getSiteList:(BOOL)needJump {
    if(selectRegionDic == nil)
        return;
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        siteList = (NSArray *)result;
        siteListOri = [[NSMutableArray alloc]initWithArray:result];
        [siteTableView reloadData];
        
        if(needJump==NO)
            return;
        //首选查看本地是否有保存的站点，如果有，直接跳转到该站点下的设备列表界面
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *xunjiansiteDic = [userDefaults objectForKey:@"xunjiansite"];
        if(xunjiansiteDic != nil ) {
            DeviceListViewController *deviceCtrl = [[DeviceListViewController alloc]init];
            deviceCtrl.siteDic = xunjiansiteDic;
            [self.navigationController pushViewController:deviceCtrl animated:YES];
        }
        
    };
    [dataService getUserStationDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] regNum:[selectRegionDic objectForKey:@"REG_NUM"] stationName:@"" stationSubTypeNum:@"" stationAddr:@"" articleNum:@"" stationLevelNum:@"" completeBlock:block loadingView:siteTableView showHUD:YES];
}

-(void)getSiteWithCode:(NSString *)code {
    if(selectRegionDic == nil)
        return;
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        siteList = (NSArray *)result;
        siteListOri = [[NSMutableArray alloc]initWithArray:result];
        [siteTableView reloadData];
        
    };
    [dataService getUserStationDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] regNum:[selectRegionDic objectForKey:@"REG_NUM"] stationName:@"" stationSubTypeNum:@"" stationAddr:@"" articleNum:code stationLevelNum:@"" completeBlock:block loadingView:siteTableView showHUD:YES];
}

//扫描设备
-(void)scanHandler {
    //弹出扫描视图
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.navigationItem.hidesBackButton = YES;
    //非全屏
    reader.wantsFullScreenLayout = NO;
    //隐藏底部按钮
    reader.showsZBarControls = NO;
    
    [self setOverlayPickerView:reader];
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self.navigationController pushViewController:reader animated:YES];
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader
{
    //清除原有控件
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
            
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }
    //画中间的基准线
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    line.backgroundColor = [UIColor greenColor];
    [reader.view addSubview:line];
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:upView];
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    labIntroudction.font = [UIFont systemFontOfSize:14];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [reader.view addSubview:labIntroudction];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:leftView];
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:rightView];
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 120)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:downView];
    //用于取消操作的button
    UIGlossyButton *cancelButton = [[UIGlossyButton alloc]init];
    [cancelButton setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [cancelButton setFrame:CGRectMake(20, 370, 280, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:cancelButton];
}

//取消button方法
- (void)dismissOverlayView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

//关闭键盘
-(void)closeKeyboard {
    [searchBar resignFirstResponder];
}
#pragma mark ---userRegionCtrl delegate
-(void)regionOnSelect:(BaseModalViewController *)ctrl regionDic:(NSDictionary *)regionDic {
    [ctrl disappearWinow];
    selectRegionDic = regionDic;
    [self setCurrentRegion:NO];
}

#pragma mark zbar delegate
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [self.navigationController popViewControllerAnimated:YES];
    [self getSiteWithCode:symbol.data];
}

#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [siteList objectAtIndex:indexPath.row];
    
    //将选择的站点保存到本地，下次打开时能直接定位到该站点的数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:@"xunjiansite"];
    [userDefaults synchronize];
    
    
    DeviceListViewController *deviceCtrl = [[DeviceListViewController alloc]init];
    deviceCtrl.siteDic = dic;
    [self.navigationController pushViewController:deviceCtrl animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [siteList objectAtIndex:indexPath.row];
    CGSize size = [PowerUtils getLabelSizeWithText: [dic objectForKey:@"STATION_NAME"] width:180 font:[UIFont systemFontOfSize:14]];
    return size.height+20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //添加站点名称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 180, 30)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.numberOfLines = 3;
        nameLabel.tag = 100;
        [cell.contentView addSubview:nameLabel];
        
        //添加站点类别
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(220,10, 80, 30)];
        typeLabel.font = [UIFont systemFontOfSize:14];
        typeLabel.numberOfLines = 3;
        typeLabel.tag = 101;
        [cell.contentView addSubview:typeLabel];
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [siteList objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
    nameLabel.text = [dic objectForKey:@"STATION_NAME"];
    
    //设置站点类别
    UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:101];
    typeLabel.text = [dic objectForKey:@"STATION_TYPE_NAME"];
    
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    //重新布局
    CGSize size = [PowerUtils getLabelSizeWithText: [dic objectForKey:@"STATION_NAME"] width:180 font:[UIFont systemFontOfSize:14]];
    nameLabel.frame = CGRectMake(10,10, size.width, size.height);
    typeLabel.frame = CGRectMake(220, 10, 80, size.height);
    seperateView.bottom = size.height+20;
    return cell;
}

//-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return siteList.count;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return siteList.count;
}
//当需要切换站点时，弹出到站点选择视图
-(void)changeStation {
    [self.navigationController popToViewController:self animated:YES];
}


//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //当键盘显示时，重新设置scroller的contentsize;
    siteTableView.frame = CGRectMake(0,45, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-keyboardSize.height-45);
    
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    siteTableView.frame = CGRectMake(0,45, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-85);
}

#pragma mark uisearchbar delegate
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
        siteList = siteListOri;
    }else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"STATION_NAME contains[c] %@", keyword];
        siteList = [siteListOri filteredArrayUsingPredicate:predicate];
    }
    [siteTableView reloadData];
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
////键盘显示事件
//-(void)keyboardShowHandler {
//    [self.view bringSubviewToFront:tapBackgroundView ];
//}
//
////键盘隐藏事件
//-(void)keyboardHideHandler {
//    [self.view sendSubviewToBack:tapBackgroundView];
//}
//
////背景点击
//-(void)tapBackgroundTapHandler {
//    //关闭键盘
//    [searchBar resignFirstResponder];
//}
@end
