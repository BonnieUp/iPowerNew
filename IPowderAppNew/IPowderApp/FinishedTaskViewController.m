//
//  FinishedTaskViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "FinishedTaskViewController.h"
#import "PowerDataService.h"
#import "FinishedTaskCell.h"
@interface FinishedTaskViewController ()

@end

@implementation FinishedTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"已完成";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self _initViews];
}

//初始化子控件
-(void)_initViews {
    _reloading = NO;
    
    //tableview
    finishingTaskTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80) style:UITableViewStylePlain];
    finishingTaskTable.delegate = self;
    finishingTaskTable.dataSource = self;
    [finishingTaskTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:finishingTaskTable];
    
    //refreshHeadView
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - finishingTaskTable.bounds.size.height, self.view.frame.size.width, finishingTaskTable.bounds.size.height)];
		view.delegate = self;
		[finishingTaskTable addSubview:view];
		_refreshHeaderView = view;
		
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
}

//获取未完成的任务详情
- (void)getTaskDetail {
    RequestCompleteBlock block = ^(id result) {
        taskList = (NSArray *)result;
        [finishingTaskTable reloadData];
        
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:finishingTaskTable];
        
        if(_delegate && [_delegate respondsToSelector:@selector(setFinishedTaskAmount:)]) {
            [_delegate setFinishedTaskAmount:[NSString stringWithFormat:@"%d",taskList.count]];
        }
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getTaskDetailInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]  taskId:_taskId subTaskStat:@"2" completeBlock:block loadingView:finishingTaskTable showHUD:YES];
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
	[self getTaskDetail];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    return _reloading;
}


#pragma mark --------tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [taskList objectAtIndex:indexPath.row];
    return [FinishedTaskCell caculateCellHeight:dic];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    FinishedTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[FinishedTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    //避免出现重叠现象
    else {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }

    NSDictionary *dic = [taskList objectAtIndex:indexPath.row];
    cell.taskInfoDic = dic;
    return cell;
}

-(void)setTaskId:(NSString *)taskId {
    if(![_taskId isEqualToString:taskId]) {
        _taskId = taskId;
        [self getTaskDetail];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
