//
//  TaskDetailMainViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-15.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "TaskDetailMainViewController.h"

@interface TaskDetailMainViewController ()

@end

@implementation TaskDetailMainViewController

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
    _menuHeight = 40;
    unFinishingTaskViewCtrl = [[UnFinishingTaskViewController alloc]init];
    unFinishingTaskViewCtrl.delegate = self;
    processingTaskViewCtrl = [[ProcessingTaskViewController alloc]init];
    processingTaskViewCtrl.delegate = self;
    finishedTaskViewCtrl = [[FinishedTaskViewController alloc]init];
    finishedTaskViewCtrl.delegate = self;

    NSArray *viewControllers = [NSMutableArray arrayWithObjects:unFinishingTaskViewCtrl,processingTaskViewCtrl,finishedTaskViewCtrl,nil];
    self.controllers = viewControllers;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
}

//设置contentScrollView的内容大小
-(void)viewWillLayoutSubviews
{
    _contentScrollView.frame = CGRectMake(0.0,
                                          _menuHeight+40,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height-_menuHeight);
    [_contentScrollView setShowsHorizontalScrollIndicator:NO];
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];
        
        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
    }
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width * [_controllers count], self.view.frame.size.height - _menuHeight)];
    
    [self selectTabNum:_selectedTab];
}

//布局视图
- (void)loadUI
{
    //创建titleLabel
    taskTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 39.5)];
    taskTitleLabel.textAlignment = NSTextAlignmentCenter;
    taskTitleLabel.font = [UIFont systemFontOfSize:14];
    taskTitleLabel.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    taskTitleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:taskTitleLabel];
    _amountLabels = [[NSMutableArray alloc]init];
    UIView *horizontalGap = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           40,
                                                           ScreenWidth,
                                                           1)];
    [horizontalGap setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:1.0]];
    [self.view addSubview:horizontalGap];
    //创建滚动视图
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,_menuHeight+40,
                                                                        ScreenWidth,
                                                                        ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT - _menuHeight)];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setDelegate:self];
    _contentScrollView.bounces = NO;
    
    float tabWidth = self.view.frame.size.width / [_controllers count];
    _tabs = [[NSMutableArray alloc] init];
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];
        
        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
        [_contentScrollView addSubview:[controller view]];
        
        // Create button
        UIButton *tab = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 40, tabWidth, _menuHeight)];
        [tab setTitle:controller.title forState:UIControlStateNormal];
        tab.titleLabel.font = [UIFont systemFontOfSize:13];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tab.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        //        [tab setBackgroundImage:[UIImage imageNamed:@"tabbar_background.png"] forState:UIControlStateSelected];
        [tab setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1] size:tab.size] forState:UIControlStateSelected];
        [tab addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tab];
        [_tabs addObject:tab];
        
        // Create label
        UIImageView *labelImageView = [[UIImageView alloc]initWithFrame:CGRectMake((i+1) * tabWidth-27, 42, 25, 25)];
        [labelImageView setHidden:YES];
        labelImageView.image = [UIImage imageNamed:@"bg_num_red.9.png"];
        UILabel *labelView = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 25, 25)];
        labelView.font = [UIFont systemFontOfSize:12];
        labelView.textAlignment = NSTextAlignmentCenter;
        labelView.textColor = [UIColor whiteColor];
        labelView.backgroundColor = [UIColor clearColor];
        labelView.tag = 101;
        [labelImageView addSubview:labelView];
        [self.view addSubview:labelImageView];
        [_amountLabels addObject:labelImageView];
        
        // Add separator
        if( i>0 )
        {
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(i*tabWidth,
                                                                   40,
                                                                   0.5,
                                                                   40)];
            [sep setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]];
            [self.view addSubview:sep];
        }
    }
    
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    _selectedTab = 0;
    
    UIView *bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, _menuHeight- 1.0, self.view.frame.size.width, 1.0)];
    //    bottomHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    bottomHeaderView.backgroundColor = [UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1];
    [self.view addSubview:bottomHeaderView];
    
    [self.view addSubview:_contentScrollView];
}


#pragma mark ---- scrollerview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self deselectAllTabs];
    UIButton *tab = [_tabs objectAtIndex:page];
    [tab setSelected:YES];
}

