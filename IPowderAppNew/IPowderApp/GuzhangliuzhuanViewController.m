//
//  GuzhangliuzhuanViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GuzhangliuzhuanViewController.h"
#import "PowerDataService.h"

@interface GuzhangliuzhuanViewController ()

@end

@implementation GuzhangliuzhuanViewController {
    UITableView *liuzhuanTable;
    NSArray *liuzhuanList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"流转";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    liuzhuanTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40)];
    liuzhuanTable.bounces = NO;
    liuzhuanTable.dataSource = self;
    liuzhuanTable.delegate  = self;
    liuzhuanTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:liuzhuanTable];
}

#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [liuzhuanList objectAtIndex:indexPath.row];
    NSString *contentStr = [NSString stringWithFormat:@"处理内容:%@",[dic objectForKey:@"DEAL_DESC"]];
    CGSize positionSize = [PowerUtils getLabelSizeWithText:contentStr width:ScreenWidth-20 font:[UIFont systemFontOfSize:12]];
    return 86+positionSize.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        //添加内容
        UILabel *neirongLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,ScreenWidth-20, 40)];
        neirongLabel.numberOfLines = 3;
        neirongLabel.font = [UIFont systemFontOfSize:12];
        neirongLabel.tag = 100;
        [cell.contentView addSubview:neirongLabel];
        
        //添加动作
        UILabel *dongzuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,45,ScreenWidth-20, 20)];
        dongzuoLabel.textAlignment = NSTextAlignmentLeft;
        dongzuoLabel.font = [UIFont systemFontOfSize:12];
        dongzuoLabel.tag = 102;
        [cell.contentView addSubview:dongzuoLabel];
        
        //处理部门
        UILabel *chulibumenLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, ScreenWidth-20, 20)];
        chulibumenLabel.textAlignment = NSTextAlignmentLeft;
        chulibumenLabel.font = [UIFont systemFontOfSize:12];
        chulibumenLabel.tag = 103;
        [cell.contentView addSubview:chulibumenLabel];
        
        //处理科室
        UILabel *chulikeshiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, ScreenWidth-20, 20)];
        chulikeshiLabel.textAlignment = NSTextAlignmentLeft;
        chulikeshiLabel.font = [UIFont systemFontOfSize:12];
        chulikeshiLabel.tag = 104;
        [cell.contentView addSubview:chulikeshiLabel];
        
        //处理人
        UILabel *chulirenLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, (ScreenWidth-30)/2, 20)];
        chulirenLabel.textAlignment = NSTextAlignmentLeft;
        chulirenLabel.font = [UIFont systemFontOfSize:12];
        chulirenLabel.tag = 105;
        [cell.contentView addSubview:chulirenLabel];
        //处理时间
        UILabel *chulishijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, (ScreenWidth-30)/2, 20)];
        chulishijianLabel.textAlignment = NSTextAlignmentLeft;
        chulishijianLabel.font = [UIFont systemFontOfSize:12];
        chulishijianLabel.tag = 106;
        [cell.contentView addSubview:chulishijianLabel];
        //添加分割线
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
        seperateView.tag  = 200;
        seperateView.alpha = 0.8;
        seperateView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:seperateView];
    }
    NSDictionary *dic = [liuzhuanList objectAtIndex:indexPath.row];
    //设置内容
    UILabel *neirongLabel = (UILabel *)[cell.contentView viewWithTag:100];
    neirongLabel.text = [NSString stringWithFormat:@"处理内容:%@",[dic objectForKey:@"DEAL_DESC"]];
    
    //设置动作
    UILabel *dongzuoLabel = (UILabel *)[cell.contentView viewWithTag:102];
    dongzuoLabel.text = [NSString stringWithFormat:@"动作:%@",[dic objectForKey:@"DEAL_ACTION_TYPE_NAME"]];
    
    //处理部门
    UILabel *chulibumenLabel = (UILabel *)[cell.contentView viewWithTag:103];
    chulibumenLabel.text = [NSString stringWithFormat:@"处理部门:%@",[dic objectForKey:@"DEAL_DEPARTMENT_NAME"]];
    
    //处理科室
    UILabel *chulikeshiLabel = (UILabel *)[cell.contentView viewWithTag:104];
    chulikeshiLabel.text = [NSString stringWithFormat:@"处理科室:%@",[dic objectForKey:@"DEAL_GROUP_NAME"]];
    
    //处理人
    UILabel *chulirenLabel = (UILabel *)[cell.contentView viewWithTag:105];
    chulirenLabel.text = [NSString stringWithFormat:@"处理人:%@",[dic objectForKey:@"DEAL_MAN"]];
    
    //处理时间
    UILabel *chulishijianLabel = (UILabel *)[cell.contentView viewWithTag:106];
    chulishijianLabel.text = [NSString stringWithFormat:@"处理时间:%@",[dic objectForKey:@"DEAL_TIME"]];
    
    //如果没有数据，隐藏分割线
    UIView *seperateView = [cell.contentView viewWithTag:200];
    if(dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    //重置位置
    CGSize positionSize = [PowerUtils getLabelSizeWithText:neirongLabel.text width:ScreenWidth-20 font:neirongLabel.font];
    neirongLabel.frame = CGRectMake(10, 5, ScreenWidth-20, positionSize.height);
    dongzuoLabel.frame = CGRectMake(10, neirongLabel.bottom, ScreenWidth-20, 20);
    chulibumenLabel.frame = CGRectMake(10, dongzuoLabel.bottom, ScreenWidth-20,20);
    chulikeshiLabel.frame = CGRectMake(10, chulibumenLabel.bottom, ScreenWidth-20, 20);
    chulirenLabel.frame = CGRectMake(10, chulikeshiLabel.bottom, (ScreenWidth-30)/2, 20);
    chulishijianLabel.frame = CGRectMake(ScreenWidth/2-20, chulikeshiLabel.bottom, ScreenWidth/2+20, 20);
    seperateView.frame = CGRectMake(0,chulishijianLabel.bottom , ScreenWidth, 0.5);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return liuzhuanList.count;
}

-(void)setWXFULLNO:(NSString *)WXFULLNO {
    _WXFULLNO = WXFULLNO;
    [self getGuzhangliuzhuan];
}

-(void)getGuzhangliuzhuan {
    RequestCompleteBlock block = ^(id result) {
        liuzhuanList = (NSArray *)result;
        [liuzhuanTable reloadData];
    };
    PowerDataService *dataService = [[PowerDataService alloc]init];
    [dataService GetFaultTransferDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] WXFULLNO:_WXFULLNO completeBlock:block loadingView:self.view showHUD:YES];
}
    
@end
