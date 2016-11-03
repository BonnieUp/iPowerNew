//
//  FollowAndRiskViewController.m
//  i动力
//
//  Created by Bonnie on 16/10/26.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "FollowAndRiskViewController.h"
#import "ScanViewController.h"
#define kCellSection_0       350
#define kCellSection_1       100
#define kCellSection_2       60
#define kCellSection_3       60


@interface FollowAndRiskViewController ()<UITableViewDataSource , UITableViewDelegate>
{
    UIButton *_receiptBtn;
}
@property (nonatomic , strong) UITableView *tableView;
@end

@implementation FollowAndRiskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 60) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBackgroundColor:kColor_GrayLight];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [self initReceiptBtn];
    
}

-(void) initReceiptBtn
{
    if(!_receiptBtn){
        _receiptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_receiptBtn setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 64 - 60, kScreenWidth - 40, 40)];
        [_receiptBtn setBackgroundColor:kColor_blue];
        [_receiptBtn setTitle:@"回单" forState:UIControlStateNormal];
        [_receiptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_receiptBtn];
        [_receiptBtn addTarget:self action:@selector(receiptBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)receiptBtn:(UIButton *)sender
{
    
}

#pragma mark - --- tableview  delegate
#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return kCellSection_0;
            break;
        case 1:
            return kCellSection_1;
            break;
        case 2:
            return kCellSection_2;
            break;
        case 3:
            return kCellSection_3;
            break;
            
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [view setBackgroundColor:kColor_GrayLight];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 50)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:kSystemFont(13.0)];
    [label setTextColor:[UIColor blackColor]];
    [view addSubview:label];
    switch (section) {
        case 0:
            label.text = [NSString stringWithFormat:@"工单信息(%@)",@(1003)];
            break;
        case 1:
            label.text = @"执行记录";
            break;
        case 2:
        {
            [label setFrame:CGRectMake(10, 0, 100, 50)];
            label.text = @"关联对象";
            NSArray *iconarr = [NSArray arrayWithObjects:@"add_device.png",@"photo_scan",@"ico_minus.png", nil];
            for (int i = 0; i < 3; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(CGRectGetMaxX(label.frame) + 20 + 50*i, (50-32)/2, 32, 32)];
                [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[iconarr objectAtIndex:i]]] forState:UIControlStateNormal];
                [btn setTag:(700+i)];
                [btn addTarget:self action:@selector(connectClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
            }
            

        }
            break;
        case 3:
            label.text = @"备注";
            break;
        default:
            break;
    }
    
    return view;
}

#pragma mark --- 关联
-(void)connectClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 700:
            NSLog(@"++");
            break;
        case 701:
            NSLog(@"扫描");
        {
            ScanViewController *vc = [[ScanViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 702:
            NSLog(@"--");
            break;
        default:
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       switch (indexPath.section) {
        case 0:
        {
            static NSString *cellID = @"cell0";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
              
                for (int i = 0; i < 17; i++) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10+20*i, kScreenWidth-20, 12)];
                    [label setTextColor:[UIColor blackColor]];
                    [label setFont:kSystemFont(12)];
                    [label setTag:(100+i)];
                    [label setText:NSTextAlignmentLeft];
                    [cell.contentView addSubview:label];
                }
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCellSection_0 - 1, kScreenWidth, 1)];
                [line setBackgroundColor:kColor_GrayLight];
                [cell.contentView addSubview:line];
                
                
            }
            for (int i = 0; i < 17; i++) {
                UILabel *label = (UILabel *)[cell.contentView viewWithTag:100+i];
                switch (i) {
                    case 0:
                        label.text = [NSString stringWithFormat:@"工程名称：%@",@(i)];
                        break;
                    case 1:
                        label.text = [NSString stringWithFormat:@"工程编号：%@",@(i)];
                        break;
                    case 2:
                        label.text = [NSString stringWithFormat:@"客保工单编号：%@",@(i)];
                        break;
                    case 3:
                        label.text = [NSString stringWithFormat:@"施工预约ID：%@",@(i)];
                        break;
                    case 4:
                        label.text = [NSString stringWithFormat:@"施工单位：%@",@(i)];
                        break;
                    case 5:
                        label.text = [NSString stringWithFormat:@"施工人员：%@",@(i)];
                        break;
                    case 6:
                        label.text = [NSString stringWithFormat:@"施工人员联系电话：%@",@(i)];
                        break;
                    case 7:
                        label.text = [NSString stringWithFormat:@"施工时间：%@",@(i)];
                        break;
                    case 8:
                        label.text = [NSString stringWithFormat:@"施工地址：%@",@(i)];
                        break;
                    case 9:
                        label.text = [NSString stringWithFormat:@"施工内容：%@",@(i)];
                        break;
                    case 10:
                        label.text = [NSString stringWithFormat:@"特殊要求：%@",@(i)];
                        break;
                    case 11:
                        label.text = [NSString stringWithFormat:@"计划执行人：%@",@(i)];
                        break;
                    case 12:
                        label.text = [NSString stringWithFormat:@"审核人：%@",@(i)];
                        break;
                    case 13:
                        label.text = [NSString stringWithFormat:@"计划开始时间：%@",@(i)];
                        break;
                    case 14:
                        label.text = [NSString stringWithFormat:@"计划完成时间：%@",@(i)];
                        break;
                    case 15:
                        label.text = [NSString stringWithFormat:@"实际开始时间：%@",@(i)];
                        break;
                    case 16:
                        label.text = [NSString stringWithFormat:@"实际完成时间：%@",@(i)];
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            

            return cell;

        }
            break;
        case 1:
        {
            static NSString *cellID = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                
                for (int i = 0; i < 3; i++) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10+20*i, kScreenWidth-20, 12)];
                    [label setTextColor:[UIColor blackColor]];
                    [label setFont:kSystemFont(12)];
                    [label setTag:(200+i)];
                    [label setText:NSTextAlignmentLeft];
                    [cell.contentView addSubview:label];
                }
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCellSection_1, kScreenWidth, 1)];
                [line setBackgroundColor:kColor_GrayLight];
                [cell.contentView addSubview:line];
                
            }
            for (int i = 0; i < 3; i++) {
                UILabel *label = (UILabel *)[cell.contentView viewWithTag:200+i];
                switch (i) {
                    case 0:
                        label.text = [NSString stringWithFormat:@"随工人员：%@",@(i)];
                        break;
                    case 1:
                        label.text = [NSString stringWithFormat:@"任务详情：%@",@(i)];
                        break;
                    case 2:
                        label.text = [NSString stringWithFormat:@"随工时间：%@",@(i)];
                        break;
                
                    default:
                        break;
                }
            }

            return cell;

        }
            break;
        case 2:
           {
               static NSString *cellID = @"cell2";
               UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
               if (cell == nil) {
                   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                   UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCellSection_2, kScreenWidth, 1)];
                   [line setBackgroundColor:kColor_GrayLight];
                   [cell.contentView addSubview:line];
                   
                   
               }
               return cell;
               
           }
            break;
        case 3:
           {
               static NSString *cellID = @"cell3";
               UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
               if (cell == nil) {
                   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
                   UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCellSection_3, kScreenWidth, 1)];
                   [line setBackgroundColor:kColor_GrayLight];
                   [cell.contentView addSubview:line];
                   
                   
               }
               return cell;
               
           }
            break;
              default:
            break;
            
    }
    return nil;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
