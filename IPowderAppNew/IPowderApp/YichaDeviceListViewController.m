//
//  YichaDeviceListViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "YichaDeviceListViewController.h"
#import "YichaDeviceTableCell.h"
#import "DeviceReportViewController.h"
#import "BaseNavigationController.h"
@interface YichaDeviceListViewController ()

@end

@implementation YichaDeviceListViewController {
    NSMutableArray *yichaDeviceList;
    UITableView *yichaTable;
    UIGlossyButton *viewReportBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"已查";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    yichaDeviceList = [[NSMutableArray alloc]init];
    
    yichaTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80) style:UITableViewStylePlain];
    yichaTable.delegate = self;
    yichaTable.dataSource = self;
    yichaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    yichaTable.bounces = NO;
    [self.view addSubview:yichaTable];
    
    
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80, ScreenWidth, 40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    viewReportBtn = [[UIGlossyButton alloc]init];
    viewReportBtn.frame = CGRectMake(5, 5,ScreenWidth-10, 30);
    [viewReportBtn setTitle:@"查看巡检结果" forState:UIControlStateNormal];
    [viewReportBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [viewReportBtn addTarget:self action:@selector(viewReportHandler) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:viewReportBtn];
    
    [self.view addSubview:operationView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getYichaDeviceList];
}

//获取本地存储的位差的设备列表
-(void)getYichaDeviceList {
    if(_stationNum == nil )
        return;
    [yichaDeviceList removeAllObjects];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *localDeviceList = [userDefaults objectForKey:_stationNum];
    for (NSDictionary *dic in localDeviceList) {
        if([[dic objectForKey:@"checked"] isEqualToString:@"YES"]) {
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [yichaDeviceList addObject:newDic];
        }
    }
    
    [yichaTable reloadData];
    
    if(_delegate && [_delegate respondsToSelector:@selector(setYichaDeviceAmount:)]) {
        
        [_delegate setYichaDeviceAmount:[NSString stringWithFormat:@"%i",yichaDeviceList.count]];
    }
    
    if(yichaDeviceList.count == 0 ) {
        viewReportBtn.enabled = NO;
        UIView *noDataView = [yichaTable viewWithTag:10000];
        if(noDataView == nil ) {
            noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,100,50)];
            noDataView.backgroundColor = [UIColor clearColor];
            noDataView.tag = 10000;
            noDataView.center = CGPointMake(yichaTable.width/2,yichaTable.height/2);
            UILabel *noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
            noDataLabel.textAlignment = NSTextAlignmentCenter;
            noDataLabel.text = @"暂无数据";
            noDataLabel.backgroundColor = [UIColor clearColor];
            
            [noDataView addSubview:noDataLabel];
            [yichaTable addSubview:noDataView];
        }
        [yichaTable bringSubviewToFront:noDataView];
    }else {
        viewReportBtn.enabled = YES;
        UIView *noDataView = [yichaTable viewWithTag:10000];
        if(noDataView!=nil){
            [noDataView removeFromSuperview];
        }
    }
}

-(void)setStationNum:(NSString *)stationNum {
    if(![_stationNum isEqualToString:stationNum] ) {
        _stationNum = stationNum;
    }
}

#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [yichaDeviceList objectAtIndex:indexPath.row];
    if(_delegate && [_delegate respondsToSelector:@selector(popEditDeivceController:)]) {
        [_delegate popEditDeivceController:dic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [yichaDeviceList objectAtIndex:indexPath.row];
    return [YichaDeviceTableCell caculateCellHeight:dic];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return yichaDeviceList.count;
}

- (YichaDeviceTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    YichaDeviceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell==nil) {
        cell = [[YichaDeviceTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    //避免出现重叠现象
    else {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    NSDictionary *dic = [yichaDeviceList objectAtIndex:indexPath.row];
    cell.dic = dic;
    return cell;
}

//弹出报告视图
-(void)viewReportHandler {
    DeviceReportViewController *reportCtrl = [[DeviceReportViewController alloc]init];
    BaseNavigationController *rootController = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    reportCtrl.stationNum = _stationNum;
    [rootController pushViewController:reportCtrl animated:YES];
}

@end
