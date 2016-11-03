//
//  ProcessingTaskViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "ProcessingTaskViewController.h"
#import "PowerDataService.h"
#import "ProcessingTaskCell.h"
#import "EditFilterCell.h"

@interface ProcessingTaskViewController ()

@end

@implementation ProcessingTaskViewController{
    EditFilterCell *backupcell;
    EditFilterCell *rongliangCell;
    EditFilterCell *dianzuCell;
    UIView *operationView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"进行中";
        //监听键盘显示事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowHandler:) name:UIKeyboardDidShowNotification object:nil];
        //监听键盘隐藏事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideHandler:) name:UIKeyboardWillHideNotification object:nil];
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
    taskList = [[NSMutableArray alloc]init];
    //tableview
    processingTaskTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-160) style:UITableViewStylePlain];
    processingTaskTable.delegate = self;
    processingTaskTable.dataSource = self;
    [processingTaskTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:processingTaskTable];
    
    //refreshHeadView
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - processingTaskTable.bounds.size.height, self.view.frame.size.width, processingTaskTable.bounds.size.height)];
		view.delegate = self;
		[processingTaskTable addSubview:view];
		_refreshHeaderView = view;
		
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //添加操作按钮
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-120,ScreenWidth,40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    //全选按钮
    float buttonWidth = (ScreenWidth-30)/3;
    selectAllBtn = [[UIGlossyButton alloc]init];
    selectAllBtn.frame = CGRectMake(5, 5, buttonWidth, 30);
    [selectAllBtn setTitle:@"反选" forState:UIControlStateNormal];
    [selectAllBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [selectAllBtn addTarget:self action:@selector(selectAllHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:selectAllBtn];
    
    //是否完工全选按钮
    selectAllFinishBtn = [[UIGlossyButton alloc]init];
    selectAllFinishBtn.frame = CGRectMake(selectAllBtn.right+10, 5, buttonWidth, 30);
    [selectAllFinishBtn setTitle:@"反选(完工)" forState:UIControlStateNormal];
    [selectAllFinishBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [selectAllFinishBtn addTarget:self action:@selector(selectAllFinishHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:selectAllFinishBtn];
    
    //开始维护按钮
    submitBtn = [[UIGlossyButton alloc]init];
    submitBtn.frame = CGRectMake(selectAllFinishBtn.right+10, 5,buttonWidth, 30);
    [submitBtn setTitle:@"提交维护数据" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitBtn addTarget:self action:@selector(submitTaskDataHandler) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:submitBtn];
    
    [self.view addSubview:operationView];
    
    backupcell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, operationView.top-40, ScreenWidth, 40) required:NO labelTitle:@"备注" oriValue:nil type:EDITCELL_INPUT];
    [self.view addSubview:backupcell];
    
    rongliangCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, backupcell.top-40, ScreenWidth, 40) required:NO labelTitle:@"剩余容量" oriValue:nil type:EDITCELL_INPUT_NUM];
    [rongliangCell setTailString:@"%"];
    [self.view addSubview:rongliangCell];
    
    dianzuCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, backupcell.top-40, ScreenWidth, 40) required:NO labelTitle:@"电阻值" oriValue:nil type:EDITCELL_INPUT_NUM];
    [dianzuCell setTailString:@"欧姆"];
    [self.view addSubview:dianzuCell];

    //添加tap事件
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(hideKeyboard) ];
    [self.view addGestureRecognizer:tapGes];
}

//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    //当键盘显示时，重新设置frame
    processingTaskTable.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-160-keyboardSize.height);
    operationView.frame = CGRectMake(0,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-120-keyboardSize.height,ScreenWidth,40);
    backupcell.frame = CGRectMake(0, operationView.top-40, ScreenWidth, 40);
    rongliangCell.frame = CGRectMake(0, backupcell.top-40, ScreenWidth, 40);
    dianzuCell.frame = CGRectMake(0, backupcell.top-40, ScreenWidth, 40);
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    processingTaskTable.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-160);
    operationView.frame = CGRectMake(0,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-120,ScreenWidth,40);
    backupcell.frame = CGRectMake(0, operationView.top-40, ScreenWidth, 40);
    rongliangCell.frame = CGRectMake(0, backupcell.top-40, ScreenWidth, 40);
    dianzuCell.frame = CGRectMake(0, backupcell.top-40, ScreenWidth, 40);
}

