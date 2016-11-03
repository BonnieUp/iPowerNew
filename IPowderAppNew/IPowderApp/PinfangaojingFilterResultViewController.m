//
//  PinfangaojingFilterResultViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-8-1.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "PinfangaojingFilterResultViewController.h"
#import "PowerDataService.h"
#import "RTLabel.h"

@interface PinfangaojingFilterResultViewController ()

@end

@implementation PinfangaojingFilterResultViewController {
    UITableView *gaojingTable;
    //过滤栏
    UITextField *searchBar;
    //
    NSArray *gaojingList;
    NSMutableArray *gaojingOriList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"频繁告警"];
        
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
    //搜索栏
    UIView *searchBarContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    searchBarContainer.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
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
    
    gaojingTable = [[UITableView alloc]initWithFrame:CGRectMake(0,45, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-45)];
    gaojingTable.bounces = NO;
    gaojingTable.dataSource = self;
    gaojingTable.delegate  = self;
    gaojingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:gaojingTable];
}

//获取频繁告警列表
-(void)getPinfangaojingWithregNum:(NSString *)regNum
                      stationName:(NSString *)stationName
                          devName:(NSString *)devName
                        pointName:(NSString *)pointName
                       alarmCount:(NSString *)alarmCount
                        startTime:(NSString *)startTime
                         stopTime:(NSString *)stopTime{
    RequestCompleteBlock block = ^(id result ) {
        gaojingList = (NSArray *)result;
        gaojingOriList = [[NSMutableArray alloc]initWithArray:result];
        [gaojingTable reloadData];

    };
    PowerDataService *dataService = [[PowerDataService alloc]init];
    [dataService getPinfangaojingWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] regNum:regNum stationName:stationName devName:devName pointName:pointName alarmCount:alarmCount startTime:startTime stopTime:stopTime completeBlock:block loadingView:gaojingTable showHUD:YES];
}

//过滤siteList
-(void)filterSiteList:(NSString *)keyword {
    
    if([keyword isEqualToString:@""]) {
        gaojingList = gaojingOriList;
    }else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DEV_NAME contains[c] %@", keyword];
        gaojingList = [gaojingOriList filteredArrayUsingPredicate:predicate];
    }
    [gaojingTable reloadData];
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
    //    NSDictionary *dic = [gaojingList objectAtIndex:indexPath.row];
    //    GaojingDetaiViewController *detailCtrl = [[GaojingDetaiViewController alloc]init];
    //    detailCtrl.warningDic = dic;
    //    detailCtrl.hidesBottomBarWhenPushed = YES;
    //    [detailCtrl setTitleWithPosition:@"center" title:@"频繁告警详情"];
    //    BaseNavigationController *rootController = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    //    [rootController pushViewController:detailCtrl animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [gaojingList objectAtIndex:indexPath.row];
    BOOL isSingle = YES;
    if(_siteList.count > 1) {
        isSingle = NO;
    }
    NSString *positionStr;
    if(isSingle == YES){
        positionStr = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"]];
    }else {
        positionStr = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"]];
    }
    CGSize positionSize = [PowerUtils getLabelSizeWithText:positionStr width:ScreenWidth-10 font:[UIFont systemFontOfSize:12]];
    return 66+positionSize.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //添加报警title
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-10, 20)];
        titleLabel.tag = 99;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:titleLabel];
        //        //添加告警内容
        //        UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(40, 23, ScreenWidth-70, 20)];
        //        contentLabel.font = [UIFont systemFontOfSize:12];
        //        contentLabel.tag = 103;
        //        [cell.contentView addSubview:contentLabel];
        //添加报警位置
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,25, ScreenWidth-10, 40)];
        positionLabel.font = [UIFont systemFontOfSize:12];
        positionLabel.numberOfLines = 2;
        positionLabel.tag = 101;
        [cell.contentView addSubview:positionLabel];
        
        //添加报警时间
        RTLabel *timeLabel = [[RTLabel alloc]initWithFrame:CGRectMake(10, 85, ScreenWidth-10, 40)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.tag = 102;
        [cell.contentView addSubview:timeLabel];
        
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 89, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [gaojingList objectAtIndex:indexPath.row];
    //设置title
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:99];
    titleLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"DEV_NAME"],[dic objectForKey:@"POINT_NAME"]];
    //设置内容
    //    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:103];
    //    contentLabel.text = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"POINT_NAME"],[dic objectForKey:@"ALARM_DESCRIPT"]];
    //设置位置
    UILabel *positionLabel = (UILabel *)[cell.contentView viewWithTag:101];
    BOOL isSingle = YES;
    if(_siteList.count > 1) {
        isSingle = NO;
    }
    if(isSingle == YES){
        positionLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"]];
    }else {
        positionLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"]];
    }
    
    //设置报警时间
    RTLabel *timeLabel = (RTLabel *)[cell.contentView viewWithTag:102];
    timeLabel.text = [NSString stringWithFormat:@"时间段:%@ 至 %@   发生<b>%@</b>次",[dic objectForKey:@"ALARM_BEGIN_TIME"],[dic objectForKey:@"ALARM_END_TIME"],[dic objectForKey:@"ALARM_COUNT"]];
    
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    
    //重置位置
    CGSize positionSize = [PowerUtils getLabelSizeWithText:positionLabel.text width:ScreenWidth-40 font:positionLabel.font];
    titleLabel.frame = CGRectMake(10, 5, ScreenWidth-40, 20);
    //    contentLabel.frame = CGRectMake(40, titleLabel.bottom, ScreenWidth-70, 20);
    positionLabel.frame = CGRectMake(10, titleLabel.bottom, ScreenWidth-40, positionSize.height);
    timeLabel.frame = CGRectMake(10, positionLabel.bottom, ScreenWidth-40, 40);
    seperateView.frame = CGRectMake(0,timeLabel.bottom , ScreenWidth, 0.5);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return gaojingList.count;
}

