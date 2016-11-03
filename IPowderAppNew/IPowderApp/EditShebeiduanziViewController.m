//
//  EditShebeiduanziViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "EditShebeiduanziViewController.h"
#import "PowerDataService.h"
@interface EditShebeiduanziViewController ()

@end

@implementation EditShebeiduanziViewController {
    UITableView *connectorTable;
    NSArray *connectorList;
    NSArray *inoutTypeArray;
    EditDuanziDetailViewController *editDuanziCtrl;
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
    // Do any additional setup after loading the view.
    inoutTypeArray = [NSArray arrayWithObjects:@"输入",@"输出",@"输入输出",nil];
    connectorTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40) style:UITableViewStylePlain];
    connectorTable.delegate = self;
    connectorTable.dataSource = self;
    [connectorTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    connectorTable.bounces = NO;
    [self.view addSubview:connectorTable];
}

-(void)setDeviceDic:(NSDictionary *)deviceDic{
    if(![_deviceDic isEqual:deviceDic]) {
        _deviceDic = deviceDic;
        [self getDuanzixinxi];
    }
}

//获取端子信息
-(void)getDuanzixinxi {
    RequestCompleteBlock block = ^(id result) {
        connectorList = (NSArray *)result;
        [connectorTable reloadData];
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getDeviceConnectorInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devNum:[_deviceDic objectForKey:@"DEV_NUM"]  completeBlock:block loadingView:connectorTable showHUD:YES];
}

#pragma mark ----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [connectorList objectAtIndex:indexPath.row];
    editDuanziCtrl = [[EditDuanziDetailViewController alloc]init];
    editDuanziCtrl.duanziDic = dic;
    editDuanziCtrl.stationNum = _stationNum;
    editDuanziCtrl.deviceDic = _deviceDic;
    BaseNavigationController *rootController = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController pushViewController:editDuanziCtrl animated:YES];
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

//生成json字典
-(NSMutableDictionary *)createJsonDictonry{
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
    [jsonDic setValue:[_deviceDic objectForKey:@"DEV_NUM"] forKey:@"PrimaryKeyData"];
    
    NSMutableArray *extendArray  = [[NSMutableArray alloc]init];
    
    NSDictionary *editedDuanziDic;
    if( editDuanziCtrl!=nil ) {
        editedDuanziDic  = [editDuanziCtrl getEditedDuanziDic];
    }
    
    for (NSDictionary *dic in connectorList) {
        if(editedDuanziDic != nil && [[editedDuanziDic objectForKey:@"CONTR_NUM"] isEqualToString:[dic objectForKey:@"CONTR_NUM"]]) {
            [extendArray addObject:editedDuanziDic];
        }else {
            [extendArray addObject:dic];
        }
    }
    
    [jsonDic setValue:extendArray forKey:@"ConnectorData"];
    return jsonDic;
}

@end
