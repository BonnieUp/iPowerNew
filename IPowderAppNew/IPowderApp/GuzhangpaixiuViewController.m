//
//  GuzhangpaixiuViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GuzhangpaixiuViewController.h"
#import "PowerDataService.h"
#import "BaseNavigationController.h"
#import "GuzhangMainViewController.h"
#import "RTLabel.h"

@interface GuzhangpaixiuViewController ()

@end

@implementation GuzhangpaixiuViewController {
    UITableView *guzhangTable;
    //过滤栏
    UITextField *searchBar;
    //
    NSArray *guzhangList;
    NSMutableArray *guzhangOriList;
    NSMutableArray *deviceClassList;
    NSMutableArray *guzhangdengjiList;
    BOOL isComplete;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"故障派修";
        [self setTitleWithPosition:@"left" title:@"我的网管"];
        
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
    isComplete = NO;
    // Do any additional setup after loading the view.
    deviceClassList = [[NSMutableArray alloc]init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Resource-Info" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    guzhangdengjiList = [data objectForKey:@"guzhangdengji"];
    //搜索栏
    UIView *searchBarContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    searchBarContainer.backgroundColor = [UIColor colorWithRed:185/255.0 green:217/255.0 blue:233/255.0 alpha:1]	;
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
    
    guzhangTable = [[UITableView alloc]initWithFrame:CGRectMake(0,45, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-85)];
    guzhangTable.bounces = NO;
    guzhangTable.dataSource = self;
    guzhangTable.delegate  = self;
    guzhangTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:guzhangTable];

    
    [self getShebeidaleiForWangguan];
    
    [self getGuzhangListWithRegNum:@"" stationName:@"" devName:@"" devClassNum:@"" faultDescript:@"" faultLevelNum:@"" mendStatusNum:@"3" isAutoMend:@"" startTime:[PowerUtils getLastMonthDay:@"yyyy-MM-dd-HH:mm:ss"] stopTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
//    if(isComplete==NO){
//        [self getGuzhangListWithRegNum:@"" stationName:@"" devName:@"" devClassNum:@"" faultDescript:@"" faultLevelNum:@"" mendStatusNum:@"3" isAutoMend:@"" startTime:[PowerUtils getLastMonthDay:@"yyyy-MM-dd-HH:mm:ss"] stopTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]];
//        isComplete = YES;
//    }
    [self getGuzhangListWithRegNum:@"" stationName:@"" devName:@"" devClassNum:@"" faultDescript:@"" faultLevelNum:@"" mendStatusNum:@"3" isAutoMend:@"" startTime:[PowerUtils getLastMonthDay:@"yyyy-MM-dd-HH:mm:ss"] stopTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]];
}

-(void)getGuzhangListWithRegNum:(NSString *)regNum
                    stationName:(NSString *)stationName
                        devName:(NSString *)devName
                    devClassNum:(NSString *)devClassNum
                  faultDescript:(NSString *)faultDescript
                  faultLevelNum:(NSString *)faultLevelNum
                  mendStatusNum:(NSString *)mendStatusNum
                     isAutoMend:(NSString *)isAutoMend
                      startTime:(NSString *)startTime
                       stopTime:(NSString *)stopTime{
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        guzhangList = (NSArray *)result;
        guzhangOriList = [[NSMutableArray alloc]initWithArray:result];
        [guzhangTable reloadData];
    };
    [dataService getDeviceFaultDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] regNum:regNum stationName:stationName devName:devName devClassNum:devClassNum faultDescript:faultDescript faultLevelNum:faultLevelNum mendStatusNum:mendStatusNum isAutoMend:isAutoMend startTime:startTime stopTime:stopTime completeBlock:block loadingView:guzhangTable showHUD:YES];
}

//过滤siteList
-(void)filterSiteList:(NSString *)keyword {
    
    if([keyword isEqualToString:@""]) {
        guzhangList = guzhangOriList;
    }else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DEV_NAME contains[c] %@", keyword];
        guzhangList = [guzhangOriList filteredArrayUsingPredicate:predicate];
    }
    [guzhangTable reloadData];
}

//关闭键盘
-(void)closeKeyboard {
    [searchBar resignFirstResponder];
}

#pragma mark uisearchbar delegate
-(void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    NSString *keyword;
    if(![textField isEqual:searchBar])
        return;
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

#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [guzhangList objectAtIndex:indexPath.row];
    GuzhangMainViewController *mainCtrl = [[GuzhangMainViewController alloc]init];
    mainCtrl.siteList = _siteList;
    mainCtrl.WXFULLNO = [dic objectForKey:@"WX_FULLNO"];
    mainCtrl.hidesBottomBarWhenPushed = YES;
    BaseNavigationController *rootController = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController pushViewController:mainCtrl animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [guzhangList objectAtIndex:indexPath.row];
    BOOL isSingle = YES;
    if(_siteList.count > 1) {
        isSingle = NO;
    }
    NSString *positionStr;
    if(isSingle == YES){
        positionStr = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"],[dic objectForKey:@"DEV_NAME"]];
    }else {
        positionStr = [NSString stringWithFormat:@"%@-%@-%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"],[dic objectForKey:@"DEV_NAME"]];
    }
    CGSize positionSize = [PowerUtils getLabelSizeWithText:positionStr width:ScreenWidth-70 font:[UIFont systemFontOfSize:12]];
    return 66+positionSize.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //添加报警title
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 20)];
        titleLabel.tag = 99;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:titleLabel];
        //添加告警内容