-(void)hideKeyboard {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//获取未完成的任务详情
- (void)getTaskDetail {
    RequestCompleteBlock block = ^(id result) {
        [taskList removeAllObjects];
        for (NSDictionary *item in result) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:item];
            [dic setValue:@"YES" forKey:@"selected"];
            [dic setValue:@"NO" forKey:@"isFinished"];
            [taskList addObject:dic];
        }
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:processingTaskTable];
        
        if(_delegate && [_delegate respondsToSelector:@selector(setProcessingTaskAmount:)]) {
            [_delegate setProcessingTaskAmount:[NSString stringWithFormat:@"%d",taskList.count]];
        }
        [processingTaskTable reloadData];
        [self judgeBtnStatus];
        [self getAttachPropertyStatus];
        
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getTaskDetailInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]  taskId:_taskId subTaskStat:@"1" completeBlock:block loadingView:processingTaskTable showHUD:YES];
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
    return [ProcessingTaskCell caculateCellHeight:dic];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return taskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    ProcessingTaskCell *cell = (ProcessingTaskCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil) {
        cell = [[ProcessingTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
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


#pragma processTaskDelegate
-(void)refreshData {
    [self judgeBtnStatus];
}
    
//全选或者反选
-(void) selectAllHandler:(UIButton *)sender{
    if([sender.titleLabel.text isEqualToString:@"反选"]) {
        for (NSDictionary *dic in taskList) {
            [dic setValue:@"NO" forKey:@"selected"];
            [dic setValue:@"NO" forKey:@"isFinished"];
        }
        [processingTaskTable reloadData];
        [self judgeBtnStatus];
    }else {
        for (NSDictionary *dic in taskList) {
            [dic setValue:@"YES" forKey:@"selected"];
        }
        [processingTaskTable reloadData];
        [self judgeBtnStatus];
    }
}

//完工全选或者反选
-(void)selectAllFinishHandler:(UIButton *)sender {
    if([sender.titleLabel.text isEqualToString:@"反选(完工)"]) {
        for (NSDictionary *dic in taskList) {
            [dic setValue:@"NO" forKey:@"isFinished"];
        }
        [processingTaskTable reloadData];
        [self judgeBtnStatus];
    }else {
        for (NSDictionary *dic in taskList) {
            [dic setValue:@"YES" forKey:@"selected"];
            [dic setValue:@"YES" forKey:@"isFinished"];
        }
        [processingTaskTable reloadData];
        [self judgeBtnStatus];
    }
}

//判断操作按钮的状态
-(void)judgeBtnStatus {
    int selectedAmount = 0;
    int finishSelectedAmount = 0 ;
    //判断是否有选中的项
    for (NSDictionary *dic in taskList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
            selectedAmount++;
        }
        
        if([[dic objectForKey:@"isFinished"] isEqualToString:@"YES"]) {
            finishSelectedAmount++;
        }
    }
    //selectAllBtn
    if(selectedAmount==[taskList count]) {
        [selectAllBtn setTitle:@"反选" forState:UIControlStateNormal];
    }else {
        [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    
    //finishSelectBtn
    if(finishSelectedAmount == [taskList count]) {
        [selectAllFinishBtn setTitle:@"反选(完工)" forState:UIControlStateNormal];
    }else {
        [selectAllFinishBtn setTitle:@"全选(完工)" forState:UIControlStateNormal];
    }
    
    //startWeihuBtn
    if(selectedAmount == 0 ) {
        [submitBtn setEnabled:NO];
    }
    else {
        [submitBtn setEnabled:YES];
    }
}


//提交维护数据
-(void)submitTaskDataHandler {
    [self hideKeyboard];
    BOOL allFinish = YES;
    BOOL hasFinish = NO;
    //判断是否需要必填
    for (NSDictionary *dic in taskList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
            //判断是否已完工
            if(![[dic objectForKey:@"isFinished"] isEqualToString:@"YES"]) {
                allFinish = NO;
                break;
            }
        }
    }
    //判断是否有已完工的项
    for (NSDictionary *dic in taskList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
            //判断是否已完工
            if([[dic objectForKey:@"isFinished"] isEqualToString:@"YES"]) {
                hasFinish = YES;
                break;
            }
        }
    }
    if(allFinish == YES ) {
        if([_contentIdentity isEqualToString:@"1"]){
            if([[[rongliangCell getCurrentDic] objectForKey:@"value"]isEqualToString:@""] || [[rongliangCell getCurrentDic] objectForKey:@"value"]==nil){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误!" message:@"电池容量不能为空!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                return;
            }
            NSString *rongliangS = [[rongliangCell getCurrentDic] objectForKey:@"value"];
            if(![rongliangS isEqualToString:@"0"]){
                float ronglinagF = [rongliangS floatValue];
                if(ronglinagF == 0){
                    [rongliangCell setCurrentDic:nil];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误!" message:@"电池容量只能为数字!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    return;
                }else if(ronglinagF>100){
                    [rongliangCell setCurrentDic:nil];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误!" message:@"电池容量范围为0-100!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    return;
                }
            }
        }else if([_contentIdentity isEqualToString:@"2"]){
            if([[[dianzuCell getCurrentDic] objectForKey:@"value"] isEqualToString:@""] || [[dianzuCell getCurrentDic] objectForKey:@"value"] ==nil){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误!" message:@"电阻值不能为空!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                return;
            }
            NSString *dianzuS = [[dianzuCell getCurrentDic] objectForKey:@"value"];
            if(![dianzuS isEqualToString:@"0"]){
                float dianzuF = [dianzuS floatValue];
                if(dianzuF == 0){
                    [dianzuCell setCurrentDic:nil];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误!" message:@"电阻值只能为数字!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    return;
                }
            }
        }
    }
    //弹出确认视图
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提交数据" message:@"是否结束维护?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    [alertView show];
    ProcessCommitDataViewController *commitDataCtrl = [[ProcessCommitDataViewController alloc]init];
    commitDataCtrl.delegate = self;
    commitDataCtrl.hasFinish = hasFinish;
    commitDataCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:commitDataCtrl animated:YES completion:nil];
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

#pragma mark----processingCommitView delegate
-(void)submitData:(NSString *)flowNO{
    RequestCompleteBlock block = ^(id result) {
        [self getTaskDetail];
    };
    
    NSMutableString *taskString = [[NSMutableString alloc]init];
    NSMutableString *isFinishString = [[NSMutableString alloc]init];
    //判断是否有选中的项
    for (NSDictionary *dic in taskList) {
        if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
            [taskString appendFormat:@"%@/",[dic objectForKey:@"subTaskId"]];
            
            //判断是否已完工
            if([[dic objectForKey:@"isFinished"] isEqualToString:@"YES"]) {
                [isFinishString appendFormat:@"%@/",@"1"];
            }else {
                [isFinishString appendFormat:@"%@/",@"0"];
            }
        }
        
    }
    NSString *remark = [[backupcell getCurrentDic] objectForKey:@"value"];
    NSString *rongliang = [[rongliangCell getCurrentDic] objectForKey:@"value"];
    NSString *dianzu = [[dianzuCell getCurrentDic]objectForKey:@"value"];
    
    NSString *taskContent;
    if([_contentIdentity isEqualToString:@"0"]){
        taskContent = @"";
    }else if([_contentIdentity isEqualToString:@"1"]){
        taskContent = rongliang;
    }else if([_contentIdentity isEqualToString:@"2"]){
        taskContent = dianzu;
    }
    if(remark == nil)
        remark = @"";
    PowerDataService *service = [[PowerDataService alloc]init];
    [service stopProcessTaskWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] subTaskId:taskString isFinished:isFinishString remark:remark taskContent:taskContent faultNO:flowNO completeBlock:block loadingView:self.view showHUD:YES];
    [backupcell setCurrentDic:nil];
    [rongliangCell setCurrentDic:nil];
    [dianzuCell setCurrentDic:nil];
}

