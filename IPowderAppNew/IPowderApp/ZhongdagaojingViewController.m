//
//  ZhongdagaojingViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "ZhongdagaojingViewController.h"
#import "PowerDataService.h"
#import "BaseNavigationController.h"
@interface ZhongdagaojingViewController ()

@end

@implementation ZhongdagaojingViewController {
    UITableView *gaojingTable;
    NSArray *gaojingList;
    NSMutableArray *gaojingOriList;
    BOOL isComplete;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"重大告警";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isComplete = NO;
    gaojingTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80)];
    gaojingTable.bounces = NO;
    gaojingTable.dataSource = self;
    gaojingTable.delegate  = self;
    gaojingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:gaojingTable];
   
    [self getFatalAlarmData];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if(isComplete == NO ) {
//         [self getFatalAlarmData];
//        isComplete = YES;
//    }
    [self getFatalAlarmData];
}

//获取重大告警数据
-(void)getFatalAlarmData {
    RequestCompleteBlock block = ^(id result) {
        gaojingList = (NSArray *)result;
        int gaojingAmount = 0;
        [gaojingTable reloadData];
        
        for (NSDictionary *dic in result) {
            gaojingAmount+=[[dic objectForKey:@"ROWCOUNT"] intValue];
        }
        if(_delegate && [_delegate respondsToSelector:@selector(setZhongdagaojingAmount:)]) {
            [_delegate setZhongdagaojingAmount:[NSString stringWithFormat:@"%i",gaojingAmount]];
        }
    };
    PowerDataService *dataService = [[PowerDataService alloc]init];
    [dataService getFatalAlarmGroupDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:gaojingTable showHUD:YES];
}


#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [gaojingList objectAtIndex:indexPath.row];
    BaseNavigationController *rootCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    ZhongdagaojingListViewController *listCtrl = [[ZhongdagaojingListViewController alloc]init];
    listCtrl.siteDic = dic;
    listCtrl.siteList = _siteList;
    listCtrl.gaojingjibieList = _gaojingjibieList;
    listCtrl.deviceClassList = _deviceClassList;
    [rootCtrl pushViewController:listCtrl animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //添加名称
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,ScreenWidth-70, 30)];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.tag = 100;
        [cell.contentView addSubview:titleLabel];
        
        //添加数量
        UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-70, 5,40, 30)];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.font = [UIFont systemFontOfSize:12];
        amountLabel.tag = 102;
        [cell.contentView addSubview:amountLabel];
        
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [gaojingList objectAtIndex:indexPath.row];
    //设置title
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:100];
    titleLabel.text = [dic objectForKey:@"FATAL_ALARM_RULE_NAME"];
    //设置数量
    UILabel *amountLabel = (UILabel *)[cell.contentView viewWithTag:102];
    amountLabel.text = [dic objectForKey:@"ROWCOUNT"];
    
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return gaojingList.count;
}

-(void)searchGaojingWithFilter:(NSDictionary *)dic {
    BaseNavigationController *rootCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    ZhongdagaojingListViewController *listCtrl = [[ZhongdagaojingListViewController alloc]init];
    listCtrl.filterDic = dic;
    listCtrl.siteList = _siteList;
    listCtrl.gaojingjibieList = _gaojingjibieList;
    listCtrl.deviceClassList = _deviceClassList;
    [rootCtrl pushViewController:listCtrl animated:YES];
}

@end
