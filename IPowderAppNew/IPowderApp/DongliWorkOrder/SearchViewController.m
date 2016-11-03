//
//  SearchViewController.m
//  i动力
//
//  Created by Bonnie on 16/10/26.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "SearchViewController.h"
#define kCellHeight      70

@interface SearchViewController ()<UITableViewDataSource , UITableViewDelegate>
@property (nonatomic, weak) UITableView *foldingTableView;

@end

@implementation SearchViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //设置背景颜色
        self.view.backgroundColor = kColor_GrayLight;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"动力工单查询";
    
    //设置navigationbar左按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backActionToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=backBarBtn;
    // 创建tableView
    [self setupFoldingTableView];
    
    
}

-(void)backActionToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 创建tableView
- (void)setupFoldingTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *foldingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64  )];
    _foldingTableView = foldingTableView;
    [_foldingTableView setBackgroundColor:kColor_GrayLight];
    [self.view addSubview:foldingTableView];
    foldingTableView.delegate = self;
    foldingTableView.dataSource = self;
    foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 16-10, (50 - 16)/2,16 ,16)];
        [icon setImage:[UIImage imageNamed:@"Arrow"]];
        [cell.contentView addSubview:icon];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
        [line setBackgroundColor:kColor_GrayLight];
        [cell.contentView addSubview:line];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"资源变更工单查询";
            break;
        case 1:
            cell.textLabel.text = @"资源巡查工单查询";
            break;
        case 2:
            cell.textLabel.text = @"资源核查工单查询";
            break;
        case 3:
            cell.textLabel.text = @"工程随工工单查询";
            break;
        case 4:
            cell.textLabel.text = @"风险操作工单查询";
            break;
            
        default:
            break;

    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
