//
//  ZhouqiweihuViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "ZhouqiweihuViewController.h"
#import "BaseNavigationController.h"
#import "LocationViewController.h"
#import "SubTaskListViewController.h"
#import "WarningDetailMainViewController.h"
#import "TaskDetailMainViewController.h"
@implementation ZhouqiweihuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleWithPosition:@"left" title:@"周期维护"];
    }
    return self;
}


- (void)viewDidLoad
{

    [super viewDidLoad];
    
    _menuHeight = 40;
    myTaskCtrl = [[MyTaskViewController alloc]init];
    myTaskCtrl.delegate = self;
    groupTaskCtrl = [[GroupTaskViewController alloc]init];
    groupTaskCtrl.delegate = self;
    processTaskCtrl = [[ProcessingViewController alloc]init];
    processTaskCtrl.delegate = self;
    warningCtrl = [[WarningViewController alloc]init];
    warningCtrl.delegate = self;
    NSArray *viewControllers = [NSMutableArray arrayWithObjects:myTaskCtrl,groupTaskCtrl,processTaskCtrl,warningCtrl,nil];
    self.controllers = viewControllers;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
    
    //添加操作按钮
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40,ScreenWidth,40)];
//    operationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    //扫描设备按钮
    float buttonWidth = (ScreenWidth-30)/2;
    saomiaoBtn = [[UIGlossyButton alloc]init];
    saomiaoBtn.frame = CGRectMake(5, 5, buttonWidth, 30);
    [saomiaoBtn setTitle:@"设备扫描" forState:UIControlStateNormal];
    [saomiaoBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [saomiaoBtn addTarget:self action:@selector(scanHandler) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:saomiaoBtn];
    
    //开始维护按钮
    allTaskBtn = [[UIGlossyButton alloc]init];
    allTaskBtn.frame = CGRectMake(saomiaoBtn.right+20, 5, buttonWidth, 30);
    [allTaskBtn setTitle:@"全部任务" forState:UIControlStateNormal];
    [allTaskBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [allTaskBtn addTarget:self action:@selector(allTaskHandler) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:allTaskBtn];
    
    [self.view addSubview:operationView];
    
}


//设置contentScrollView的内容大小
-(void)viewWillLayoutSubviews
{
    _contentScrollView.frame = CGRectMake(0.0,
                                          _menuHeight,
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
}

//布局视图
- (void)loadUI
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,_menuHeight,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height - _menuHeight)];
    [_contentScrollView setPagingEnabled:YES];
    [_contentScrollView setDelegate:self];
    _contentScrollView.bounces = NO;
    
    float tabWidth = self.view.frame.size.width / [_controllers count];
    _tabs = [[NSMutableArray alloc] init];
    _amountLabels = [[NSMutableArray alloc]init];
    for (int i=0; i < [_controllers count]; i++)
    {
        // Create content view
        UIViewController *controller = [_controllers objectAtIndex:i];
        
        if(i==0||i==1) {
            [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                                   0.0,
                                                   _contentScrollView.frame.size.width,
                                                   _contentScrollView.frame.size.height-40)];
        }else {
            [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                                   0.0,
                                                   _contentScrollView.frame.size.width,
                                                   _contentScrollView.frame.size.height)];
        }

        [_contentScrollView addSubview:[controller view]];
        
        // Create button
        UIButton *tab = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, _menuHeight)];
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
        UIImageView *labelImageView = [[UIImageView alloc]initWithFrame:CGRectMake((i+1) * tabWidth-27, 2, 25, 25)];
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
                                                                   0,
                                                                   0.5,
                                                                   40)];
            [sep setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]];
            [self.view addSubview:sep];
        }
    }
    
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    selectedTab = 0;
    
    UIView *bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, _menuHeight- 1.0, self.view.frame.size.width, 1.0)];
    //    bottomHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    bottomHeaderView.backgroundColor = [UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1];
    [self.view addSubview:bottomHeaderView];
    
    [self.view addSubview:_contentScrollView];
}

