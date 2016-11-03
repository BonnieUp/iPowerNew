//
//  XudianchifangdianceshiViewController.m
//  i动力
//
//  Created by 王敏 on 15/12/30.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "XudianchifangdianceshiViewController.h"
#import "PowerDataService.h"
#import "XudianchiFilterConditionViewController.h"


@implementation XudianchifangdianceshiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"蓄电池放电测试";
    }
    batteryList = [[NSMutableArray alloc]init];
    return self;
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
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80) style:UITableViewStylePlain];
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
    
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0,tableView.bottom,ScreenWidth,40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    searchBtn = [[UIGlossyButton alloc]init];
    searchBtn.frame = CGRectMake(5, 5, ScreenWidth-10, 30);
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [searchBtn addTarget:self action:@selector(popSearchWindow) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:searchBtn];
    [self.view addSubview:operationView];
}

//弹出查询条件视图
-(void)popSearchWindow{
    if(_delegate && [_delegate respondsToSelector:@selector(popFangdianFilterConditionController)]){
        [_delegate popFangdianFilterConditionController];
    }
}

//获取蓄电池放电测试数据
-(void)getXudianchiDataWithRegNum:(NSString *)regNum
                      testTypeNum:(NSString *)testTypeNum
                          staName:(NSString *)staName
                          sysName:(NSString *)sysName
                        assetsNum:(NSString *)assetsNum
                       articleNum:(NSString *)articleNum
                        startTime:(NSString *)startTime
                         stopTime:(NSString *)stopTime{
    
    RequestCompleteBlock block = ^(id result) {
        [batteryList removeAllObjects];
        NSArray *oriArray = (NSArray *)result;
        for(int i=0;i<oriArray.count;i++){
            NSDictionary *oriDic = (NSDictionary *)[oriArray objectAtIndex:i];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:oriDic];
            //开关状态,默认关闭
            [dic setValue:@"0" forKey:@"open"];
            [dic setValue:nil forKey:@"detailDic"];
            [batteryList addObject:dic];
        }
        [tableView reloadData];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
    };
    
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    [dataService getPRBatteryTestDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] regNum:regNum testTypeNum:testTypeNum staName:staName sysName:sysName assetsNum:assetsNum articleNum:articleNum startTime:startTime stopTime:stopTime completeBlock:block loadingView:self.view showHUD:YES];
    
}

-(void)setRegNO:(NSString *)regNO{
    if(![_regNO isEqualToString:regNO]) {
        _regNO = regNO;
        [self getXudianchiDataWithRegNum:_regNO testTypeNum:@"1" staName:@"" sysName:@"" assetsNum:@"" articleNum:@"" startTime:[PowerUtils getFirstDay:@"yyyy-MM-dd-HH:mm:ss"] stopTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]];
    }
}

#pragma mark ----tableview delegate
-(CGFloat)tableView:(UITableView *)tView heightForHeaderInSection:(NSInteger)section{
    return 85.0f;
}


- (CGFloat)tableView:(UITableView *)tView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 0;
    NSMutableDictionary *dic = [batteryList objectAtIndex:indexPath.section];
    NSMutableDictionary *detailDic = [dic objectForKey:@"detailDic"];
    if(detailDic!=nil){
        NSArray *commonInfoArray = [detailDic objectForKey:@"CommonInfoList"];
        if(commonInfoArray.count%2==0){
            height= 20*commonInfoArray.count/2+20;
        }else{
            height= 20*(commonInfoArray.count/2+1)+20;
        }
    }
    return height;
}