#pragma alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //确认
    if(buttonIndex == 1 ) {
        RequestCompleteBlock block = ^(id result) {
            [self getTaskDetail];
        };
        
        NSMutableString *taskString = [[NSMutableString alloc]init];
        NSMutableString *isFinishString = [[NSMutableString alloc]init];
        //判断是否有选中的项
        for (NSDictionary *dic in taskList) {
            if([[dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
                [taskString appendFormat:@"%@/",[dic objectForKey:@"subTaskId"]];
                
                //判断是否已完工
                if([[dic objectForKey:@"isFinished"] isEqualToString:@"YES"]) {
                    [isFinishString appendFormat:@"%@/",@"1"];
                }else {
                    [isFinishString appendFormat:@"%@/",@"0"];
                }
            }
            
        }
        NSString *remark = [[backupcell getCurrentDic] objectForKey:@"value"];
        NSString *rongliang = [[rongliangCell getCurrentDic] objectForKey:@"value"];
        NSString *dianzu = [[dianzuCell getCurrentDic]objectForKey:@"value"];
        
        NSString *taskContent;
        if([_contentIdentity isEqualToString:@"0"]){
            taskContent = @"";
        }else if([_contentIdentity isEqualToString:@"1"]){
            taskContent = rongliang;
        }else if([_contentIdentity isEqualToString:@"2"]){
            taskContent = dianzu;
        }
        if(remark == nil)
            remark = @"";
        PowerDataService *service = [[PowerDataService alloc]init];
        [service stopProcessTaskWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] subTaskId:taskString isFinished:isFinishString remark:remark taskContent:taskContent faultNO:nil completeBlock:block loadingView:self.view showHUD:YES];
        [backupcell setCurrentDic:nil];
        [rongliangCell setCurrentDic:nil];
        [dianzuCell setCurrentDic:nil];
    }
}

