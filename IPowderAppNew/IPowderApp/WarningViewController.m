//
//  WarningViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "WarningViewController.h"
#import "PowerDataService.h"
#import "WarningDetailMainViewController.h"
@interface WarningViewController ()

@end

@implementation WarningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"告警";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initViews];
    
	// Do any additional setup after loading the view.
}


//初始化视图
-(void)_initViews {
    _reloading = NO;
    
    warningTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    warningTableView.delegate = self;
    warningTableView.dataSource = self;
    warningTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:warningTableView];
    
    //refreshHeadView
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - warningTableView.bounds.size.height, self.view.frame.size.width, warningTableView.bounds.size.height)];
		view.delegate = self;
		[warningTableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}


//获取告警列表数据
-(void)getWarningData {
    RequestCompleteBlock block = ^(id result) {
        warningList = (NSArray *)result;
        [warningTableView reloadData];
        
        if(_delegate && [_delegate respondsToSelector:@selector(setWarningTaskAmount:)]) {
            [_delegate setWarningTaskAmount:[NSString stringWithFormat:@"%d",warningList.count ]];
        }
        
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:warningTableView];
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getAlarmListWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]   siteId:_siteId startDate:[PowerUtils getFirstDay:@"yyyy-MM-dd-HH:mm:ss"] endDate:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] alarmType:@"1" completeBlock:block loadingView:warningTableView showHUD:NO];
}

#pragma mark ------ tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //delegate响应弹出二级任务列表
    if(_delegate && [_delegate respondsToSelector:@selector(popWarningDetailWithDic:)]) {
        NSDictionary *dic = [warningList objectAtIndex:indexPath.row];
        [_delegate popWarningDetailWithDic:dic];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return warningList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //添加icon
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 35, 20, 20)];
        iconImage.tag = 100;
        [cell.contentView addSubview:iconImage];
        //添加报警title
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, ScreenWidth-70, 20)];
        titleLabel.tag = 99;
        titleLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:titleLabel];
        //添加报警位置
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,25, ScreenWidth-70, 20)];
        positionLabel.font = [UIFont systemFontOfSize:12];
        positionLabel.numberOfLines = 2;
        positionLabel.tag = 101;
        [cell.contentView addSubview:positionLabel];
        //添加告警设备类别
        UILabel *deviceLabel =[[UILabel alloc]initWithFrame:CGRectMake(40, 45, ScreenWidth-70, 20)];
        deviceLabel.font = [UIFont systemFontOfSize:12];
        deviceLabel.tag = 103;
        [cell.contentView addSubview:deviceLabel];
        //添加报警时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 65, ScreenWidth-70, 20)];
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
    NSDictionary *dic = [warningList objectAtIndex:indexPath.row];
    //设置title
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:99];
    titleLabel.text = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"POINT_NAME"],[dic objectForKey:@"ALARM_DESCRIPT"]];
    //设置icon
    UIImageView *iconImage = (UIImageView *)[cell.contentView viewWithTag:100];
    iconImage.image = [UIImage imageNamed:[self getWarningIcon:dic]];
    //设置报警位置
    UILabel *positionLabel = (UILabel *)[cell.contentView viewWithTag:101];
    positionLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"ROOM_NAME"],[dic objectForKey:@"DEV_NAME"]];
    //设置设备类别
    UILabel *deviceLabel = (UILabel *)[cell.contentView viewWithTag:103];
    deviceLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"DEV_CLASS_NAME"]];
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
    return cell;
}


-(void)setSiteId:(NSString *)siteId {
    if(![_siteId isEqualToString:siteId]) {
        _siteId = siteId;
        [self getWarningData];
    }
}

#pragma mark -UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark ----- EGORefreshHeadView delegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos {
    _reloading = YES;
	[self getWarningData];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    return _reloading;
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
@end
