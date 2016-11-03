//
//  XitonggongdianguanliViewController.m
//  i动力
//
//  Created by 王敏 on 15/12/26.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "XitonggongdianguanliViewController.h"
#import "PowerDataService.h"
#import "XIYI_MBProgressHUD.h"

@implementation XitonggongdianguanliViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"系统";
//        [self _initViews];

    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if (self.levelDataList) {
        if (self.levelDataList.count>0) {
            return;
        }
    }
    [self _initViews];
}

//初始化视图
-(void)_initViews {
    _reloading = NO;
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-40)];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-40)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight)];
    scrollView.delegate = self;
    
    [scrollView addSubview:contentView];
    [self.view addSubview:scrollView];
    
    //refreshHeadView
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
        view.delegate = self;
        [scrollView addSubview:view];
        _refreshHeaderView = view;
        
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    
}


-(void)getLevelData{
    [XIYI_MBProgressHUD showHUDAddedTo:self.view.window animated:YES];

    RequestCompleteBlock block = ^(id result) {
        self.levelDataList = (NSArray *)result;
        [XIYI_MBProgressHUD hideHUDForView:self.view.window animated:YES];

        [self drawLevelData];
        
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];

    };
    PowerDataService *service = [[PowerDataService alloc]initUserJsonHead];
    [service getPRServiceLevelDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] regNum:_regNO ObjTypeNum:@"3" completeBlock:block loadingView:self.view showHUD:YES];
}

-(void)drawLevelData{
    //先移除
    NSArray *viewsToRemove = [contentView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    //在添加
    int y=0;
    for(int i=0;i<self.levelDataList.count;i++){
        NSDictionary *dic = (NSDictionary *)[self.levelDataList objectAtIndex:i];
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, ScreenWidth/2, 40)];
        [leftLabel setText:[[dic objectForKey:@"SERVICE_LEVEL_NAME"] substringToIndex:2]];
        leftLabel.layer.borderWidth = 0.5;
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.layer.borderColor = [[UIColor grayColor] CGColor];
        [leftLabel setTextAlignment:NSTextAlignmentCenter];
        [contentView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, y, ScreenWidth/2, 40)];
        [rightLabel setText:[[dic objectForKey:@"TOTA_COUNT"] stringValue]];
        rightLabel.layer.borderWidth = 0.5;
        rightLabel.layer.borderColor = [[UIColor grayColor] CGColor];
        rightLabel.font = [UIFont systemFontOfSize:12];
        [rightLabel setTextAlignment:NSTextAlignmentCenter];
        [contentView addSubview:rightLabel];
        
        y+=40;
    }
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
    [self getLevelData];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    return _reloading;
}

-(BOOL)ishaveData{
    if (self.levelDataList) {
        if (self.levelDataList.count>0) {
            return YES;
        }
    }
    return NO;
}

-(void)setRegNO:(NSString *)regNO{
    if(![_regNO isEqualToString:regNO]) {
        _regNO = regNO;
//        [self getLevelData];
    }
}

@end
