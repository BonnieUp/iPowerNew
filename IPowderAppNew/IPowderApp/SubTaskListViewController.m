//
//  SubTaskListViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "SubTaskListViewController.h"
#import "PowerDataService.h"
#import "TaskDetailMainViewController.h"

@interface SubTaskListViewController ()

@end

@implementation SubTaskListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self _initViews];
}


//初始化视图
-(void)_initViews {
    taskTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    [taskTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    taskTableView.bounces = NO;
    [self.view addSubview:taskTableView];
}

-(void)setTypeStr:(NSString *)typeStr {
    _typeStr = typeStr;
    [self setTitleWithPosition:@"center" title:typeStr];
}

#pragma mark------tableview delegate
#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [taskList objectAtIndex:indexPath.row];
    //弹出任务清单信息视图
    TaskDetailMainViewController *taskDetailCtrl = [[TaskDetailMainViewController alloc]init];
    taskDetailCtrl.taskId = [dic objectForKey:@"taskID"];
    taskDetailCtrl.nuName = [dic objectForKey:@"nuName"];
    taskDetailCtrl.isAuto = _isAuto;
    taskDetailCtrl.contentIdentity = [dic objectForKey:@"contentIdentity"];
    [taskDetailCtrl setTitleWithPosition:@"center" title:_detailTaskName];
    [self.navigationController pushViewController:taskDetailCtrl animated:YES];
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

        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [taskList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"nuName"];

    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    return cell;
}

//获取任务
-(void)getTask {
    if(_taskTypeId == nil || _siteId == nil )
        return;
    RequestCompleteBlock block = ^(id result) {
        taskList = (NSArray *)result;
        [taskTableView reloadData];
        [self setTitleWithPosition:@"center" title:[NSString stringWithFormat:@"%@(%i)",_typeStr,taskList.count]];
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getTaskWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]  siteId:_siteId taskTypeId:_taskTypeId taskStat:@"1" resNo:nil startDate:[PowerUtils getFirstDay:@"yyyy-MM-dd"] endDate:[PowerUtils getLastDay:@"yyyy-MM-dd"] completeBlock:block loadingView:self.view showHUD:YES];
}

-(void)setSiteId:(NSString *)siteId {
    if(![_siteId isEqualToString:siteId]) {
        _siteId = siteId;
        [self getTask];
    }
}

-(void)setTaskTypeId:(NSString *)taskTypeId {
    if(![_taskTypeId isEqualToString:taskTypeId]) {
        _taskTypeId = taskTypeId;
        [self getTask];
    }
}

-(void)setIsAuto:(NSString *)isAuto{
    _isAuto = isAuto;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
