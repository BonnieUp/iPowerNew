//
//  MyTaskViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//----------------------------
//我的任务视图
//----------------------------
#import "MyTaskViewController.h"
#import "PowerDataService.h"
#import "SubTaskListViewController.h"
@interface MyTaskViewController ()

@end

@implementation MyTaskViewController{
    NSString *isAuto;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的任务";
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
    taskTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80) style:UITableViewStylePlain];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:taskTableView];
    
    //refreshHeadView
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - taskTableView.bounds.size.height, self.view.frame.size.width, taskTableView.bounds.size.height)];
		view.delegate = self;
		[taskTableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

//获取任务
-(void)getTask {
    isAuto = @"0";
    RequestCompleteBlock block = ^(id result) {
        taskList = (NSArray *)result;
        [taskTableView reloadData];
        
        if(_delegate && [_delegate respondsToSelector:@selector(setMyTaskAmount:)]) {
            [_delegate setMyTaskAmount:[NSString stringWithFormat:@"%d",taskList.count ]];
        }
        
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:taskTableView];
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getTaskAmountBySiteWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] taskStat:@"1" siteId:_siteId resNo:nil taskKind:nil taskScope:@"1" startDate:[PowerUtils getFirstDay:@"yyyy-MM-dd"] endDate:[PowerUtils getLastDay:@"yyyy-MM-dd"] completeBlock:block loadingView:taskTableView showHUD:YES];
}

-(void)getTaskWithResNo:(NSString *)resNo {
    isAuto = @"1";
    RequestCompleteBlock block = ^(id result) {
        taskList = (NSArray *)result;
        [taskTableView reloadData];
        
        
        if(_delegate && [_delegate respondsToSelector:@selector(setMyTaskAmount:)]) {
            [_delegate setMyTaskAmount:[NSString stringWithFormat:@"%d",taskList.count ]];
        }
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getTaskAmountBySiteWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] taskStat:@"1" siteId:_siteId resNo:resNo taskKind:nil taskScope:@"1" startDate:[PowerUtils getFirstDay:@"yyyy-MM-dd"] endDate:[PowerUtils getLastDay:@"yyyy-MM-dd"] completeBlock:block loadingView:taskTableView showHUD:YES];
}

-(void)setSiteId:(NSString *)siteId {
    if(![_siteId isEqualToString:siteId]) {
        _siteId = siteId;
        [self getTask];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //delegate响应弹出二级任务列表
    if(_delegate && [_delegate respondsToSelector:@selector(popSubTaskListWith:taskTypeId:taskName:taskAmount: isAuto:)]) {
        NSDictionary *taskDic = [taskList objectAtIndex:indexPath.row];
        [_delegate popSubTaskListWith:_siteId taskTypeId:[taskDic objectForKey:@"taskTypeId"] taskName:[taskDic objectForKey:@"taskTypeName"] taskAmount:[taskDic objectForKey:@"taskAmount"] isAuto:isAuto];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 2;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //添加数量label
        UILabel *taskAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 5, 60, 30)];
        taskAmountLabel.tag = 100;
        [cell.contentView addSubview:taskAmountLabel];
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
        
    }
    NSDictionary *dic = [taskList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"taskTypeName"];
    //设置数量
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = [dic objectForKey:@"taskAmount"];
    
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    return cell;
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
	[self getTask];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    return _reloading;
}

@end