#pragma mark ------unFinishingTaskView delegate
-(void)setUnFinishingTaskAmount:(NSString *)taskAmount {
//    UIButton *tab = [_tabs objectAtIndex:0];
//    if(![taskAmount isEqualToString:@"0"]) {
//        [tab setTitle:[NSString stringWithFormat:@"未完成(%@)",taskAmount] forState:UIControlStateNormal];
//        [tab setTitle:[NSString stringWithFormat:@"未完成(%@)",taskAmount] forState:UIControlStateSelected];
//    }else {
//        [tab setTitle:@"未完成" forState:UIControlStateNormal];
//        [tab setTitle:@"未完成" forState:UIControlStateSelected];
//    }
    UIImageView *amountImageView = [_amountLabels objectAtIndex:0];
    if([taskAmount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = taskAmount;
}

#pragma mark ------processingTaskView delegate
-(void)setProcessingTaskAmount:(NSString *)taskAmount {
//    UIButton *tab = [_tabs objectAtIndex:1];
//    if(![taskAmount isEqualToString:@"0"]) {
//        [tab setTitle:[NSString stringWithFormat:@"进行中(%@)",taskAmount] forState:UIControlStateNormal];
//        [tab setTitle:[NSString stringWithFormat:@"进行中(%@)",taskAmount] forState:UIControlStateSelected];
//    }else {
//        [tab setTitle:@"进行中" forState:UIControlStateNormal];
//        [tab setTitle:@"进行中" forState:UIControlStateSelected];
//    }
    UIImageView *amountImageView = [_amountLabels objectAtIndex:1];
    if([taskAmount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = taskAmount;
}

#pragma mark ------finishedTaskView delegate
-(void)setFinishedTaskAmount:(NSString *)taskAmount {
//    UIButton *tab = [_tabs objectAtIndex:2];
//    if(![taskAmount isEqualToString:@"0"]) {
//        [tab setTitle:[NSString stringWithFormat:@"已完成(%@)",taskAmount] forState:UIControlStateNormal];
//        [tab setTitle:[NSString stringWithFormat:@"已完成(%@)",taskAmount] forState:UIControlStateSelected];
//    }else {
//        [tab setTitle:@"已完成" forState:UIControlStateNormal];
//        [tab setTitle:@"已完成" forState:UIControlStateSelected];
//    }
    UIImageView *amountImageView = [_amountLabels objectAtIndex:2];
    if([taskAmount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = taskAmount;
}

//设置tab
- (void)selectTab:(id)sender
{
    _selectedTab = [_tabs indexOfObject:sender];
    CGRect rect = CGRectMake(self.view.frame.size.width * _selectedTab,
                             0.0,
                             self.view.frame.size.width,
                             _contentScrollView.contentSize.height);
    [_contentScrollView scrollRectToVisible:rect animated:YES];
    [self deselectAllTabs];
    [sender setSelected:YES];
    
    if(_selectedTab == 0){
        [unFinishingTaskViewCtrl getTaskDetail];
    }else if(_selectedTab == 1){
        [processingTaskViewCtrl getTaskDetail];
    }else if(_selectedTab == 2){
        [finishedTaskViewCtrl getTaskDetail];
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    if(page == 0){
        [unFinishingTaskViewCtrl getTaskDetail];
    }else if(page == 1){
        [processingTaskViewCtrl getTaskDetail];
    }else if(page == 2){
        [finishedTaskViewCtrl getTaskDetail];
    }
}

//设置tab
- (void)selectTabNum:(NSInteger)index
{
    if(index<0 || index>=[_tabs count])
    {
        return;
    }
    UIButton *tab = [_tabs objectAtIndex:index];
    [self selectTab:tab];
}

//去掉当前所有tab的选中状态
- (void)deselectAllTabs
{
    for (UIButton *tab in _tabs)
    {
        [tab setSelected:NO];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

-(void)setTaskId:(NSString *)taskId {
    if(![_taskId isEqualToString:taskId]) {
        _taskId = taskId;
        
        unFinishingTaskViewCtrl.taskId = _taskId;
        processingTaskViewCtrl.taskId = _taskId;
        finishedTaskViewCtrl.taskId = _taskId;
    }
}

-(void)setNuName:(NSString *)nuName {
    if(![_nuName isEqualToString:nuName]) {
        _nuName = nuName;
        
        taskTitleLabel.text = _nuName;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setContentIdentity:(NSString *)contentIdentity {
    _contentIdentity = contentIdentity;
    processingTaskViewCtrl.contentIdentity = contentIdentity;
}

-(void)setIsAuto:(NSString *)isAuto {
    _isAuto = isAuto;
    unFinishingTaskViewCtrl.isAuto = _isAuto;
}
@end
