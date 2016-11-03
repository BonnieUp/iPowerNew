//
//  RunTimeWarningDataViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "RunTimeWarningDataViewController.h"
#import "PowerDataService.h"
@interface RunTimeWarningDataViewController ()

@end

@implementation RunTimeWarningDataViewController{
    int waittime;
    //定时器
    NSTimer *timer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"运行数据";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    runtimeDataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-START_PROCESS_TASK-50) style:UITableViewStylePlain];
    runtimeDataTable.delegate = self;
    runtimeDataTable.dataSource = self;
    [runtimeDataTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:runtimeDataTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setWarningDic:(NSDictionary *)warningDic {
    if(![_warningDic isEqual:warningDic]) {
        _warningDic = warningDic;
        [self getWarningData];
    }
}

-(void)setNetunit_id:(NSString *)netunit_id {
    if(![_netunit_id isEqual:netunit_id]) {
        _netunit_id = netunit_id;
        [self getWarningData];
    }
}



//获取告警实时数据
-(void)getWarningData {
    if(_warningDic == nil || _netunit_id == nil)
        return;
    RequestCompleteBlock block = ^(id result) {
        _warningInfoList = (NSArray *)[result objectForKey:@"runtimeInfo"];
        waittime = [[result objectForKey:@"waittime"] integerValue];
        
        
        if(waittime>0){
            timer = [NSTimer scheduledTimerWithTimeInterval:waittime target:self selector:@selector(timerHandler) userInfo:nil repeats:NO];
//                NSLog(@"%i",waittime);
        }
        [runtimeDataTable reloadData];
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getRunTimeAlarmDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] nuId:_netunit_id dataType:@"1" completeBlock:block loadingView:nil showHUD:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
}

-(void)timerHandler{
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
    [self getWarningData];
}

#pragma mark --------tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _warningInfoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
        //添加titlelabel
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.tag = 100;
        [cell.contentView addSubview:titleLabel];
        
        //添加描述
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 100, 20)];
        descLabel.font = [UIFont systemFontOfSize:12];
        descLabel.tag = 101;
        [cell.contentView addSubview:descLabel];
        
        //添加数值
        UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 25, 70, 20)];
        valueLabel.font = [UIFont systemFontOfSize:12];
        valueLabel.textColor = [UIColor redColor];
        valueLabel.tag = 102;
        [cell.contentView addSubview:valueLabel];
        
        //添加时间label
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 25, 100, 20)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.tag = 103;
        [cell.contentView addSubview:timeLabel];
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, ScreenWidth,0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [_warningInfoList objectAtIndex:indexPath.row];
    //title
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:100];
    titleLabel.text = [PowerUtils getMappingValue:dic key:@"pointName" nullStr:@"--"];
    
    //desc
    UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:101];
    descLabel.text = [NSString stringWithFormat:@"[%@]%@",[dic objectForKey:@"POINT_PORT_TYPE_ID"],[dic objectForKey:@"POINT_PORT_TYPE_NAME"]];
    
    //value
    UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:102];
    valueLabel.text = [PowerUtils getMappingValue:dic key:@"pointValue" nullStr:@"--"];
    
    //time
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:103];
    timeLabel.text = [PowerUtils getMappingValue:dic key:@"sampleTime" nullStr:@"--"];
    
    return cell;
}

@end
