//
//  ZhongdagaojingFilterResultViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-8-1.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "ZhongdagaojingFilterResultViewController.h"
#import "BaseNavigationController.h"
#import "PowerDataService.h"

@interface ZhongdagaojingFilterResultViewController ()

@end

@implementation ZhongdagaojingFilterResultViewController {
    //过滤栏
    UITextField *searchBar;
    UIView *searchBarContainer;
    NSArray *gaojingList;
    NSMutableArray *gaojingOriList;
    UITableView *gaojingTable;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"重大告警"];
        
        
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
    searchBarContainer = [[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 45)];
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
    NSDictionary *dic = [gaojingList objectAtIndex:indexPath.row];
    //    GaojingDetaiViewController *detailCtrl = [[GaojingDetaiViewController alloc]init];
    //    detailCtrl.warningDic = dic;
    //    detailCtrl.hidesBottomBarWhenPushed = YES;
    WarningDetailMainViewController *detailCtrl = [[WarningDetailMainViewController alloc]init];
    detailCtrl.warningDic = dic;
    [detailCtrl setTitleWithPosition:@"center" title:@"重大告警详情"];
    BaseNavigationController *rootController = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController pushViewController:detailCtrl animated:YES];
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
    CGSize positionSize = [PowerUtils getLabelSizeWithText:positionStr width:ScreenWidth-40 font:[UIFont systemFontOfSize:12]];
    return 66+positionSize.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //添加报警title
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-40, 20)];
        titleLabel.tag = 99;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:titleLabel];
        //添加告警内容
        UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 23, ScreenWidth-40, 20)];
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.tag = 103;
        [cell.contentView addSubview:contentLabel];
        //添加报警位置
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,45, ScreenWidth-40, 40)];
        positionLabel.font = [UIFont systemFontOfSize:12];
        positionLabel.numberOfLines = 2;
        positionLabel.tag = 101;
        [cell.contentView addSubview:positionLabel];
        
        //添加报警时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, ScreenWidth-40, 20)];
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
    titleLabel.text = [dic objectForKey:@"DEV_NAME"];
    
    //设置内容
    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:103];
    contentLabel.text = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"POINT_NAME"],[dic objectForKey:@"ALARM_DESCRIPT"]];
    //设置位置
    UILabel *positionLabel = (UILabel *)[cell.contentView viewWithTag:101];
    BOOL isSingle = YES;
    if(_siteList.count > 1) {
        isSingle = NO;
    }
    if(isSingle==YES){
        positionLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"]];
    }else {
        positionLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"]];
    }
    
    //设置报警时间
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:102];
    timeLabel.text = [NSString stringWithFormat:@"告警时间:%@",[dic objectForKey:@"ALARM_TIME"]];
    
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
    contentLabel.frame = CGRectMake(10, titleLabel.bottom, ScreenWidth-40, 20);
    positionLabel.frame = CGRectMake(10, 45, ScreenWidth-40, positionSize.height);
    timeLabel.frame = CGRectMake(10, positionLabel.bottom, ScreenWidth-40, 20);
    seperateView.frame = CGRectMake(0,timeLabel.bottom , ScreenWidth, 0.5);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return gaojingList.count;
}


//根据搜索条件查询告警列表
-(void)searchGaojingWithFilter:(NSDictionary *)dic {
    RequestCompleteBlock block = ^(id result) {
        gaojingList = (NSArray *)result;
        gaojingOriList = [[NSMutableArray alloc]initWithArray:result];
        [gaojingTable reloadData];
        
        
    };
    PowerDataService *dataService = [[PowerDataService alloc]init];
    [dataService getDKCurrentAlarmDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] regNum:[dic objectForKey:@"qujv"] stationNum:@"" stationName:[dic objectForKey:@"jvzhan"] alarmLevelNum:[dic objectForKey:@"gaojingdengji"] devClassNum:[dic objectForKey:@"shebeidalei"] alarmDescript:[dic objectForKey:@"gaojingyuanyin"] wXFullNo:@"" fatalAlarmRuleID:@"" startTime:[dic objectForKey:@"kaishishijian"] stopTime:[dic objectForKey:@"jiesushijian"] completeBlock:block loadingView:gaojingTable showHUD:YES];
}

@end
