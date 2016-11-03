//
//  YiwanchengDetailView.m
//  i动力
//
//  Created by 王敏 on 16/1/8.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "YiwanchengDetailView.h"
#import "PowerDataService.h"

@implementation YiwanchengDetailView{
    NSString *planNum;
    //当前选项卡索引
    NSUInteger selectedTab;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    checkDataList = [[NSMutableArray alloc]init];
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
    
    UIButton *tab = [_tabs objectAtIndex:3];
    [tab setSelected:YES];
    selectedTab = 3;
    UIView *bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, _menuHeight- 1.0, ScreenWidth, 1.0)];
    //    bottomHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    bottomHeaderView.backgroundColor = [UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1];
    [self.view addSubview:bottomHeaderView];
}

-(void)selectTab:(id)sender{
    selectedTab = [_tabs indexOfObject:sender];
    if(selectedTab==3)
        return;
    NSString *selectStr = [NSString stringWithFormat:@"%lu",(unsigned long)selectedTab];
    //发送改变选项卡的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"donglihechachangetab" object:selectStr];
    
}

-(void)setPlanNum:(NSString *)num{
        planNum = num;
        RequestCompleteBlock block = ^(id result) {
            [checkDataList removeAllObjects];
            NSArray *oriArray = (NSArray *)result;
            for(int i=0;i<oriArray.count;i++){
                NSDictionary *oriDic = (NSDictionary *)[oriArray objectAtIndex:i];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:oriDic];
                //开关状态,默认关闭
                [dic setValue:@"0" forKey:@"open"];
                [dic setValue:nil forKey:@"detailDic"];
                [checkDataList addObject:dic];
            }
            [tableView reloadData];
            _reloading = NO;
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
        };
        PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
        [dataService getPrCheckStationDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] checkStatusNum:@"4" planNum:planNum completeBlock:block loadingView:self.view showHUD:YES];
}

#pragma mark ----tableview delegate
-(CGFloat)tableView:(UITableView *)tView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}


- (CGFloat)tableView:(UITableView *)tView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260.0f;
}