-(void)setContentIdentity:(NSString *)contentIdentity{
    _contentIdentity = contentIdentity;
    if([_contentIdentity isEqualToString:@"0"]){
        dianzuCell.hidden = YES;
        rongliangCell.hidden = YES;
    }else if([_contentIdentity isEqualToString:@"1"]){
        dianzuCell.hidden = YES;
        CGRect tableFrame = processingTaskTable.frame;
        tableFrame.size.height = tableFrame.size.height-40;
        processingTaskTable.frame = tableFrame;
    }else if([_contentIdentity isEqualToString:@"2"]){
        rongliangCell.hidden = YES;
        CGRect tableFrame = processingTaskTable.frame;
        tableFrame.size.height = tableFrame.size.height-40;
        processingTaskTable.frame = tableFrame;
    }
}

//判断是否需要显示备注
-(void)getAttachPropertyStatus{
    if(taskList.count == 0){
        processingTaskTable.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-120);
        backupcell.hidden = YES;
        dianzuCell.hidden = YES;
        rongliangCell.hidden = YES;
    }else{
        processingTaskTable.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-160);
        if([_contentIdentity isEqualToString:@"0"]){
            dianzuCell.hidden = YES;
            rongliangCell.hidden = YES;
            backupcell.hidden = NO;
        }else if([_contentIdentity isEqualToString:@"1"]){
            dianzuCell.hidden = YES;
            rongliangCell.hidden = NO;
            backupcell.hidden = NO;
            CGRect tableFrame = processingTaskTable.frame;
            tableFrame.size.height = tableFrame.size.height-40;
            processingTaskTable.frame = tableFrame;
        }else if([_contentIdentity isEqualToString:@"2"]){
            rongliangCell.hidden = YES;
            dianzuCell.hidden = NO;
            backupcell.hidden = NO;
            CGRect tableFrame = processingTaskTable.frame;
            tableFrame.size.height = tableFrame.size.height-40;
            processingTaskTable.frame = tableFrame;
        }
    }
}
@end