//获取数据
-(void)loadData {
    //设置当前站点
//    UIBarButtonItem *button  = [[UIBarButtonItem alloc] initWithTitle:[_siteDic objectForKey:@"siteName"] style:UIBarButtonItemStyleBordered target:self action:@selector(siteOnChangeHandler)];
//    UIView *siteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
//    //创建label
//    UILabel *siteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
//    siteLabel.text = [_siteDic objectForKey:@"siteName"];
//    siteLabel.backgroundColor = [UIColor clearColor];
//    siteLabel.font = [UIFont systemFontOfSize:13];
//    siteLabel.textAlignment = NSTextAlignmentRight;
//    siteLabel.textColor = [UIColor whiteColor];
//    [siteView addSubview:siteLabel];
    //创建button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth-120, 0, 120,NAVIGATION_BAR_HEIGHT);
    [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"right_s.png"] scaleToSize:CGSizeMake(20,20)] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10,100, 10,0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 10, 20)];
    [btn setTitle:[_siteDic objectForKey:@"siteName"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(siteOnChangeHandler) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setTextColor:[UIColor whiteColor]];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if(IOS_LEVEL>=7){
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -15;
        
        self.navigationItem.rightBarButtonItems = @[negativeSeperator,buttonItem];
    }else{
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    
}

#pragma mark ---- scrollerview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    float tabWidth = _indicatorView.frame.size.width;
    _indicatorView.frame = CGRectMake(page * tabWidth, _menuHeight  - 5.0, tabWidth, 5.0);
    [self deselectAllTabs];
    UIButton *tab = [_tabs objectAtIndex:page];
    [tab setSelected:YES];
    
    //是否需要隐藏操作栏
    selectedTab = page;
    if(selectedTab == 2 || selectedTab == 3)
        [operationView setHidden:YES];
    else
        [operationView setHidden:NO];
    

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    if(page == 0){
        [myTaskCtrl getTask];
    }else if(page == 1){
        [groupTaskCtrl getTask];
    }else if(page == 2 ){
        [processTaskCtrl getTask];
    }else if(page == 3){
        [warningCtrl getWarningData];
    }
}

