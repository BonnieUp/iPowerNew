//
//  WeichaDeviceListViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "WeichaDeviceListViewController.h"
#import "BaseNavigationController.h"
@interface WeichaDeviceListViewController () {
    UITableView *weichaTable;
    UIGlossyButton *selectAllBtn;
    UIGlossyButton *removeBtn;
    UIGlossyButton *saomiaoBtn;
    NSMutableArray *weichaDeviceList;
}

@end

@implementation WeichaDeviceListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"未查";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    weichaDeviceList = [[NSMutableArray alloc]init];
    
    weichaTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80) style:UITableViewStylePlain];
    weichaTable.delegate = self;
    weichaTable.dataSource = self;
    weichaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    weichaTable.bounces = NO;
    [self.view addSubview:weichaTable];
    
    
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80, ScreenWidth, 40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    float btnWidth = (ScreenWidth-30)/3;
    selectAllBtn = [[UIGlossyButton alloc]init];
    selectAllBtn.frame = CGRectMake(5, 5, btnWidth, 30);
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [selectAllBtn addTarget:self action:@selector(selectAllHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:selectAllBtn];
    
    removeBtn = [[UIGlossyButton alloc]init];
    removeBtn.frame = CGRectMake(selectAllBtn.right+10, 5, btnWidth, 30);
    [removeBtn setTitle:@"移除" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeAllHandler:) forControlEvents:UIControlEventTouchUpInside];
    [removeBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    removeBtn.enabled = NO;
    [operationView addSubview:removeBtn];
    
    saomiaoBtn = [[UIGlossyButton alloc]init];
    saomiaoBtn.frame = CGRectMake(removeBtn.right+10,5, btnWidth, 30);
    [saomiaoBtn setTitle:@"条形码扫描设备" forState:UIControlStateNormal];
    [saomiaoBtn addTarget:self action:@selector(saomiaoHandler) forControlEvents:UIControlEventTouchUpInside];
    [saomiaoBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [operationView addSubview:saomiaoBtn];
    
    [self.view addSubview:operationView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];  
}


//全选或者反选
-(void) selectAllHandler:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"反选"]) {
        for (NSDictionary *dic in weichaDeviceList) {
            [dic setValue:@"NO" forKey:@"selected"];
        }
        [weichaTable reloadData];
        [self judgeBtnStatus];
    }else {
        for (NSMutableDictionary *dic in weichaDeviceList) {
            [dic setValue:@"YES" forKey:@"selected"];
        }
        [weichaTable reloadData];
        [self judgeBtnStatus];
    }
}

//判断操作按钮的状态
-(void)judgeBtnStatus {
    int selectedAmount = 0;
    //判断是否有选中的项
    for (NSDictionary *dic in weichaDeviceList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
            selectedAmount++;
        }
    }
    //selectAllBtn
    if(selectedAmount==[weichaDeviceList count]) {
        [selectAllBtn setTitle:@"反选" forState:UIControlStateNormal];
    }else {
        [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    
    if(selectedAmount == 0 ) {
        [removeBtn setEnabled:NO];
    }
    else {
        [removeBtn setEnabled:YES];
    }
}
//弹出扫描窗口
-(void)saomiaoHandler {
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
    BaseNavigationController *rootNavCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootNavCtrl pushViewController:reader animated:YES];
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
    BaseNavigationController *rootNavCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootNavCtrl popViewControllerAnimated:YES];
}

//移除选中的cell
-(void)removeAllHandler:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *localDeviceList = [userDefaults objectForKey:_stationNum];
    NSMutableArray *newLocalDeviceList = [NSMutableArray arrayWithArray:localDeviceList];
    for (NSDictionary *dic in weichaDeviceList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"NO"]) {
            continue;
        }
        for(NSDictionary *localDic in newLocalDeviceList ) {
            if([[localDic objectForKey:@"checked"] isEqualToString:@"NO"] &&
                [[localDic objectForKey:@"DEV_NUM"] isEqualToString:[dic objectForKey:@"DEV_NUM"]]) {
                [newLocalDeviceList removeObject:localDic];
                break;
            }
        }
    }
    
    [userDefaults setObject:newLocalDeviceList forKey:_stationNum];
    [userDefaults synchronize];
    [self getWeichaDeviceList];
}

-(void)setStationNum:(NSString *)stationNum {
    if(![_stationNum isEqualToString:stationNum] ) {
        _stationNum = stationNum;
    }
}

//获取本地存储的位差的设备列表
-(void)getWeichaDeviceList {
    if(_stationNum == nil )
        return;
    [weichaDeviceList removeAllObjects];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *localDeviceList = [userDefaults objectForKey:_stationNum];
    for (NSDictionary *dic in localDeviceList) {
        if([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [weichaDeviceList addObject:newDic];
        }
    }
    
    [weichaTable reloadData];
    
    if(_delegate && [_delegate respondsToSelector:@selector(setWeichaDeviceAmount:)]) {
    
        [_delegate setWeichaDeviceAmount:[NSString stringWithFormat:@"%i",weichaDeviceList.count]];
    }
    
    if(weichaDeviceList.count == 0 ) {
        UIView *noDataView = [weichaTable viewWithTag:10000];
        if(noDataView == nil ) {
            noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,100,50)];
            noDataView.backgroundColor = [UIColor clearColor];
            noDataView.tag = 10000;
            noDataView.center = CGPointMake(weichaTable.width/2,weichaTable.height/2);
            UILabel *noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
            noDataLabel.textAlignment = NSTextAlignmentCenter;
            noDataLabel.text = @"暂无数据";
            noDataLabel.backgroundColor = [UIColor clearColor];
            
            [noDataView addSubview:noDataLabel];
            [weichaTable addSubview:noDataView];
        }
        [weichaTable bringSubviewToFront:noDataView];
    }else {
        UIView *noDataView = [weichaTable viewWithTag:10000];
        if(noDataView!=nil){
            [noDataView removeFromSuperview];
        }
    }
}

//将扫描的设备和未查列表里的设备匹配
-(void)matchDevice:(NSString *)devNum {
    for (NSDictionary *dic in weichaDeviceList ) {
        if([[dic objectForKey:@"DEV_NUM"] isEqualToString:devNum]) {
            [weichaDeviceList removeAllObjects];
            [weichaDeviceList addObject:dic];
            [weichaTable reloadData];
            return;
        }
    }
    //如果没有找到，提示
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"没有匹配到该设备" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
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
    [self dismissOverlayView:nil];
    [self matchDevice:symbol.data];
    
}

#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [weichaDeviceList objectAtIndex:indexPath.row];
    if(_delegate && [_delegate respondsToSelector:@selector(popEditDeivceController:)]) {
        [_delegate popEditDeivceController:dic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [weichaDeviceList objectAtIndex:indexPath.row];
    return [WeichaDeviceTableViewCell caculateCellHeight:dic];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return weichaDeviceList.count;
}

- (WeichaDeviceTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    WeichaDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[WeichaDeviceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.delegate = self;
    }
    //避免出现重叠现象
    else {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    NSDictionary *dic = [weichaDeviceList objectAtIndex:indexPath.row];
    cell.dic = dic;
    return cell;
}

#pragma mark----deivce cell delegate
-(void)refreshData {
    [self judgeBtnStatus];
}

@end
