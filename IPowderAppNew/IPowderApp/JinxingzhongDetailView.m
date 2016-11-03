//
//  JinxingzhongDetailView.m
//  i动力
//
//  Created by 王敏 on 16/1/8.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "JinxingzhongDetailView.h"
#import "PowerDataService.h"
#import "JinxingzhongContentView.h"

@implementation JinxingzhongDetailView{
    UITableView *tableView;
    NSMutableArray *checkDataList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSString *planNum;
    //当前选项卡索引
    NSUInteger selectedTab;
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
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40,ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    //refreshHeadView
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, self.view.frame.size.width, tableView.bounds.size.height)];
        view.delegate = self;
        [tableView addSubview:view];
        _refreshHeaderView = view;
        
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    
    float tabWidth = ScreenWidth / 4;
    float  _menuHeight = 40;
    NSArray *controllers = [[NSArray alloc]initWithObjects:@"待认领",@"待开始",@"进行中",@"已完成", nil];
    _tabs = [[NSMutableArray alloc] init];
    for (int i=0; i < controllers.count; i++)
    {
        // Create content view
        NSString *str = [controllers objectAtIndex:i];
        // Create button
        UIButton *tab = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, _menuHeight)];
        [tab setTitle:str forState:UIControlStateNormal];
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
    
    UIButton *tab = [_tabs objectAtIndex:2];
    [tab setSelected:YES];
    selectedTab = 2;
    UIView *bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, _menuHeight- 1.0, ScreenWidth, 1.0)];
    //    bottomHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    bottomHeaderView.backgroundColor = [UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1];
    [self.view addSubview:bottomHeaderView];
}

-(void)selectTab:(id)sender{
    selectedTab = [_tabs indexOfObject:sender];
    if(selectedTab==2)
        return;
    NSString *selectStr = [NSString stringWithFormat:@"%lu",(unsigned long)selectedTab];
    //发送改变选项卡的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"donglihechachangetab" object:selectStr];
    
}

-(void)setPlanNum:(NSString *)num{
    planNum = num;
    RequestCompleteBlock block = ^(id result) {
        checkDataList = result;
        [tableView reloadData];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
    };
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    [dataService getPrCheckStationDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] checkStatusNum:@"3" planNum:planNum completeBlock:block loadingView:self.view showHUD:YES];
}

#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [checkDataList objectAtIndex:indexPath.row];
    JinxingzhongContentView *contentView = [[JinxingzhongContentView alloc]init];
    contentView.titleFont = [UIFont systemFontOfSize:12];
    [contentView setTitleWithPosition:@"center" title:_titleStr];
    [contentView setRecordNum:[dic objectForKey:@"RECORD_NUM"]];
    [contentView setTitleStr:[NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STATION_NAME"]]];
    contentView.delegate = self;
    [self.navigationController pushViewController:contentView animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return checkDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.contentView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
        //添加内容label
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280, 25)];
        titleLabel.tag = 100;
        [titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [cell.contentView addSubview:titleLabel];
        //时间label
        UILabel *startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 150, 25)];
        startTimeLabel.tag = 101;
        [startTimeLabel setFont:[UIFont systemFontOfSize:11]];
        startTimeLabel.textColor = [UIColor colorWithRed:49/255.0 green:167/255.0 blue:233/255.0 alpha:1];
        [cell.contentView addSubview:startTimeLabel];
        
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
    titleLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STATION_NAME"]];
    //设置开始时间
    UILabel *timeStartLabel = (UILabel *)[cell.contentView viewWithTag:101];
    timeStartLabel.text = [NSString stringWithFormat:@"计划时间:%@",[dic objectForKey:@"CHECKED_START_TIME"]];
    
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
    [self setPlanNum:planNum];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    return _reloading;
}


#pragma mark ------jinxingzhongContentView delegate
-(void)popToJinxingzhongDetailViewController{
    [self.navigationController popToViewController:self animated:YES];
    [self setPlanNum:planNum];
}

@end