//设置tab
- (void)selectTab:(id)sender
{
    selectedTab = [_tabs indexOfObject:sender];
    //是否需要隐藏操作栏
    if(selectedTab == 2 || selectedTab == 3)
        [operationView setHidden:YES];
    else
        [operationView setHidden:NO];
    float tabWidth = self.view.frame.size.width / [_controllers count];
    CGRect rect = CGRectMake(self.view.frame.size.width * selectedTab,
                             0.0,
                             self.view.frame.size.width,
                             _contentScrollView.contentSize.height);
    [_contentScrollView scrollRectToVisible:rect animated:YES];
    [self deselectAllTabs];
    [sender setSelected:YES];
    _indicatorView.frame = CGRectMake(selectedTab*tabWidth, _menuHeight  - 5.0,tabWidth , 5.0);
    
    if(selectedTab == 0){
        [myTaskCtrl getTask];
    }else if(selectedTab == 1){
        [groupTaskCtrl getTask];
    }else if(selectedTab == 2 ){
        [processTaskCtrl getTask];
    }else if(selectedTab == 3){
        [warningCtrl getWarningData];
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

-(void)setSiteDic:(NSDictionary *)siteDic {
    if(![_siteDic isEqualToDictionary:siteDic]) {
        _siteDic = siteDic;
        [self loadData];
        
        myTaskCtrl.siteId = [_siteDic objectForKey:@"siteId"];
        groupTaskCtrl.siteId = [_siteDic objectForKey:@"siteId"];
        processTaskCtrl.siteId = [_siteDic objectForKey:@"siteId"];
        warningCtrl.siteId = [_siteDic objectForKey:@"siteId"];
    }
}
//切换所选站点
-(void)siteOnChangeHandler {
    LocationViewController *locationCtrl = [[LocationViewController alloc]init];
    [self.navigationController pushViewController:locationCtrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------- myTaskViewCtrl delegate
-(void)popSubTaskListWith:(NSString *)siteId taskTypeId:(NSString *)taskTypeId taskName:(NSString *)taskName taskAmount:(NSString *)taskAmount isAuto:(NSString *)isAuto{
    //跳转到二级任务列表界面
    SubTaskListViewController *subTaskViewCtrl = [[SubTaskListViewController alloc]init];
    subTaskViewCtrl.siteId = siteId;
    subTaskViewCtrl.taskTypeId = taskTypeId;
    subTaskViewCtrl.isAuto = isAuto;
    subTaskViewCtrl.typeStr = @"我的任务";
    subTaskViewCtrl.detailTaskName = [NSString stringWithFormat:@"%@",taskName];
//    [subTaskViewCtrl setTitleWithPosition:@"center" title:[NSString stringWithFormat:@"%@",taskName]];
    [self.navigationController pushViewController:subTaskViewCtrl animated:YES];
}

-(void)popGroupSubTaskListWith:(NSString *)siteId taskTypeId:(NSString *)taskTypeId taskName:(NSString *)taskName taskAmount:(NSString *)taskAmount isAuto:(NSString *)isAuto{
    //跳转到二级任务列表界面
    SubTaskListViewController *subTaskViewCtrl = [[SubTaskListViewController alloc]init];
    subTaskViewCtrl.siteId = siteId;
    subTaskViewCtrl.taskTypeId = taskTypeId;
    subTaskViewCtrl.isAuto = isAuto;
    subTaskViewCtrl.typeStr = @"全组任务";
    subTaskViewCtrl.detailTaskName = [NSString stringWithFormat:@"%@",taskName];
    //    [subTaskViewCtrl setTitleWithPosition:@"center" title:[NSString stringWithFormat:@"%@",taskName]];
    [self.navigationController pushViewController:subTaskViewCtrl animated:YES];
}
-(void)setMyTaskAmount:(NSString *)taskAmount {
    UIImageView *amountImageView = [_amountLabels objectAtIndex:0];
    if([taskAmount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = taskAmount;
}
#pragma mark ------- groupTaskViewCtrl delegate
-(void)setGroupTaskAmount:(NSString *)taskAmount {
    UIImageView *amountImageView = [_amountLabels objectAtIndex:1];
    if([taskAmount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = taskAmount;
}

#pragma mark ------- processingTaskViewCtrl delegate
-(void)setProcessingTaskAmount:(NSString *)taskAmount {
    UIImageView *amountImageView = [_amountLabels objectAtIndex:2];
    if([taskAmount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = taskAmount;
}

-(void)popTaskDetailWithTaskId:(NSString *)taskId nuName:(NSString *)nuName title:(NSString *)title contentIdentity:(NSString *)contentIdentity{
    //弹出任务清单信息视图
    TaskDetailMainViewController *taskDetailCtrl = [[TaskDetailMainViewController alloc]init];
    taskDetailCtrl.taskId = taskId;
    taskDetailCtrl.nuName = nuName;
    taskDetailCtrl.contentIdentity = contentIdentity;
    [taskDetailCtrl setTitleWithPosition:@"center" title:title];
    taskDetailCtrl.selectedTab = 1;
    [self.navigationController pushViewController:taskDetailCtrl animated:YES];
}
#pragma mark ------- warningViewCtrl delegate
-(void)setWarningTaskAmount:(NSString *)taskAmount {
    UIImageView *amountImageView = [_amountLabels objectAtIndex:3];
    if([taskAmount intValue]>0) {
        [amountImageView setHidden:NO];
    }else {
        [amountImageView setHidden:YES];
    }
    UILabel *amountLabel = (UILabel *)[amountImageView viewWithTag:101];
    amountLabel.text = taskAmount;
}

-(void)popWarningDetailWithDic:(NSDictionary *)dic {
    //弹出任务清单信息视图
    WarningDetailMainViewController *warningDetailCtrl = [[WarningDetailMainViewController alloc]init];
    warningDetailCtrl.warningDic = dic;
    [self.navigationController pushViewController:warningDetailCtrl animated:YES];
}
//扫描设备
-(void)scanHandler {
    //弹出扫描视图
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    //非全屏
    reader.wantsFullScreenLayout = NO;
    reader.navigationItem.hidesBackButton = YES;
    //隐藏底部按钮
    reader.showsZBarControls = NO;
    
    [self setOverlayPickerView:reader];
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self.navigationController pushViewController:reader animated:YES];
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader
{
    //清除原有控件
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
            
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }
    //画中间的基准线
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    line.backgroundColor = [UIColor greenColor];
    [reader.view addSubview:line];
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:upView];
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    labIntroudction.font = [UIFont systemFontOfSize:14];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [reader.view addSubview:labIntroudction];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:leftView];
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:rightView];
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 120)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:downView];
    //用于取消操作的button
    UIGlossyButton *cancelButton = [[UIGlossyButton alloc]init];
    [cancelButton setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [cancelButton setFrame:CGRectMake(20, 370, 280, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:cancelButton];
}

//取消button方法
- (void)dismissOverlayView:(id)sender{
   [self.navigationController popViewControllerAnimated:YES];
}

-(void)scanWithResNo:(NSString *)resNo {
    if(selectedTab == 0 ) {
        [myTaskCtrl getTaskWithResNo:resNo];
    }else if(selectedTab == 1) {
        [groupTaskCtrl getTaskWithResNo:resNo];
    }
}


#pragma mark zbar delegate
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [self.navigationController popViewControllerAnimated:YES];
    [self scanWithResNo:symbol.data];
}
//获取全部任务
-(void)allTaskHandler {
    //我的任务
    if(selectedTab == 0 ) {
        [myTaskCtrl getTask];
    }else if(selectedTab == 1) {
        [groupTaskCtrl getTask];
    }
}

//重写backAction
-(void)backAction {
    //如果可以跳转到主界面
    if(_backToHomePage==YES){
        [super backAction];
    }
    //跳转到i运维
    else {
        NSString *urlStr = @"telecom://iPower/returnTelecom?fnType=iPowerTask";
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
