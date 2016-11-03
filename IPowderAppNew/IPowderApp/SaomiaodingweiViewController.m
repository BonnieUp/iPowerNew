//
//  SaomiaodingweiViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-19.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "SaomiaodingweiViewController.h"
#import "SiteInfoCell.h"
#import "PowerDataService.h"
@interface SaomiaodingweiViewController ()

@end

@implementation SaomiaodingweiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"扫描定位"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //初始化siteArray
    _siteArray = [[NSArray alloc]init];
    
    //添加站点信息
    siteTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    siteTable.delegate = self;
    siteTable.dataSource = self;
    siteTable.bounces = NO;
    [siteTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:siteTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setResNo:(NSString *)resNo{
    if(![_resNo isEqualToString:resNo]) {
        _resNo = resNo;
        [self getSiteWithRes:_resNo];
    }
}


-(void)getSiteWithRes:(NSString *)res {
    RequestCompleteBlock block = ^(id result) {
        _siteArray = result;
        [siteTable reloadData];
        
        if(_siteArray.count>0 ){
            //将选择的站点信息保存到本地
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *siteInfoDic = [_siteArray objectAtIndex:0];
            [userDefaults setObject:siteInfoDic forKey:@"siteDic"];
            [userDefaults synchronize];
            
            //发送通知，选择站点信息已更改
            [[NSNotificationCenter defaultCenter] postNotificationName:KSiteChanged object:res];
        }
    };
    PowerDataService *service = [[PowerDataService alloc]init];
    [service getSiteInfoWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] lng:nil lat:nil resNo:res completeBlock:block loadingView:self.view showHUD:YES];
}

#pragma mark--- tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //将选择的站点信息保存到本地
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *siteInfoDic = [_siteArray objectAtIndex:indexPath.row];
    [userDefaults setObject:siteInfoDic forKey:@"siteDic"];
    [userDefaults synchronize];
    
    //发送通知，选择站点信息已更改
    [[NSNotificationCenter defaultCenter] postNotificationName:KSiteChanged object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _siteArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"siteCell";
    SiteInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[SiteInfoCell alloc]init];
        
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [_siteArray objectAtIndex:indexPath.row];
    cell.infoDic = dic;
    
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