//        UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(40, 23, ScreenWidth-70, 20)];
//        contentLabel.font = [UIFont systemFontOfSize:12];
//        contentLabel.tag = 103;
//        [cell.contentView addSubview:contentLabel];
        //添加报警位置
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,25, ScreenWidth-20, 40)];
        positionLabel.font = [UIFont systemFontOfSize:12];
        positionLabel.numberOfLines = 2;
        positionLabel.tag = 101;
        [cell.contentView addSubview:positionLabel];
        
        //添加报修时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, ScreenWidth-20, 20)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.tag = 102;
        [cell.contentView addSubview:timeLabel];
        
        //添加故障历史
        RTLabel *historyLabel = [[RTLabel alloc]initWithFrame:CGRectMake(10, 85, ScreenWidth-20, 20)];
        historyLabel.font = [UIFont systemFontOfSize:12];
        historyLabel.tag = 104;
        [cell.contentView addSubview:historyLabel];
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 89, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [guzhangList objectAtIndex:indexPath.row];
    //设置title
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:99];
    titleLabel.text = [dic objectForKey:@"FAULT_DESCRIPT"];

    //设置内容
//    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:103];
//    contentLabel.text = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"POINT_NAME"],[dic objectForKey:@"ALARM_DESCRIPT"]];
    //设置位置
    UILabel *positionLabel = (UILabel *)[cell.contentView viewWithTag:101];
    BOOL isSingle = YES;
    if(_siteList.count > 1) {
        isSingle = NO;
    }
    if(isSingle==YES){
        positionLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"],[dic objectForKey:@"DEV_NAME"]];
    }else{
        positionLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"],[dic objectForKey:@"DEV_NAME"]];
    }

    //设置报警时间
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:102];
    timeLabel.text = [NSString stringWithFormat:@"报修时间:%@",[dic objectForKey:@"REPORT_TIME"]];
    
    //设置故障历时
    RTLabel *historyLabel = (RTLabel *)[cell.contentView viewWithTag:104];
    historyLabel.text = [NSString stringWithFormat:@"故障历时:<b>%@</b>分钟/<font color='#ff0000'>%@</font>小时",[dic objectForKey:@"MEND_FAULTPERIOD"],[dic objectForKey:@"FAULT_MAX_PERIOD"]];
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    
    //重置位置
    CGSize positionSize = [PowerUtils getLabelSizeWithText:positionLabel.text width:ScreenWidth-70 font:positionLabel.font];
    titleLabel.frame = CGRectMake(10, 5, ScreenWidth-20, 20);
//    contentLabel.frame = CGRectMake(40, titleLabel.bottom, ScreenWidth-70, 20);
    positionLabel.frame = CGRectMake(10, titleLabel.bottom, ScreenWidth-20, positionSize.height);
    timeLabel.frame = CGRectMake(10, positionLabel.bottom, ScreenWidth-20, 20);
    historyLabel.frame = CGRectMake(10, timeLabel.bottom,ScreenWidth-20,20);
    seperateView.frame = CGRectMake(0,historyLabel.bottom , ScreenWidth, 0.5);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return guzhangList.count;
}

-(void)popSearchWindow {
    GuzhangpaixiuFilterConditionViewController *conditionCtrl = [[GuzhangpaixiuFilterConditionViewController alloc]init];
    conditionCtrl.siteList = _siteList;
    conditionCtrl.deviceClassList = deviceClassList;
    conditionCtrl.guzhangdengjiList = guzhangdengjiList;
    conditionCtrl.delegate = self;
    [self.navigationController pushViewController:conditionCtrl animated:YES];
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

//获取故障等级列表
//-(void)getGuzhangdengji {
//    RequestCompleteBlock block = ^(id result ) {
//        for (NSDictionary *dic in result) {
//            NSMutableDictionary *itemDic = [[NSMutableDictionary alloc]init];
//            [itemDic setValue:[dic objectForKey:@"DEV_CLASS_NAME"] forKey:@"name"];
//            [itemDic setValue:[dic objectForKey:@"DEV_CLASS_NUM"] forKey:@"value"];
//            [guzhangdengjiList addObject:itemDic];
//        }
//        
//        
//    };
//    PowerDataService *dataService = [[PowerDataService alloc]init];
//    [dataService getDeviceFaultLevelWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]  completeBlock:block loadingView:nil showHUD:NO];
//}

-(void)guzhangpaixiuFilterOnChange:(NSDictionary *)dic {
    [self getGuzhangListWithRegNum:[dic objectForKey:@"qujv"] stationName:[dic objectForKey:@"jvzhan"] devName:[dic objectForKey:@"shebei"] devClassNum:[dic objectForKey:@"shebeidalei"] faultDescript:[dic objectForKey:@"guzhangxianxiang"] faultLevelNum:[dic objectForKey:@"guzhangdengji"] mendStatusNum:@"3" isAutoMend:[dic objectForKey:@"paidanleixing"] startTime:[dic objectForKey:@"kaishishijian"] stopTime:[dic objectForKey:@"jiesushijian"]];
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
