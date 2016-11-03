//
//  DoingViewController.m
//  i动力
//
//  Created by Bonnie on 16/10/25.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "DoingViewController.h"
#import "SearchViewController.h"
#import "FollowAndRiskViewController.h"
#define kCellHeight      70

@interface DoingViewController ()<YUFoldingTableViewDelegate>
{
    UIButton *_searchBtn;
}

@property (nonatomic, weak) YUFoldingTableView *foldingTableView;

@end

@implementation DoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:kColor_GrayLight];
    // 创建tableView
    [self setupFoldingTableView];
    
    [self initSearchBtn];
    
}

-(void) initSearchBtn
{
    if(!_searchBtn){
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 64 - 50 - 60, kScreenWidth - 40, 40)];
        [_searchBtn setBackgroundColor:kColor_blue];
        [_searchBtn setTitle:@"查询" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_searchBtn];
        [_searchBtn addTarget:self action:@selector(seearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)seearchBtnClick:(UIButton *)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 创建tableView
- (void)setupFoldingTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 50 - 80)];
    _foldingTableView = foldingTableView;
    [_foldingTableView setBackgroundColor:kColor_GrayLight];
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingDelegate = self;
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    // 没有赋值，默认箭头在左
    return self.arrowPosition ? :YUFoldingSectionHeaderArrowPositionRight;
}
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    return 5;
}
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    return 3;
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    return 50;
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   if(indexPath.section == 3 || indexPath.section == 4){
    return 90;}
else
    return kCellHeight;
}
- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"资源变更工单";
            break;
        case 1:
            return @"资源巡查工单";
            break;
        case 2:
            return @"资源核查工单";
            break;
        case 3:
            return @"工程随工工单";
            break;
        case 4:
            return @"风险操作工单";
            break;
            
        default:
            break;
    }
    return nil;
}
- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellID = @"cellID";
            UITableViewCell *cell = [yuTableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, (kCellHeight - 16)/2,16 ,16)];
                [icon setImage:[UIImage imageNamed:@"order_add"]];
                [cell.contentView addSubview:icon];
                
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 8, ScreenWidth - 46, 14)];
                [titleLab setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [titleLab setTextColor:[UIColor blackColor]];
                [titleLab setTag:100];
                [cell.contentView addSubview:titleLab];
                
                UILabel *subLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 30, ScreenWidth - 46, 14)];
                [subLab setFont:[UIFont systemFontOfSize:12.0f]];
                [subLab setTextColor:[UIColor darkGrayColor]];
                [subLab setTag:101];
                [cell.contentView addSubview:subLab];
                
                UILabel *tiemLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, 50, ScreenWidth - 46, 14)];
                [tiemLab setFont:[UIFont systemFontOfSize:12.0f]];
                [tiemLab setTextColor:[UIColor darkGrayColor]];
                [tiemLab setTag:102];
                [cell.contentView addSubview:tiemLab];
                
            }
            UILabel *title = (UILabel *)[cell.contentView viewWithTag:100];
            UILabel *subtitle = (UILabel *)[cell.contentView viewWithTag:101];
            UILabel *time = (UILabel *)[cell.contentView viewWithTag:102];
            
            [title setText:@"临时电费卡士大夫"];
            [subtitle setText:@"电源空调中心 打卡阿斯顿发"];
            [time setText:@"创建时间: 2016-29-10 09:38"];
            return cell;
            
        }
            break;
        case 1:
        case 2:
        {
            static NSString *cellID = @"cell2";
            UITableViewCell *cell = [yuTableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, ScreenWidth - 20, 14)];
                [titleLab setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [titleLab setTextColor:[UIColor blackColor]];
                [titleLab setTag:100];
                [cell.contentView addSubview:titleLab];
                
                UILabel *subLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), 30, ScreenWidth - 20, 14)];
                [subLab setFont:[UIFont systemFontOfSize:12.0f]];
                [subLab setTextColor:[UIColor darkGrayColor]];
                [subLab setTag:101];
                [cell.contentView addSubview:subLab];
                
                UILabel *tiemLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), 50, ScreenWidth - 20, 14)];
                [tiemLab setFont:[UIFont systemFontOfSize:12.0f]];
                [tiemLab setTextColor:[UIColor darkGrayColor]];
                [tiemLab setTag:102];
                [cell.contentView addSubview:tiemLab];
                
            }
            UILabel *title = (UILabel *)[cell.contentView viewWithTag:100];
            UILabel *subtitle = (UILabel *)[cell.contentView viewWithTag:101];
            UILabel *time = (UILabel *)[cell.contentView viewWithTag:102];
            
            [title setText:@"临时电费卡士大夫"];
            [subtitle setText:@"电源空调中心 打卡阿斯顿发"];
            [time setText:@"创建时间: 2016-29-10 09:38"];
            return cell;
            
        }
            break;
            
        case 3:
        case 4:
        {
            static NSString *cellID = @"cell4";
            UITableViewCell *cell = [yuTableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, ScreenWidth - 20, 14)];
                [titleLab setFont:[UIFont boldSystemFontOfSize:14.0f]];
                [titleLab setTextColor:[UIColor blackColor]];
                [titleLab setTag:100];
                [cell.contentView addSubview:titleLab];
                
                UILabel *subLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), 30, ScreenWidth - 20, 14)];
                [subLab setFont:[UIFont systemFontOfSize:12.0f]];
                [subLab setTextColor:[UIColor darkGrayColor]];
                [subLab setTag:101];
                [cell.contentView addSubview:subLab];
                
                UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), 50, ScreenWidth - 20, 14)];
                [desLab setFont:[UIFont systemFontOfSize:12.0f]];
                [desLab setTextColor:[UIColor darkGrayColor]];
                [desLab setTag:102];
                [cell.contentView addSubview:desLab];
                
                UILabel *tiemLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), 65, ScreenWidth - 20, 14)];
                [tiemLab setFont:[UIFont systemFontOfSize:12.0f]];
                [tiemLab setTextColor:[UIColor darkGrayColor]];
                [tiemLab setTag:103];
                [cell.contentView addSubview:tiemLab];
            }
            UILabel *title = (UILabel *)[cell.contentView viewWithTag:100];
            UILabel *subtitle = (UILabel *)[cell.contentView viewWithTag:101];
            UILabel *destitle = (UILabel *)[cell.contentView viewWithTag:102];
            UILabel *time = (UILabel *)[cell.contentView viewWithTag:103];
            
            [title setText:@"临时电费卡士大夫"];
            [subtitle setText:@"电源空调中心 打卡阿斯顿发"];
            [destitle setText:@"布放光缆"];
            [time setText:@"时间安排: 2016-09-10 09:38 至 2016-11-10 11:19"];
            return cell;
            
        }
            break;
            
            
        default:
            break;
    }
    return nil;
}
- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3 || indexPath.section == 4) {//工程随工工单 风险操作工单;
        FollowAndRiskViewController *vc = [[FollowAndRiskViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section
{
    return @"doing";
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
