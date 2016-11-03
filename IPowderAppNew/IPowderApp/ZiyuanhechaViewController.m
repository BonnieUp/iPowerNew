//
//  ZiyuanhechaViewController.m
//  i动力
//
//  Created by 王敏 on 15/12/26.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "ZiyuanhechaViewController.h"
#import "DairenlingDetailView.h"
#import "DaikaishiDetailView.h"
#import "YiwanchengDetailView.h"
#import "JinxingzhongDetailView.h"


@implementation ZiyuanhechaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleWithPosition:@"center" title:@"动力资源核查"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(navigateToSelectTabFromNotification:)
                                                     name:@"donglihechachangetab"
                                                   object:nil];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _menuHeight = 40;
    
    dairenlingCtrl = [[DairenlingViewController alloc]init];
    dairenlingCtrl.delegate = self;
    
    daikaishiCtrl = [[DaikaishiViewController alloc]init];
    daikaishiCtrl.delegate = self;
    
    daiwanchengCtrl = [[DaiwanchengViewController alloc]init];
    daiwanchengCtrl.delegate  = self;
    
    yiwanchengCtrl = [[YiwanchengViewController alloc]init];
    yiwanchengCtrl.delegate = self;
    
    
    NSArray *viewControllers = [NSMutableArray arrayWithObjects:dairenlingCtrl,daikaishiCtrl,daiwanchengCtrl,yiwanchengCtrl,nil];
    self.controllers = viewControllers;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [dairenlingCtrl getCheckData];
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

//设置tab
- (void)selectTab:(id)sender
{
    selectedTab = [_tabs indexOfObject:sender];
    CGRect rect = CGRectMake(self.view.frame.size.width * selectedTab,
                             0.0,
                             self.view.frame.size.width,
                             _contentScrollView.contentSize.height);
    [_contentScrollView scrollRectToVisible:rect animated:YES];
    [self deselectAllTabs];
    [sender setSelected:YES];
    
    if(selectedTab == 0){
        [dairenlingCtrl getCheckData];
    }else if(selectedTab == 1){
        [daikaishiCtrl getCheckData];
    }else if(selectedTab == 2){
        [daiwanchengCtrl getCheckData];
    }else if(selectedTab == 3){
        [yiwanchengCtrl getCheckData];
    }
    
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


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    if(page == 0){
        [dairenlingCtrl getCheckData];
    }else if(page == 1){
        [daikaishiCtrl getCheckData];
    }else if(page == 2 ){
        [daiwanchengCtrl getCheckData];
    }else if(page == 3){
        [yiwanchengCtrl getCheckData];
    }
}

#pragma mark -------ctrl delegate
-(void)popDairenlingDetailViewController:(NSString *)planNum titleLabel:(NSString *)titleLabel{
    DairenlingDetailView *detailView = [[DairenlingDetailView alloc]init];
    detailView.titleFont = [UIFont systemFontOfSize:12];
    [detailView setTitleWithPosition:@"center" title:titleLabel];
    [self.navigationController pushViewController:detailView animated:NO];
    [detailView setPlanNum:planNum];
}

-(void)popDaikaishiDetailViewController:(NSString *)planNum titleLabel:(NSString *)titleLabel{
    DaikaishiDetailView *detailView = [[DaikaishiDetailView alloc]init];
    detailView.titleFont = [UIFont systemFontOfSize:12];
    [detailView setTitleWithPosition:@"center" title:titleLabel];
    [self.navigationController pushViewController:detailView animated:NO];
    [detailView setPlanNum:planNum];
}

-(void)popDaiwanchengDetailViewController:(NSString *)planNum titleLabel:(NSString *)titleLabel{
    JinxingzhongDetailView *detailView = [[JinxingzhongDetailView alloc]init];
    detailView.titleFont = [UIFont systemFontOfSize:12];
    [detailView setTitleWithPosition:@"center" title:titleLabel];
    detailView.titleStr = titleLabel;
    [self.navigationController pushViewController:detailView animated:NO];
    [detailView setPlanNum:planNum];
}

-(void)popYiwanchengDetailViewController:(NSString *)planNum titleLabel:(NSString *)titleLabel{
    YiwanchengDetailView *detailView = [[YiwanchengDetailView alloc]init];
    detailView.titleFont = [UIFont systemFontOfSize:12];
    [detailView setTitleWithPosition:@"center" title:titleLabel];
    [self.navigationController pushViewController:detailView animated:NO];
    [detailView setPlanNum:planNum];
}

-(void)navigateToSelectTabFromNotification:(NSNotification *)notification{
    NSString *selectTabStr = notification.object;
    [self.navigationController popToViewController:self animated:NO];
    NSInteger index = [selectTabStr integerValue];
    if(index<0 || index>=[_tabs count])
    {
        return;
    }
    UIButton *tab = [_tabs objectAtIndex:index];
    [self selectTab:tab];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"donglihechachangetab" object:nil];
}

//重写backAction
-(void)backAction {
    //如果可以跳转到主界面
    if(_backToHomePage==YES){
        [super backAction];
    }
    //跳转到i运维
    else {
        NSString *urlStr = @"telecom://iPower/returnTelecom?fnType=iPowerPR";
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
