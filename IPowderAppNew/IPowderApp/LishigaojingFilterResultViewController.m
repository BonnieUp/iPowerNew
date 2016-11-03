//
//  LishigaojingFilterResultViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-8-1.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "LishigaojingFilterResultViewController.h"
#import "GaojingDetaiViewController.h"
#import "PowerDataService.h"
#import "BaseNavigationController.h"

@interface LishigaojingFilterResultViewController ()

@end

@implementation LishigaojingFilterResultViewController {
    UITableView *gaojingTable;
    //过滤栏
    UITextField *searchBar;
    //
    NSArray *gaojingList;
    NSMutableArray *gaojingOriList;
    NSInteger currentIndex;
    NSMutableArray *gongdanList;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    
    NSDictionary *searchDic;
    //是否正在加载数据
    BOOL isloading;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"历史告警"];
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
    currentIndex = 1;
    gaojingOriList = [[NSMutableArray alloc]init];
    gongdanList = [[NSMutableArray alloc]initWithObjects:@"非工单告警",@"是工单告警", nil];
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
    gaojingTable.dataSource = self;
    gaojingTable.delegate  = self;
    gaojingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:gaojingTable];
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(gaojingTable.contentSize.height, gaojingTable.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              gaojingTable.frame.size.width,
                                              gaojingTable.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         gaojingTable.frame.size.width, gaojingTable.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [gaojingTable addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)goToNextPage {
    currentIndex++;
    if(searchDic==nil) {
        [self getLishigaojingWithRegNum:@"" StationNum:@"" StationName:@"" AlarmLevelNum:@"" DevClassNum:@"" AlarmDescript:@"" WX_FullNo:@"" pageIndex:[NSString stringWithFormat:@"%i",currentIndex] StartTime:@"" StopTime:@"" showHUD:NO];
    }else {
        [self getLishigaojingWithRegNum:[searchDic objectForKey:@"qujv"] StationNum:@"" StationName:[searchDic objectForKey:@"jvzhan"] AlarmLevelNum:[searchDic objectForKey:@"gaojingdengji"] DevClassNum:[searchDic objectForKey:@"shebeidalei"] AlarmDescript:[searchDic objectForKey:@"gaojingyuanyin"] WX_FullNo:@"" pageIndex:[NSString stringWithFormat:@"%i",currentIndex] StartTime:[searchDic objectForKey:@"kaishishijian"] StopTime:[searchDic objectForKey:@"jiesushijian"] showHUD:NO];
    }
    
}

//获取历史告警数据
-(void)getLishigaojingWithRegNum:(NSString *)RegNum
                      StationNum:(NSString *)StationNum
                     StationName:(NSString *)StationName
                   AlarmLevelNum:(NSString *)AlarmLevelNum
                     DevClassNum:(NSString *)DevClassNum
                   AlarmDescript:(NSString *)AlarmDescript
                       WX_FullNo:(NSString *)WX_FullNo
                       pageIndex:(NSString *)pageIndex
                       StartTime:(NSString *)StartTime
                        StopTime:(NSString *)StopTime
                         showHUD:(BOOL)showHUD{
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        [gaojingOriList addObjectsFromArray:[result objectForKey:@"detailList"]];
        gaojingList = gaojingOriList;
        [gaojingTable reloadData];
        [self refreshEnding];
        
        //清空搜索栏
        searchBar.text = @"";
        [self closeKeyboard];
    };
    [dataService getHistoryAlarmDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] regNum:RegNum stationNum:StationNum stationName:StationName alarmLevelNum:AlarmLevelNum devClassNum:DevClassNum alarmDescript:AlarmDescript wXFullNo:WX_FullNo pageIndex:pageIndex startTime:StartTime stopTime:StopTime completeBlock:block loadingView:gaojingTable showHUD:showHUD];
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

