//
//  SearchFaultViewController.m
//  i动力
//
//  Created by Bonnie on 16/10/28.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "SearchFaultViewController.h"
#import "ScanViewController.h"
@interface SearchFaultViewController () <UISearchBarDelegate>

@end

@implementation SearchFaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 50)];
    [searchView setBackgroundColor:kColor_GrayLight];
    [self.view addSubview:searchView];
    
    //导航条的搜索条
    UISearchBar  *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth - 32 - 20, 40)];
    searchBar.delegate = self;
    [searchBar setTintColor:[UIColor clearColor]];
    [searchBar setPlaceholder:@"搜索"];
    [searchView addSubview:searchBar];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 32 - 10, (50-32)/2, 32, 32)];
    [button setImage:[UIImage imageNamed:@"photo_scan"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"photo_scan"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(scanClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:button];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 64  - 60, kScreenWidth - 40, 40)];
    [searchBtn setBackgroundColor:kColor_blue];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)searchBtnClick:(UIButton *)sender
{
  
}

-(void)scanClick:(UIButton *)sender
{
    ScanViewController *vc = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
