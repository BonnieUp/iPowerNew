//
//  QualityAnalysisMangmentViewController.m
//  i动力
//
//  Created by 丁浪平 on 16/3/19.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "QualityAnalysisMangmentViewController.h"
#import "IPowerExcelViewController.h"
#import "MangmentFViewController.h"
@interface QualityAnalysisMangmentViewController ()<UIScrollViewDelegate>{
    NSMutableArray *controllers;
    UIView *tabbarView;
    BOOL isComplete;
    NSUInteger selectedTab;

}
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation QualityAnalysisMangmentViewController
@synthesize FVC,SVC;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBar setHidden:YES];
        self.title = @"动环运行质量分析";
//        [self addNavigationLeftIconItem:@"left_s.png"];
//        [self setTitleWithPosition:@"left" title:@"周期维护"];

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeTabBarHidden:YES];
}
-(void)addNavigationLeftIconItem:(NSString*)RightItemIconName
{
    
    UIButton *backBtn = [UIButton ButtonimageWithFrame:CGRectMake(0, 0, 30, 36) Normal:[UIImage imageNamed:RightItemIconName] Select:[UIImage imageNamed:RightItemIconName] Title:nil];
    [backBtn addTarget:self action:@selector(goLastViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarButtonItem];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isComplete = NO;
    controllers = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    
    self.FVC = [[MangmentFViewController alloc]init];
    self.SVC = [[MangmentSViewController alloc]init];
    [controllers addObject:self.FVC];
    [controllers addObject:self.SVC];
        
    self.viewControllers = controllers;
    
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40, ScreenWidth, 40)];
    tabbarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    float tabWidth = self.view.frame.size.width / [controllers count];
    _tabs = [[NSMutableArray alloc] init];
    for (int i=0; i < [controllers count]; i++){
        
        UIViewController *controller = [controllers objectAtIndex:i];
        // Create button
        UIButton *tab = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, 40)];
        [tab setTitle:controller.title forState:UIControlStateNormal];
        tab.titleLabel.font = [UIFont systemFontOfSize:14];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        tab.backgroundColor = [UIColor colorWithRed:238/255.0 green:246/255.0 blue:249/255.0 alpha:1];
        [tab setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:185/255.0 green:217/255.0 blue:233/255.0 alpha:1] size:CGSizeMake(120, 40)] forState:UIControlStateSelected];
        [tab addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarView addSubview:tab];
        [_tabs addObject:tab];
        
        // Add separator
        if( i>0 ){
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(i*tabWidth,0,0.5,40)];
            [sep setBackgroundColor:[UIColor colorWithWhite:1 alpha:1.0]];
            [tabbarView addSubview:sep];
        }
    }
    [self.view addSubview:tabbarView];
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    
    self.FVC.backToHomePage = _backToHomePage;
    self.SVC.backToHomePage = _backToHomePage;
  
//    selectedTab = 0;
//    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,40,
//                                                                       self.view.frame.size.width,
//                                                                       self.view.frame.size.height - 40)];
//    [_contentScrollView setPagingEnabled:YES];
//    [_contentScrollView setDelegate:self];
//    _contentScrollView.bounces = NO;
//    
//    UIViewController *controller0 = [controllers objectAtIndex:0];
//    UIViewController *controller1 = [controllers objectAtIndex:1];
//    [[controller0 view] setFrame:CGRectMake(0 * _contentScrollView.frame.size.width,
//                                           0.0,
//                                           _contentScrollView.frame.size.width,
//                                           _contentScrollView.frame.size.height-40)];
//    [[controller1 view] setFrame:CGRectMake(1* _contentScrollView.frame.size.width,
//                                           0.0,
//                                           _contentScrollView.frame.size.width,
//                                           _contentScrollView.frame.size.height)];
//    
//    [_contentScrollView addSubview:[controller0 view]];
//    [_contentScrollView addSubview:[controller1 view]];
//    [self.view addSubview:_contentScrollView];

    
        // Do any additional setup after loading the view.
}


//设置contentScrollView的内容大小
-(void)viewWillLayoutSubviews
{
    _contentScrollView.frame = CGRectMake(0.0,40,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height-40);
    [_contentScrollView setShowsHorizontalScrollIndicator:NO];
    for (int i=0; i < [controllers count]; i++){
        // Create content view
        UIViewController *controller = [controllers objectAtIndex:i];
        [[controller view] setFrame:CGRectMake(i * _contentScrollView.frame.size.width,
                                               0.0,
                                               _contentScrollView.frame.size.width,
                                               _contentScrollView.frame.size.height)];
    }
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width * [controllers count], self.view.frame.size.height - 40)];
}


-(void)goLastViewController {
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

//隐藏tabbar
- (void)makeTabBarHidden:(BOOL)hide {
    if ( [self.view.subviews count] < 2 )
        return;
    UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    
    if ( hide ){
        contentView.frame = self.view.bounds;
    }
    else{
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - self.tabBar.frame.size.height);
    }
    self.tabBar.hidden = hide;
}
//设置tab
- (void)selectTab:(id)sender
{
    NSInteger selectIndex = [_tabs indexOfObject:sender];
    [self deselectAllTabs];
    [sender setSelected:YES];
    self.selectedIndex = selectIndex;
}

#pragma mark ---- scrollerview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    [self deselectAllTabs];
    UIButton *tab = [_tabs objectAtIndex:page];
    selectedTab = page;
    [tab setSelected:YES];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + (0.5f * width)) / width;
  
}

//去掉当前所有tab的选中状态
- (void)deselectAllTabs{
    for (UIButton *tab in _tabs){
        [tab setSelected:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