-(UIView *)tableView:(UITableView *)tView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    view.alpha = 1;
    NSDictionary *dic = (NSDictionary *)[checkDataList objectAtIndex:section];
    
    //区局label
    UILabel *qujuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-10, 25)];
    qujuLabel.text = [dic objectForKey:@"STATION_NAME"];
    qujuLabel.font = [UIFont boldSystemFontOfSize:13];
    [view addSubview:qujuLabel];
    
    //时间label
    UILabel *shijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, qujuLabel.bottom, ScreenWidth-10, 20)];
    shijianLabel.text = [NSString stringWithFormat:@"开始时间:%@  完成时间:%@",[dic objectForKey:@"CHECKED_START_TIME"],[dic objectForKey:@"CHECKED_STOP_TIME"]];
    shijianLabel.font = [UIFont systemFontOfSize:11];
    shijianLabel.textColor = [UIColor colorWithRed:49/255.0 green:167/255.0 blue:233/255.0 alpha:1];
    [view addSubview:shijianLabel];
    
    //分割线
    UIView  *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0,49, ScreenWidth, 0.5)];
    seperateView.alpha = 0.8;
    seperateView.backgroundColor = [UIColor grayColor];
    [view addSubview:seperateView];
    
    //按钮
    UIButton *zhankaiBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-30, 10, 30,30)];
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
    NSMutableDictionary *dic = (NSMutableDictionary *)[checkDataList objectAtIndex:section];
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
            [dataService getPrCheckStationDetailWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] recordNum:[dic objectForKey:@"RECORD_NUM"] isEdit:@"0" completeBlock:block loadingView:tableView showHUD:YES];
            
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
    NSString *iden = @"cellyiwancheng";
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:iden];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    NSMutableDictionary *dic = [checkDataList objectAtIndex:indexPath.section];
    NSMutableDictionary *detailDic = [dic objectForKey:@"detailDic"];
    if(detailDic!=nil){
        NSArray *commonInfoArray = [detailDic objectForKey:@"CommonInfoList"];
        NSArray *extendInfoArray = [detailDic objectForKey:@"ExtenderInfoList"];
        NSString *chouchashu;
        NSString *chouchacuowushu;
        NSString *donglixitongwentishu;
        NSString *shebeileixingwentishu;
        NSString *zichanbianhaowentishu;
        NSString *shiwubianhaowentishu;
        NSString *touchanriqiwentishu;
        NSString *rongliangwentishu;
        NSString *xinghaowentishu;
        NSString *changjiawentishu;
        NSString *shengchanriqiwentishu;
        NSString *fangjianwentishu;
        NSString *xitongkuozhanshuxingchouchashu;
        NSString *xitongkuozhanshuxingcuowushu;
        NSString *shebeikuozhanshuxingchouchashu;
        NSString *shebeikuozhanshuxingcuowushu;
        NSString *shijipeitongrenyuan;
        NSString *wentimiaoshu;
        for(NSDictionary *commonDic in commonInfoArray){
            //抽查数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"1"]){
                chouchashu = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //抽查错误数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"2"]){
                chouchacuowushu = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //动力系统问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"3"]){
                donglixitongwentishu = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //设备类型问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"4"]){
                shebeileixingwentishu = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //资产编号问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"6"]){
                zichanbianhaowentishu = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //实物编号问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"7"]){
                shiwubianhaowentishu = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //投产日期问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"8"]){
               touchanriqiwentishu  = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //容量问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"9"]){
                rongliangwentishu  = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //型号问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"10"]){
                xinghaowentishu  = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //厂家问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"11"]){
                changjiawentishu  = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //生产日期问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"12"]){
                shengchanriqiwentishu  = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //房间问题数
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"5"]){
                fangjianwentishu  = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //实际陪同人员
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"14"]){
                shijipeitongrenyuan  = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
            //问题描述
            if([[[commonDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"13"]){
                wentimiaoshu  = [commonDic objectForKey:@"CURRENT_VALUE"];
            }
        }
        for(NSDictionary *extendDic in extendInfoArray){
            //系统扩展属性抽查数
            if([[[extendDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"16"]){
                xitongkuozhanshuxingchouchashu  = [extendDic objectForKey:@"CURRENT_VALUE"];
            }
            //系统扩展属性错误数
            if([[[extendDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"17"]){
                xitongkuozhanshuxingcuowushu  = [extendDic objectForKey:@"CURRENT_VALUE"];
            }
            //设备扩展属性抽查数
            if([[[extendDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"18"]){
                shebeikuozhanshuxingchouchashu  = [extendDic objectForKey:@"CURRENT_VALUE"];
            }
            //设备扩展属性错误数
            if([[[extendDic objectForKey:@"FIELD_NUM"] stringValue] isEqualToString:@"19"]){
                shebeikuozhanshuxingcuowushu  = [extendDic objectForKey:@"CURRENT_VALUE"];
            }
        }
        //common property
        UILabel *chouchashuLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, ScreenWidth/2-5, 20)];
        chouchashuLabel.font = [UIFont systemFontOfSize:11];
        chouchashuLabel.text = [NSString stringWithFormat:@"抽查数:%@",chouchashu];
        [cell.contentView addSubview:chouchashuLabel];
        
        UILabel *chouchacuowushuLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2,0 , ScreenWidth/2-5, 20)];
        chouchacuowushuLabel.font = [UIFont systemFontOfSize:11];
        chouchacuowushuLabel.text = [NSString stringWithFormat:@"抽查错误数:%@",chouchacuowushu];
        [cell.contentView addSubview:chouchacuowushuLabel];
        
        UILabel *gonggongshuxingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, chouchacuowushuLabel.bottom, ScreenWidth-5, 20)];
        gonggongshuxingLabel.font = [UIFont boldSystemFontOfSize:12];
        gonggongshuxingLabel.text = @"公共属性出错数:";
        [cell.contentView addSubview:gonggongshuxingLabel];
        
        UILabel *donglixitongchucuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, gonggongshuxingLabel.bottom, ScreenWidth/2-5, 20)];
        donglixitongchucuoLabel.font = [UIFont systemFontOfSize:11];
        donglixitongchucuoLabel.text = [NSString stringWithFormat:@"动力系统问题数:%@",donglixitongwentishu];
        [cell.contentView addSubview:donglixitongchucuoLabel];
        
        UILabel *shebeileixingwentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, gonggongshuxingLabel.bottom, ScreenWidth/2-5, 20)];
        shebeileixingwentiLabel.font = [UIFont systemFontOfSize:11];
        shebeileixingwentiLabel.text = [NSString stringWithFormat:@"设备类型问题数:%@",shebeileixingwentishu];
        [cell.contentView addSubview:shebeileixingwentiLabel];
        
        UILabel *zichanbianhaowentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, shebeileixingwentiLabel.bottom, ScreenWidth/2-5, 20)];
        zichanbianhaowentiLabel.font = [UIFont systemFontOfSize:11];
        zichanbianhaowentiLabel.text = [NSString stringWithFormat:@"资产编号问题数:%@",zichanbianhaowentishu];
        [cell.contentView addSubview:zichanbianhaowentiLabel];
        
        UILabel *shiwubianhaowentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, shebeileixingwentiLabel.bottom, ScreenWidth/2-5, 20)];
        shiwubianhaowentiLabel.font = [UIFont systemFontOfSize:11];
        shiwubianhaowentiLabel.text = [NSString stringWithFormat:@"实物编号问题数:%@",shiwubianhaowentishu];
        [cell.contentView addSubview:shiwubianhaowentiLabel];
        
        UILabel *touchanriqiwentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, shiwubianhaowentiLabel.bottom, ScreenWidth/2-5, 20)];
        touchanriqiwentiLabel.font = [UIFont systemFontOfSize:11];
        touchanriqiwentiLabel.text = [NSString stringWithFormat:@"投产日期问题数:%@",touchanriqiwentishu];
        [cell.contentView addSubview:touchanriqiwentiLabel];
        
        UILabel *rongliangwentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, shiwubianhaowentiLabel.bottom, ScreenWidth/2-5, 20)];
        rongliangwentiLabel.font = [UIFont systemFontOfSize:11];
        rongliangwentiLabel.text = [NSString stringWithFormat:@"容量问题数:%@",rongliangwentishu];
        [cell.contentView addSubview:rongliangwentiLabel];
        
        UILabel *xinghaowentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, rongliangwentiLabel.bottom, ScreenWidth/2-5, 20)];
        xinghaowentiLabel.font = [UIFont systemFontOfSize:11];
        xinghaowentiLabel.text = [NSString stringWithFormat:@"型号问题数:%@",xinghaowentishu];
        [cell.contentView addSubview:xinghaowentiLabel];
        
        UILabel *changjiawentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, rongliangwentiLabel.bottom, ScreenWidth/2-5, 20)];
        changjiawentiLabel.font = [UIFont systemFontOfSize:11];
        changjiawentiLabel.text = [NSString stringWithFormat:@"厂家问题数:%@",changjiawentishu];
        [cell.contentView addSubview:changjiawentiLabel];
        
        UILabel *shengchanriqiwentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, changjiawentiLabel.bottom, ScreenWidth/2-5, 20)];
        shengchanriqiwentiLabel.font = [UIFont systemFontOfSize:11];
        shengchanriqiwentiLabel.text = [NSString stringWithFormat:@"生产日期问题数:%@",shengchanriqiwentishu];
        [cell.contentView addSubview:shengchanriqiwentiLabel];
        
        UILabel *fangjianwentiLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, changjiawentiLabel.bottom, ScreenWidth/2-5, 20)];
        fangjianwentiLabel.font = [UIFont systemFontOfSize:11];
        fangjianwentiLabel.text = [NSString stringWithFormat:@"房间问题数:%@",fangjianwentishu];
        [cell.contentView addSubview:fangjianwentiLabel];
        
        //extend property
        UILabel *kuozhanshuxingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, fangjianwentiLabel.bottom, ScreenWidth-5, 20)];
        kuozhanshuxingLabel.font = [UIFont boldSystemFontOfSize:12];
        kuozhanshuxingLabel.text = @"扩展属性出错数:";
        [cell.contentView addSubview:kuozhanshuxingLabel];
        
        UILabel *xitongkuozhanshuxingchouchaLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kuozhanshuxingLabel.bottom, ScreenWidth/2-5, 20)];
        xitongkuozhanshuxingchouchaLabel.font = [UIFont systemFontOfSize:11];
        xitongkuozhanshuxingchouchaLabel.text = [NSString stringWithFormat:@"系统扩展属性抽查数:%@",xitongkuozhanshuxingchouchashu];
        [cell.contentView addSubview:xitongkuozhanshuxingchouchaLabel];
        
        UILabel *xitongkuozhanshuxingcuowuLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, kuozhanshuxingLabel.bottom, ScreenWidth/2-5, 20)];
        xitongkuozhanshuxingcuowuLabel.font = [UIFont systemFontOfSize:11];
        xitongkuozhanshuxingcuowuLabel.text = [NSString stringWithFormat:@"系统扩展属性错误数:%@",xitongkuozhanshuxingcuowushu];
        [cell.contentView addSubview:xitongkuozhanshuxingcuowuLabel];
        
        UILabel *shebeikuozhanshuxingchouchaLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, xitongkuozhanshuxingcuowuLabel.bottom, ScreenWidth/2-5, 20)];
        shebeikuozhanshuxingchouchaLabel.font = [UIFont systemFontOfSize:11];
        shebeikuozhanshuxingchouchaLabel.text = [NSString stringWithFormat:@"设备扩展属性抽查数:%@",shebeikuozhanshuxingchouchashu];
        [cell.contentView addSubview:shebeikuozhanshuxingchouchaLabel];
        
        UILabel *shebeikuozhanshuxingcuowuLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-5, xitongkuozhanshuxingcuowuLabel.bottom, ScreenWidth/2-5, 20)];
        shebeikuozhanshuxingcuowuLabel.font = [UIFont systemFontOfSize:11];
        shebeikuozhanshuxingcuowuLabel.text = [NSString stringWithFormat:@"设备扩展属性错误数:%@",shebeikuozhanshuxingcuowushu];
        [cell.contentView addSubview:shebeikuozhanshuxingcuowuLabel];
        
        UILabel *peitongLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, shebeikuozhanshuxingcuowuLabel.bottom, ScreenWidth-5, 20)];
        peitongLabel.font = [UIFont boldSystemFontOfSize:12];
        peitongLabel.text = [NSString stringWithFormat:@"实际陪同人员:%@",shijipeitongrenyuan];
        [cell.contentView addSubview:peitongLabel];
        
        UILabel *miaoshuLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, peitongLabel.bottom, ScreenWidth-5, 20)];
        miaoshuLabel.font = [UIFont boldSystemFontOfSize:12];
        miaoshuLabel.text = [NSString stringWithFormat:@"问题描述:%@",wentimiaoshu];
        [cell.contentView addSubview:miaoshuLabel];
        
        
        UIView  *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0,259, ScreenWidth, 0.5)];
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *dic = (NSMutableDictionary *)[checkDataList objectAtIndex:section];
    NSString *isOpen = [dic objectForKey:@"open"];
    if([@"0" isEqualToString:isOpen]){
        return 0;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tView{
    return checkDataList.count;
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

@end
