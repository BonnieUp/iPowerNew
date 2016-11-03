//
//  DaikaishiViewController.m
//  i动力
//
//  Created by 王敏 on 16/1/6.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "DaikaishiViewController.h"
#import "PowerDataService.h"

@implementation DaikaishiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"待开始";
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
    checkDataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40) style:UITableViewStylePlain];
    checkDataTableView.delegate = self;
    checkDataTableView.dataSource = self;
    checkDataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:checkDataTableView];
    
    //refreshHeadView
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - checkDataTableView.bounds.size.height, self.view.frame.size.width, checkDataTableView.bounds.size.height)];
        view.delegate = self;
        [checkDataTableView addSubview:view];
        _refreshHeaderView = view;
        
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}

//获取数据
-(void)getCheckData{
    RequestCompleteBlock block = ^(id result) {
        checkDataList = (NSArray *)result;
        [checkDataTableView reloadData];
        
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:checkDataTableView];
    };
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    [dataService getPrCheckPlanDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] checkStatusNum:@"2" completeBlock:block loadingView:checkDataTableView showHUD:YES];
    
}

#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //delegate响应弹出二级任务列表
    if(_delegate && [_delegate respondsToSelector:@selector(popDaikaishiDetailViewController:titleLabel:)]) {
        NSDictionary *checkDataDic = [checkDataList objectAtIndex:indexPath.row];
        [_delegate popDaikaishiDetailViewController:[checkDataDic objectForKey:@"PLAN_NUM"] titleLabel:[checkDataDic objectForKey:@"PLAN_NAME"]];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return checkDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //添加内容label
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 280, 25)];
        titleLabel.tag = 100;
        [titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [cell.contentView addSubview:titleLabel];
        //时间label
        UILabel *startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 150, 25)];
        startTimeLabel.tag = 101;
        [startTimeLabel setFont:[UIFont systemFontOfSize:11]];
        startTimeLabel.textColor = [UIColor colorWithRed:49/255.0 green:167/255.0 blue:233/255.0 alpha:1];
        [cell.contentView addSubview:startTimeLabel];
        
        //结束时间label
        UILabel *endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 25, 150, 25)];
        endTimeLabel.tag = 102;
        [endTimeLabel setFont:[UIFont systemFontOfSize:11]];
        endTimeLabel.textColor = [UIColor colorWithRed:49/255.0 green:167/255.0 blue:233/255.0 alpha:1];
        endTimeLabel.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:endTimeLabel];
        
        //添加数量label
        UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-30,10, 25, 25)];
        amountLabel.tag = 103;
        amountLabel.textAlignment = UITextAlignmentRight;
        [amountLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [cell.contentView addSubview:amountLabel];
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
        
    }
    NSDictionary *dic = [checkDataList objectAtIndex:indexPath.row];
    //设置title
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:100];
    titleLabel.text = [dic objectForKey:@"PLAN_NAME"];
    //设置开始时间
    UILabel *timeStartLabel = (UILabel *)[cell.contentView viewWithTag:101];
    timeStartLabel.text = [NSString stringWithFormat:@"计划开始日期:%@",[dic objectForKey:@"START_TIME"]];
    //设置结束时间
    UILabel *endStartLabel = (UILabel *)[cell.contentView viewWithTag:102];
    endStartLabel.text = [NSString stringWithFormat:@"计划完成日期:%@",[dic objectForKey:@"STOP_TIME"]];
    //设置数量
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:103];
    label.text = [dic objectForKey:@"TOTAL_COUNT"];
    
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
    [self getCheckData];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    return _reloading;
}

@end