-(UIView *)tableView:(UITableView *)tView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    view.alpha = 1;
    NSDictionary *dic = (NSDictionary *)[batteryList objectAtIndex:section];
    //蓄电池名称label
    UILabel *mingchengLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, ScreenWidth-60, 20)];
    [mingchengLabel setTextAlignment:NSTextAlignmentLeft];
    [mingchengLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [mingchengLabel setText:[dic objectForKey:@"DEV_NAME" ]];
    [view addSubview:mingchengLabel];
    
    //位置
    UILabel *weizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, ScreenWidth-60, 20)];
    [weizhiLabel setTextAlignment:NSTextAlignmentLeft];
    [weizhiLabel setFont:[UIFont systemFontOfSize:12]];
    NSString *weizhiStr = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"REG_NAME"],[dic objectForKey:@"STA_NAME"],[dic objectForKey:@"ROOM_NAME"] ];
    [weizhiLabel setText:weizhiStr];
    [view addSubview:weizhiLabel];
    
    //操作时间
    UILabel *shijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, ScreenWidth-60, 20)];
    [shijianLabel setTextAlignment:NSTextAlignmentLeft];
    [shijianLabel setFont:[UIFont systemFontOfSize:12]];
    NSString *shijianStr = [NSString stringWithFormat:@"操作时间:%@",[dic objectForKey:@"TEST_TIME"]];
    [shijianLabel setText:shijianStr];
    [view addSubview:shijianLabel];
    
    //资产编号
    UILabel *zichanLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 60, 140, 20)];
    [zichanLabel setTextAlignment:NSTextAlignmentLeft];
    [zichanLabel setFont:[UIFont systemFontOfSize:12]];
    NSString *zichanStr = [NSString stringWithFormat:@"资产编号:%@",[dic objectForKey:@"ASSETS_NUM"]];
    [zichanLabel setText:zichanStr];
    [view addSubview:zichanLabel];
    
    //实物编号
    UILabel *shiwuLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-10, 60, 140, 20)];
    [shiwuLabel setTextAlignment:NSTextAlignmentLeft];
    [shiwuLabel setFont:[UIFont systemFontOfSize:12]];
    NSString *shiwuStr = [NSString stringWithFormat:@"实物编号:%@",[dic objectForKey:@"ARTICLE_NUM"]];
    [shiwuLabel setText:shiwuStr];
    [view addSubview:shiwuLabel];
    
    //分割线
    UIView  *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0,84, ScreenWidth, 0.5)];
    seperateView.alpha = 0.8;
    seperateView.backgroundColor = [UIColor grayColor];
    [view addSubview:seperateView];
    
    //按钮
    UIButton *zhankaiBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-30, 25, 30,30)];
    if([@"1" isEqualToString:[dic objectForKey:@"open"]]){
        [zhankaiBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"pic_arrow_1.png"] scaleToSize:CGSizeMake(15, 10)] forState:UIControlStateNormal];
    }else{
        [zhankaiBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"pic_arrow.png"] scaleToSize:CGSizeMake(10, 15)] forState:UIControlStateNormal];
    }
    zhankaiBtn.tag = section;
    [zhankaiBtn addTarget:self action:@selector(openDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:zhankaiBtn];
    
    return view;
}


-(void)openDetailView:(id)sender{
    NSInteger section = ((UIButton *)sender).tag;
    NSMutableDictionary *dic = (NSMutableDictionary *)[batteryList objectAtIndex:section];
    //如果是关闭状态，则打开
    if([@"0" isEqualToString:[dic objectForKey:@"open"]]){
        NSMutableDictionary *detailDic = (NSMutableDictionary *)[dic objectForKey:@"detailDic"];
        //如果为空,获取详情
        if(detailDic==nil){
            RequestCompleteBlock block = ^(id result) {
                NSDictionary *oriDic = (NSDictionary *)result;
                [dic setValue:oriDic forKey:@"detailDic"];
                [tableView reloadData];
            };
            
            PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
            [dataService getPrBatteryDischargeTestDetailWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] objNum:[dic objectForKey:@"OBJ_NUM"] completeBlock:block loadingView:tableView showHUD:YES];
            
        }
        [dic setValue:@"1" forKey:@"open"];
        [tableView reloadData];
    }
    //如果是打开状态，则关闭
    else{
        [dic setValue:@"0" forKey:@"open"];
        [tableView reloadData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *iden = @"cellfangdain";
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:iden];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    NSMutableDictionary *dic = [batteryList objectAtIndex:indexPath.section];
    NSMutableDictionary *detailDic = [dic objectForKey:@"detailDic"];
    if(detailDic!=nil){
        UILabel *gonggongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        gonggongLabel.text = @"公共属性";
        gonggongLabel.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:gonggongLabel];
        NSArray *commonInfoArray = [detailDic objectForKey:@"CommonInfoList"];
        int yPosition = 20;
        for(int i=0;i<commonInfoArray.count;i++){
            NSDictionary *detailItemDic = [commonInfoArray objectAtIndex:i];
            CGRect labelFrame;
            if(i%2==0 && i!=0){
                yPosition+=20;
            }
            //左边
            if(i%2==0){
                labelFrame = CGRectMake(0, yPosition, ScreenWidth/2+20, 20);
            }else{
                labelFrame = CGRectMake(ScreenWidth/2+20, yPosition, ScreenWidth/2-20, 20);
            }
            UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setFont:[UIFont systemFontOfSize:11]];
            NSString *labelStr = [NSString stringWithFormat:@"%@:%@",[detailItemDic objectForKey:@"CN_NAME"],[detailItemDic objectForKey:@"CURRENT_VALUE"]];
            [label setText:labelStr];
            [cell.contentView addSubview:label];
        }
        UIView  *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0,yPosition+19, ScreenWidth, 0.5)];
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *dic = (NSMutableDictionary *)[batteryList objectAtIndex:section];
    NSString *isOpen = [dic objectForKey:@"open"];
    if([@"0" isEqualToString:isOpen]){
        return 0;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tView{
    return batteryList.count;
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
    [self getXudianchiDataWithRegNum:_regNO testTypeNum:@"1" staName:@"" sysName:@"" assetsNum:@"" articleNum:@"" startTime:[PowerUtils getFirstDay:@"yyyy-MM-dd-HH:mm:ss"] stopTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    return _reloading;
}

@end
