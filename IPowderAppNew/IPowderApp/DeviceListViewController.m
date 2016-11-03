//
//  DeviceListViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "DeviceListViewController.h"
#import "PowerDataService.h"
#import "DeviceDetailEditMainViewController.h"

@interface DeviceListViewController ()

@end

@implementation DeviceListViewController {
}

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
    
    deviceList = [[NSMutableArray alloc]init];
    //tableview
    deviceTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-40) style:UITableViewStylePlain];
    deviceTable.delegate = self;
    deviceTable.dataSource  =self;
    deviceTable.bounces = NO;
    deviceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:deviceTable];
    
    //添加操作栏
    //添加操作按钮
    float buttonWidth = (ScreenWidth-30)/3;
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(0,deviceTable.bottom,ScreenWidth,40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    //全选按钮
    selectAllBtn = [[UIGlossyButton alloc]init];
    selectAllBtn.frame = CGRectMake(5, 5, buttonWidth, 30);
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [selectAllBtn addTarget:self action:@selector(selectAllHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:selectAllBtn];
    
    //筛选按钮
    filterBtn = [[UIGlossyButton alloc]init];
    filterBtn.frame = CGRectMake(selectAllBtn.right+10, 5, buttonWidth, 30);
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [filterBtn addTarget:self action:@selector(popFilterHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:filterBtn];
    
    //加入巡检按钮
    xunjianBtn = [[UIGlossyButton alloc]init];
    xunjianBtn.frame = CGRectMake(filterBtn.right+10, 5, buttonWidth, 30);
    [xunjianBtn setTitle:@"加入巡检" forState:UIControlStateNormal];
    [xunjianBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [xunjianBtn addTarget:self action:@selector(jiaruxunjianHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:xunjianBtn];
    
    [self.view addSubview:operationView];
    

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self mergeDeviceInfo];
    [deviceTable reloadData];
}

//将本地存储的设备信息和服务器获取的设备信息进行比对
-(void)mergeDeviceInfo {
    if(deviceList.count == 0 )
        return;
    NSString *stationNum = [_siteDic objectForKey:@"STATION_NUM"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *siteDeviceList = [userDefaults objectForKey:stationNum];
    for (NSDictionary *deviceDic in deviceList ) {
        BOOL hasThisDevice = NO;
        for (NSDictionary *localDeviceDic in siteDeviceList) {
            //如果本地有保存该设备
            if([[localDeviceDic objectForKey:@"DEV_NUM"] isEqualToString:[deviceDic objectForKey:@"DEV_NUM"]]) {
                //不显示checkbox
                [deviceDic setValue:@"NO" forKey:@"enabled"];
                hasThisDevice = YES;
                break;
            }
        }
        if(hasThisDevice == NO ) {
            //显示checkbox
            [deviceDic setValue:@"YES" forKey:@"enabled"];
            //将checkbox设置为未选中
            [deviceDic setValue:@"NO" forKey:@"selected"];
        }
    }
}

#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *deviceDic = [deviceList objectAtIndex:indexPath.row];
    
    if([[deviceDic objectForKey:@"canEdit"] isEqualToString:@"YES"]){
        DeviceDetailEditMainViewController *editDeviceCtrl = [[DeviceDetailEditMainViewController alloc]init];
        editDeviceCtrl.deviceDic = deviceDic;
        editDeviceCtrl.deviceStatusList = deviceStatusList;
        editDeviceCtrl.roomList = roomList;
        editDeviceCtrl.suoshuxitongList = suoshuxitongList;
        editDeviceCtrl.stationNum = [_siteDic objectForKey:@"STATION_NUM"];;
        [self.navigationController pushViewController:editDeviceCtrl animated:YES];
    }else{
        DeviceDetailMainViewController *deviceDetailCtrl = [[DeviceDetailMainViewController alloc]init];
        deviceDetailCtrl.deviceStatusList = deviceStatusList;
        deviceDetailCtrl.deviceDic = deviceDic;
        [self.navigationController pushViewController:deviceDetailCtrl animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [deviceList objectAtIndex:indexPath.row];
    return [DeviceTableViewCell caculateCellHeight:dic];
//    float hei=10;
//    CGSize nameSize = [PowerUtils getLabelSizeWithText:[dic objectForKey:@"DEV_NAME"] width:230 font:[UIFont systemFontOfSize:15]];
//    hei+=nameSize.height;
//    
//    CGSize typeSize = [PowerUtils getLabelSizeWithText:[dic objectForKey:@"DEV_TYPE_NAME"] width:230 font:[UIFont systemFontOfSize:13]];
//    hei+=typeSize.height;
//    
//    CGSize roomSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"所属房间:%@",[dic objectForKey:@"ROOM_NAME"]] width:230 font:[UIFont systemFontOfSize:13]];
//    hei+=roomSize.height;
//    
//    CGSize zichanSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"实物编号:%@",[dic objectForKey:@"ARTICLE_NUM"]] width:230 font:[UIFont systemFontOfSize:13]];
//    hei+=zichanSize.height;
//    
//    CGSize shiwuSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"实物编号:%@",[dic objectForKey:@"ASSETS_NUM"]] width:230 font:[UIFont systemFontOfSize:13]];
//    hei+=shiwuSize.height;
//    
//    CGSize touchanSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"投产日期:%@",[dic objectForKey:@"START_USE_DATE"]] width:230 font:[UIFont systemFontOfSize:13]];
//    hei+=touchanSize.height;
//    return hei;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return deviceList.count;
}

- (DeviceTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[DeviceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.delegate = self;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        
//        //设备名称label
//        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5,230, 30)];
//        nameLabel.numberOfLines = 3;
//        nameLabel.font = [UIFont systemFontOfSize:15];
//        nameLabel.tag = 100;
//        [cell.contentView addSubview:nameLabel];
//        
//        //设备类型label
//        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, nameLabel.bottom, 230, 30)];
//        typeLabel.numberOfLines = 3;
//        typeLabel.font = [UIFont systemFontOfSize:13];
//        typeLabel.tag = 101;
//        [cell.contentView addSubview:typeLabel];
//        
//        //所属房间label
//        UILabel *roomLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, typeLabel.bottom, 230, 30)];
//        roomLabel.numberOfLines = 3;
//        roomLabel.font = [UIFont systemFontOfSize:13];
//        roomLabel.tag = 102;
//        [cell.contentView addSubview:roomLabel];
//        
//        //资产编号label
//        UILabel *zichanLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, roomLabel.bottom, 230, 30)];
//        zichanLabel.numberOfLines = 3;
//        zichanLabel.font = [UIFont systemFontOfSize:13];
//        zichanLabel.tag = 103;
//        [cell.contentView addSubview:zichanLabel];
//        
//        //实物编号label
//        UILabel *shiwuLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, zichanLabel.bottom, 230, 30)];
//        shiwuLabel.numberOfLines = 3;
//        shiwuLabel.font = [UIFont systemFontOfSize:13];
//        shiwuLabel.tag = 104;
//        [cell.contentView addSubview:shiwuLabel];
//        
//        //投产日期label
//        UILabel *touchanLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, shiwuLabel.bottom, 190, 30)];
//        touchanLabel.numberOfLines = 3;
//        touchanLabel.font = [UIFont systemFontOfSize:13];
//        touchanLabel.tag = 105;
//        [cell.contentView addSubview:touchanLabel];
//        
//        //是否选中btn
//        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        selectBtn.frame = CGRectMake(5,15, 30,30 );
//        selectBtn.tag = 106;
//        [cell.contentView addSubview:selectBtn];
//        
//        //添加分割线
//        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
//        seperateView.tag  = 200;
//        seperateView.alpha = 0.8;
//        seperateView.backgroundColor = [UIColor grayColor];
//        [cell.contentView addSubview:seperateView];
        
    }
    //避免出现重叠现象
    else {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    NSDictionary *dic = [deviceList objectAtIndex:indexPath.row];
    cell.dic = dic;
//    //设置名称
//    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:100];
//    nameLabel.text = [dic objectForKey:@"DEV_NAME"];
//    
//    //设备类型label
//    UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:101];
//    typeLabel.text = [dic objectForKey:@"DEV_TYPE_NAME"];
//    
//    //所属房间
//    UILabel *roomLabel = (UILabel *)[cell.contentView viewWithTag:102];
//    roomLabel.text = [NSString stringWithFormat:@"所属房间:%@",[dic objectForKey:@"ROOM_NAME"]];
//    
//    //资产编号
//    UILabel *zichanLabel = (UILabel *)[cell.contentView viewWithTag:103];
//    zichanLabel.text = [NSString stringWithFormat:@"资产编号:%@",[dic objectForKey:@"ARTICLE_NUM"]];
//    
//    //实物编号
//    UILabel *shiwuLabel = (UILabel *)[cell.contentView viewWithTag:104];
//    shiwuLabel.text = [NSString stringWithFormat:@"实物编号:%@",[dic objectForKey:@"ASSETS_NUM"]];
//    
//    //投产日期
//    UILabel *touchanLabel = (UILabel *)[cell.contentView viewWithTag:105];
//    touchanLabel.text = [NSString stringWithFormat:@"投产日期:%@",[dic objectForKey:@"START_USE_DATE"]];
//    
//    UIButton *selectBtn = (UIButton *)[cell.contentView viewWithTag:106];
//    //设置checkbox样式
//    if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
//        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_normal.png"] forState:UIControlStateNormal];
//    }
//    else {
//        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_disable.png"] forState:UIControlStateNormal];
//    }
//    [selectBtn addTarget:self action:@selector(onSelectChangeHandler) forControlEvents:UIControlEventTouchUpInside];
//    //如果没有数据，隐藏分割线
//    UIView *seperateView = [cell.contentView viewWithTag:200];
//    if(dic == nil) {
//        [seperateView setHidden:YES];
//    }else {
//        [seperateView setHidden:NO];
//    }
//    
//    //重置位置
//    CGSize nameSize = [PowerUtils getLabelSizeWithText:nameLabel.text width:230 font:[UIFont systemFontOfSize:15]];
//    nameLabel.frame = CGRectMake(40, 5, 230, nameSize.height);
//
//    CGSize typeSize = [PowerUtils getLabelSizeWithText:typeLabel.text width:230 font:[UIFont systemFontOfSize:13]];
//    typeLabel.frame = CGRectMake(40,nameLabel.bottom, 230, typeSize.height);
//    
//    CGSize roomSize = [PowerUtils getLabelSizeWithText:roomLabel.text width:230 font:[UIFont systemFontOfSize:13]];
//    roomLabel.frame = CGRectMake(40,typeLabel.bottom, 230, roomSize.height);
//
//    CGSize zichanSize = [PowerUtils getLabelSizeWithText:zichanLabel.text width:230 font:[UIFont systemFontOfSize:13]];
//    zichanLabel.frame = CGRectMake(40,roomLabel.bottom, 230, zichanSize.height);
//    
//    CGSize shiwuSize = [PowerUtils getLabelSizeWithText:shiwuLabel.text width:230 font:[UIFont systemFontOfSize:13]];
//    shiwuLabel.frame = CGRectMake(40,zichanLabel.bottom, 230, shiwuSize.height);
//    
//    CGSize touchanSize = [PowerUtils getLabelSizeWithText:touchanLabel.text width:230 font:[UIFont systemFontOfSize:13]];
//    touchanLabel.frame = CGRectMake(40, shiwuLabel.bottom, 230,touchanSize.height);
//    
//    seperateView.frame = CGRectMake(0, touchanLabel.bottom+4, ScreenWidth, 1);
//    
//    selectBtn.frame = CGRectMake(5, (seperateView.bottom-30)/2, 30, 30);
    
    return cell;
}


#pragma mark ----- devicecell delegate
-(void)refreshData {
    [self judgeBtnStatus];
}


#pragma mark ----- choosefilterway delegate
-(void)chooseShowAllButton {
    [self getDeviceWithStationNum:[_siteDic objectForKey:@"STATION_NUM"] roomNum:@"" sysNum:@"" articleNum:@"" assetsNum:@"" devMaker:@"" devClassNum:@"" devSubClassNum:@""];
}

//通过手动模式筛选
-(void)chooseManualFilter {
    FilterConditionListViewController *filterConditionCtrl = [[FilterConditionListViewController alloc]init];
    filterConditionCtrl.stationNum = [_siteDic objectForKey:@"STATION_NUM"];
    filterConditionCtrl.conditionView.delegate = self;
    [self.navigationController pushViewController:filterConditionCtrl animated:YES];
}

//通过扫描模式筛选
-(void)chooseSaomiaoFilter {
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
    [self getDeviceWithStationNum:[_siteDic objectForKey:@"STATION_NUM"] roomNum:@"" sysNum:@"" articleNum:symbol.data assetsNum:@"" devMaker:@"" devClassNum:@"" devSubClassNum:@""];
}

-(void)setSiteDic:(NSDictionary *)siteDic {
    if(![_siteDic isEqual:siteDic]) {
        _siteDic = siteDic;
        [self loadData];
        //获取本地存取的已经加入巡检的设备
        NSString *stationNum = [_siteDic objectForKey:@"STATION_NUM"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *siteDeviceList = [userDefaults objectForKey:stationNum];
        //如果没有，创建一个
        if(siteDeviceList == nil) {
            siteDeviceList = [[NSArray alloc]init];
            [userDefaults setObject:siteDeviceList forKey:stationNum];
            [userDefaults synchronize];
        }
        
        [self getDeviceWithStationNum:[_siteDic objectForKey:@"STATION_NUM"] roomNum:@"" sysNum:@"" articleNum:@"" assetsNum:@"" devMaker:@"" devClassNum:@"" devSubClassNum:@""];
        
        
        
        [self getDeviceStatus];
        [self getRoomList];
        [self getSuoshuxitongList];
    }
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
    
    [btn setTitle:[_siteDic objectForKey:@"STATION_NAME"] forState:UIControlStateNormal];
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

#pragma  mark ---conditionview delegate
-(void)submitConditionWithRoomNum:(NSString *)roomNum sysNum:(NSString *)sysNum articleNum:(NSString *)articleNum assetsNum:(NSString *)assetsNum devMaker:(NSString *)devMaker devClassNum:(NSString *)devClassNum devSubClassNum:(NSString *)devSubClassNum {
    if(roomNum==nil)
        roomNum = @"";
    if(sysNum==nil)
        sysNum = @"";
    if(articleNum==nil)
        articleNum = @"";
    if(assetsNum==nil)
        assetsNum = @"";
    if(devMaker==nil)
        devMaker=@"";
    if(devClassNum==nil)
        devClassNum=@"";
    if(devSubClassNum==nil)
        devSubClassNum = @"";
    
    [self getDeviceWithStationNum:[_siteDic objectForKey:@"STATION_NUM"] roomNum:roomNum sysNum:sysNum articleNum:articleNum assetsNum:assetsNum devMaker:devMaker devClassNum:devClassNum devSubClassNum:devSubClassNum];
    
    [self.navigationController popToViewController:self animated:YES];
}

//全选或者反选
-(void) selectAllHandler:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"反选"]) {
        for (NSDictionary *dic in deviceList) {
            [dic setValue:@"NO" forKey:@"selected"];
        }
        [deviceTable reloadData];
        [self judgeBtnStatus];
    }else {
        for (NSDictionary *dic in deviceList) {
            [dic setValue:@"YES" forKey:@"selected"];
        }
        [deviceTable reloadData];
        [self judgeBtnStatus];
    }
}

//判断操作按钮的状态
-(void)judgeBtnStatus {
    int selectedAmount = 0;
    //判断是否有选中的项
    for (NSDictionary *dic in deviceList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
            selectedAmount++;
        }
    }
    //selectAllBtn
    if(selectedAmount==[deviceList count]) {
        [selectAllBtn setTitle:@"反选" forState:UIControlStateNormal];
    }else {
        [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    
    //xunjianBtn
//    if(selectedAmount == 0 ) {
//        [xunjianBtn setEnabled:NO];
//    }
//    else {
//        [xunjianBtn setEnabled:YES];
//    }
}

//弹出筛选视图
-(void)popFilterHandler:(UIGlossyButton *)sender {
    FilterWayViewController *filterWayCtrl = [[FilterWayViewController alloc]init];
    filterWayCtrl.delegate = self;
    filterWayCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:filterWayCtrl animated:YES completion:nil];
}

//加入巡检
-(void)jiaruxunjianHandler:(UIGlossyButton *)sender {
    //获取所有被选中的设备
    NSMutableArray *selectDeviceList = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *deviceDic in deviceList) {
        if([[deviceDic objectForKey:@"selected"] isEqualToString:@"YES"]
            &&[[deviceDic objectForKey:@"enabled"] isEqualToString:@"YES"]) {
            [deviceDic setValue:@"NO" forKey:@"enabled"];
            [selectDeviceList addObject:deviceDic];
        }
    }
    
    //将加入巡检的设备保存进本地配置文件
    NSString *stationNum = [_siteDic objectForKey:@"STATION_NUM"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *localSiteDeviceList = [userDefaults objectForKey:stationNum];
    NSMutableArray *newLocalSiteDeviceList = [NSMutableArray arrayWithArray:localSiteDeviceList];
    for (NSDictionary *deviceDic in selectDeviceList ) {
        NSMutableDictionary *localDeviceDic = [NSMutableDictionary dictionaryWithDictionary:deviceDic];
        //是否已经检查
        [localDeviceDic setValue:@"NO" forKey:@"checked"];
        //是否可以勾选
        [localDeviceDic setValue:@"NO" forKey:@"selected"];
        //是否显示勾选框
        [localDeviceDic setValue:@"YES" forKey:@"enabled"];
        //是否已修改
        [localDeviceDic setValue:@"NO" forKey:@"modifyed"];
        [newLocalSiteDeviceList addObject:localDeviceDic];
    }
    [userDefaults setObject:newLocalSiteDeviceList forKey:stationNum];
    [userDefaults synchronize];
    
    
    //初始化巡检ctrl
    XunjianDeviceMainViewController *xunjianCtrl = [[XunjianDeviceMainViewController alloc]init];
    xunjianCtrl.stationDic = _siteDic;
    xunjianCtrl.deviceStatusList = deviceStatusList;
    xunjianCtrl.roomList = roomList;
    xunjianCtrl.suoshuxitongList = suoshuxitongList;
    [self.navigationController pushViewController:xunjianCtrl animated:YES];
}

//获取设备列表
-(void)getDeviceWithStationNum:(NSString *)stationNum
                       roomNum:(NSString *)roomNum
                        sysNum:(NSString *)sysNum
                    articleNum:(NSString *)articleNum
                     assetsNum:(NSString *)assetsNum
                      devMaker:(NSString *)devMaker
                   devClassNum:(NSString *)devClassNum
                devSubClassNum:(NSString *)devSubClassNum
{
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        [deviceList removeAllObjects];
        if(result == nil ) {
            [deviceTable reloadData];
            return;
        }
            
        for (NSDictionary *item in result) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:item];
            [dic setValue:@"NO" forKey:@"selected"];
            [dic setValue:@"YES" forKey:@"enabled"];
            [dic setValue:@"YES" forKey:@"canEdit"];
            [deviceList addObject:dic];
        }
        [self mergeDeviceInfo];
        [deviceTable reloadData];
        
    };
    [dataService getUserDeviceDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] stationNum:stationNum roomNum:roomNum sysNum:sysNum articleNum:articleNum assetsNum:assetsNum devMaker:devMaker devClassNum:devClassNum devSubClassNum:devSubClassNum completeBlock:block loadingView:deviceTable showHUD:YES];
}

////当checkbox状态切换触发
//-(void)onSelectChangeHandler:(NSInteger)index {
//    
//}
//获取所属系统列表
-(void)getSuoshuxitongList {
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        suoshuxitongList = (NSArray *)result;
        
    };
    [dataService getUserPowerSystemWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] stationNum:[_siteDic objectForKey:@"STATION_NUM"]  sysClassNum:@"" completeBlock:block loadingView:nil showHUD:YES];
}

//获取设备状态列表
-(void)getDeviceStatus{
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        deviceStatusList = (NSArray *)result;
    };
    [dataService getDeviceStatusInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:nil showHUD:NO];

}

//获取指定站点下的机房数据
-(void)getRoomList {
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        roomList = (NSArray *)result;
    };
    [dataService GetUserRoomDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] stationNum:[_siteDic objectForKey:@"STATION_NUM"] roomName:@"" completeBlock:block loadingView:nil showHUD:NO];
}

@end