-(NSString *)getWarningIcon:(NSDictionary *)dic {
    NSString *returnUrl;
    //    NSString *head;
    NSString *isMain = [dic objectForKey:@"IS_DEV_MAINT_ALARM"];//是否为工单报警0/1
    NSString *alarmLevel = [dic objectForKey:@"ALARM_LEVEL_NUM"];//告警等级0：严重 1：一般 2：重大
    NSString *isConf = [dic objectForKey:@"CC_CONF_STATE"];//告警确认
    NSString *status = [dic objectForKey:@"MEND_STATUS_NUM"];//故障状态
    
    if([isMain isEqualToString:@"1"]){
        returnUrl = [NSString stringWithFormat:@"%@_%@_%@.png",@"b",alarmLevel,isConf];
    }else if([self validateStatus:status]){
        returnUrl = [NSString stringWithFormat:@"%@_%@_%@.png",@"s",alarmLevel,status];
    }else{
        returnUrl = [NSString stringWithFormat:@"%@_%@_%@.png",@"a",alarmLevel,isConf];
    }
    
    //    if([isMain isEqualToString:@"0"]) {
    //        head = @"a";
    //    }else {
    //        head = @"b";
    //    }
    //    return [NSString stringWithFormat:@"%@_%@_%@.ico",head,[dic objectForKey:@"ALARM_LEVEL_NUM"],[dic objectForKey:@"CC_CONF_STATE"]];
    return returnUrl;
}

-(BOOL)validateStatus:(NSString *)status{
    if(status == nil || [status isEqualToString:@""] ){
        return NO;
    }else{
        return YES;
    }
}

-(void)searchGaojingWithFilter:(NSDictionary *)dic {
    [self getPinfangaojingWithregNum:[dic objectForKey:@"qujv"] stationName:@"" devName:[dic objectForKey:@"shebei"] pointName:[dic objectForKey:@"tongdao"] alarmCount:[dic objectForKey:@"cishu"] startTime:[dic objectForKey:@"kaishishijian"] stopTime:[dic objectForKey:@"jiesushijian"]];
}

@end
