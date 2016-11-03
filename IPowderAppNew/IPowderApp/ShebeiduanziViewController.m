//
//  ShebeiduanziViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-8.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "ShebeiduanziViewController.h"
#import "PowerDataService.h"
#import "DuanziDetailViewViewController.h"
@interface ShebeiduanziViewController ()

@end

@implementation ShebeiduanziViewController {
    UITableView *connectorTable;
    NSArray *connectorList;
    NSArray *inoutTypeArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设备端子";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    inoutTypeArray = [NSArray arrayWithObjects:@"输入",@"输出",@"输入输出",nil];
    // Do any additional setup after loading the view.
    connectorTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40) style:UITableViewStylePlain];
    connectorTable.delegate = self;
    connectorTable.dataSource = self;
    [connectorTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    connectorTable.bounces = NO;
    [self.view addSubview:connectorTable];
}

//获取设备端子
-(void)getShebeiduanzi {
    RequestCompleteBlock block = ^(id result) {
//        if(result == nil ) {
//            UILabel *noneProLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (connectorTable.height-30)/2,ScreenWidth, 30)];
//            noneProLabel.text = @"无设备端子数据";
//            noneProLabel.textAlignment = NSTextAlignmentCenter;
//            noneProLabel.backgroundColor = [UIColor clearColor];
//            [connectorTable addSubview:noneProLabel];
//        }
        connectorList = (NSArray *)result;
        [connectorTable reloadData];
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getDeviceConnectorInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devNum:[_deviceDic objectForKey:@"DEV_NUM"]  completeBlock:block loadingView:connectorTable showHUD:YES];
}

-(void)setDeviceDic:(NSDictionary *)deviceDic{
    if(![_deviceDic isEqual:deviceDic]) {
        _deviceDic = deviceDic;
        [self getShebeiduanzi];
    }
}

#pragma mark ----uitableview delegate
#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //delegate响应弹出二级任务列表
    if(_delegate && [_delegate respondsToSelector:@selector(popDuanziDetailWith:)]) {
        NSDictionary *dic = [connectorList objectAtIndex:indexPath.row];
        [_delegate popDuanziDetailWith:dic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return connectorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //行列label
        UILabel *columnRowLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
        columnRowLabel.tag = 100;
        columnRowLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:columnRowLabel];
        
        //位置label
        UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(60,0, 50, 40)];
        positionLabel.tag = 101;
        positionLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:positionLabel];
        
        //输入输出label
        UILabel *inoutTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 70, 40)];
        inoutTypeLabel.tag = 102;
        inoutTypeLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:inoutTypeLabel];
        
        //端子类型label
        UILabel *duanziTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 0, 90, 40)];
        duanziTypeLabel.tag = 103;
        duanziTypeLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:duanziTypeLabel];
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
        
    }
    
    NSDictionary *dic = [connectorList objectAtIndex:indexPath.row];
    
    UILabel *columnRowLabel = (UILabel *)[cell.contentView viewWithTag:100];
    columnRowLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"CONTR_ROW"],[dic objectForKey:@"CONTR_COLUMN"]];
    
    UILabel *positionLabel = (UILabel *)[cell.contentView viewWithTag:101];
    NSString *position = [dic objectForKey:@"CONTR_POSITION"];
    if([position isEqualToString:@"A"])
        positionLabel.text = @"前";
    if([position isEqualToString:@"B"])
        positionLabel.text = @"后";
    

    UILabel *inoutTypeLabel = (UILabel *)[cell.contentView viewWithTag:102];
    NSString *inout = [dic objectForKey:@"INOUT_TYPE"];
    inoutTypeLabel.text = [inoutTypeArray objectAtIndex:[inout integerValue]];
    
    UILabel *duanziTypeLabel = (UILabel *)[cell.contentView viewWithTag:103];
    duanziTypeLabel.text = [dic objectForKey:@"CONTR_TYPE"];
    
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    return cell;
}

@end
