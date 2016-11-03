//
//  UnFinishingTaskViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "UnFinishingTaskViewController.h"
#import "PowerDataService.h"
#import "UnFinishTaskCell.h"
@interface UnFinishingTaskViewController ()

@end

@implementation UnFinishingTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"未完成";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initViews];
	// Do any additional setup after loading the view.
}

//初始化子控件
-(void)_initViews {
    _reloading = NO;
    taskList = [[NSMutableArray alloc]init];
    //tableview
    unFinishingTaskTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-120) style:UITableViewStylePlain];
    unFinishingTaskTable.delegate = self;
    unFinishingTaskTable.dataSource = self;
    [unFinishingTaskTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:unFinishingTaskTable];
    
    //refreshHeadView
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - unFinishingTaskTable.bounds.size.height, self.view.frame.size.width, unFinishingTaskTable.bounds.size.height)];
		view.delegate = self;
		[unFinishingTaskTable addSubview:view];
		_refreshHeaderView = view;
		
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
    //添加操作按钮
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-120,ScreenWidth,40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    //全选按钮
    float buttonWidth = (ScreenWidth-30)/2;
    selectAllBtn = [[UIGlossyButton alloc]init];
    selectAllBtn.frame = CGRectMake(5, 5, buttonWidth, 30);
    [selectAllBtn setTitle:@"反选" forState:UIControlStateNormal];
    [selectAllBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [selectAllBtn addTarget:self action:@selector(selectAllHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:selectAllBtn];
    
    //开始维护按钮
    startWeihuBtn = [[UIGlossyButton alloc]init];
    startWeihuBtn.frame = CGRectMake(selectAllBtn.right+20, 5,buttonWidth, 30);
    [startWeihuBtn setTitle:@"开始维护" forState:UIControlStateNormal];
    [startWeihuBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [startWeihuBtn addTarget:self action:@selector(startWeihuHandler) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:startWeihuBtn];
    
    [self.view addSubview:operationView];
}

//获取未完成的任务详情
- (void)getTaskDetail {
    RequestCompleteBlock block = ^(id result) {
        [taskList removeAllObjects];
        for (NSDictionary *item in result) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:item];
            [dic setValue:@"YES" forKey:@"selected"];
            [taskList addObject:dic];
        }
        [unFinishingTaskTable reloadData];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:unFinishingTaskTable];
        
        if(_delegate && [_delegate respondsToSelector:@selector(setUnFinishingTaskAmount:)]) {
            [_delegate setUnFinishingTaskAmount:[NSString stringWithFormat:@"%d",taskList.count]];
        }
        [self judgeBtnStatus];
        
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getTaskDetailInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]  taskId:_taskId subTaskStat:@"0" completeBlock:block loadingView:unFinishingTaskTable showHUD:YES];
}

//全选或者反选
-(void) selectAllHandler:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"反选"]) {
        for (NSDictionary *dic in taskList) {
            [dic setValue:@"NO" forKey:@"selected"];
        }
        [unFinishingTaskTable reloadData];
        [self judgeBtnStatus];
    }else {
        for (NSDictionary *dic in taskList) {
            [dic setValue:@"YES" forKey:@"selected"];
        }
        [unFinishingTaskTable reloadData];
        [self judgeBtnStatus];
    }
}

//判断操作按钮的状态
-(void)judgeBtnStatus {
    int selectedAmount = 0;
    //判断是否有选中的项
    for (NSDictionary *dic in taskList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
            selectedAmount++;
        }
    }
    //selectAllBtn
    if(selectedAmount==[taskList count]) {
        [selectAllBtn setTitle:@"反选" forState:UIControlStateNormal];
    }else {
        [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    
    //startWeihuBtn
    if(selectedAmount == 0 ) {
        [startWeihuBtn setEnabled:NO];
    }
    else {
        [startWeihuBtn setEnabled:YES];
    }
}


//开始维护
-(void)startWeihuHandler {
    //弹出确认视图
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提交数据" message:@"是否开始维护?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    [alertView show];
    
    
    CommitDataViewController *commitDataCtrl = [[CommitDataViewController alloc]init];
    commitDataCtrl.delegate = self;
    commitDataCtrl.isAuto = _isAuto;
    commitDataCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:commitDataCtrl animated:YES completion:nil];
}

#pragma mark --CommitDataDelegate Methods
-(void)submitData:(NSString *)isAuto{
    RequestCompleteBlock block = ^(id result) {
        [self getTaskDetail];
    };
    
    NSMutableString *taskString = [[NSMutableString alloc]init];
    //判断是否有选中的项
    for (NSDictionary *dic in taskList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
            [taskString appendFormat:@"%@/",[dic objectForKey:@"subTaskId"]];
        }
    }
    PowerDataService *service = [[PowerDataService alloc]init];
    [service startProcessTaskWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] subTaskIdList:taskString isAuto:isAuto completeBlock:block loadingView:self.view showHUD:YES];
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
    return [UnFinishTaskCell caculateCellHeight:dic];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UnFinishTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UnFinishTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.delegate = self;
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


#pragma mark ----- cell delegate
//当任务选中状态更改后调用，修改按钮状态
-(void)refreshData {
    [unFinishingTaskTable reloadData];
    [self judgeBtnStatus];
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


#pragma alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //确认
    if(buttonIndex == 1 ) {
        RequestCompleteBlock block = ^(id result) {
        [self getTaskDetail];
        };
        
        NSMutableString *taskString = [[NSMutableString alloc]init];
        //判断是否有选中的项
        for (NSDictionary *dic in taskList) {
            if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
                [taskString appendFormat:@"%@/",[dic objectForKey:@"subTaskId"]];
            }
        }
        PowerDataService *service = [[PowerDataService alloc]init];
        [service startProcessTaskWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] subTaskIdList:taskString isAuto:_isAuto completeBlock:block loadingView:self.view showHUD:YES];
    }
}
@end