//加载数据完毕
-(void)refreshEnding {
    isloading = NO;
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:gaojingTable];
    }
    [gaojingTable reloadData];
    [self setFooterView];
    
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
    GaojingDetaiViewController *detailCtrl = [[GaojingDetaiViewController alloc]init];
    detailCtrl.warningDic = dic;
    detailCtrl.hidesBottomBarWhenPushed = YES;
    //    WarningDetailMainViewController *detailCtrl = [[WarningDetailMainViewController alloc]init];
    //    detailCtrl.warningDic = dic;
    [detailCtrl setTitleWithPosition:@"center" title:@"历时告警详情"];
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
    return 86+positionSize.height;
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
        
        //添加回复时间
        UILabel *huifuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, ScreenWidth-40, 20)];
        huifuLabel.font = [UIFont systemFontOfSize:12];
        huifuLabel.tag = 104;
        [cell.contentView addSubview:huifuLabel];
        //添加报警级别
        UILabel *jibieLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 85, 80, 20)];
        jibieLabel.font = [UIFont systemFontOfSize:12];
        jibieLabel.tag = 110;
        [cell.contentView addSubview:jibieLabel];
        
        //添加是否工单告警
        UILabel *gongdanLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 105, 80, 20)];
        gongdanLabel.font = [UIFont systemFontOfSize:12];
        gongdanLabel.tag = 111;
        [cell.contentView addSubview:gongdanLabel];
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
    if(isSingle == YES){
        positionLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"]];
    }else {
        positionLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STATION_NAME"],[dic objectForKey:@"ROOM_NAME"]];
    }
    
    //设置报警时间
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:102];
    timeLabel.text = [NSString stringWithFormat:@"告警时间:%@",[dic objectForKey:@"ALARM_TIME"]];
    //设置回复时间
    UILabel *huifuLabel = (UILabel *)[cell.contentView viewWithTag:104];
    huifuLabel.text = [NSString stringWithFormat:@"恢复时间:%@",[dic objectForKey:@"ALARM_CLEAR_TIME"]];
    
    //告警级别
    UILabel *jibieLabel = (UILabel *)[cell.contentView viewWithTag:110];
    jibieLabel.text = [dic objectForKey:@"ALARM_LEVEL_NAME"];
    
    //是否工单告警
    UILabel *gongdanLabel = (UILabel *)[cell.contentView viewWithTag:111];
    gongdanLabel.text = [gongdanList objectAtIndex:[[dic objectForKey:@"IS_DEV_MAINT_ALARM"] integerValue]];
    
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
    positionLabel.frame = CGRectMake(10, 45, ScreenWidth-70, positionSize.height);
    timeLabel.frame = CGRectMake(10, positionLabel.bottom, ScreenWidth-40, 20);
    huifuLabel.frame = CGRectMake(10, timeLabel.bottom, ScreenWidth-40, 20);
    jibieLabel.frame = CGRectMake(220, timeLabel.top, 80, 20);
    gongdanLabel.frame = CGRectMake(220, huifuLabel.top, 80, 20);
    seperateView.frame = CGRectMake(0,huifuLabel.bottom , ScreenWidth, 0.5);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return gaojingList.count;
}

#pragma mark scrollerView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark egorefresh delegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos {
    [self performSelector:@selector(goToNextPage) withObject:nil afterDelay:0.5];
}
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    return isloading;
}

-(void)searchGaojingWithFilter:(NSDictionary *)dic {
    currentIndex = 1;
    [gaojingOriList removeAllObjects];
    searchDic = dic;
    [self getLishigaojingWithRegNum:[dic objectForKey:@"qujv"] StationNum:@"" StationName:[dic objectForKey:@"jvzhan"] AlarmLevelNum:[dic objectForKey:@"gaojingdengji"] DevClassNum:[dic objectForKey:@"shebeidalei"] AlarmDescript:[dic objectForKey:@"gaojingyuanyin"] WX_FullNo:@"" pageIndex:[NSString stringWithFormat:@"%i",currentIndex] StartTime:[dic objectForKey:@"kaishishijian"] StopTime:[dic objectForKey:@"jiesushijian"] showHUD:YES];
}
@end
