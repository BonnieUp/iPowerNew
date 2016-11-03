//
//  IPowerExcelViewController.m
//  i动力
//
//  Created by 丁浪平 on 16/3/18.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "IPowerExcelViewController.h"
#import "YHExcel.h"
#import "UIView+YHCategory.h"
#import "UIButton+BindArgs.h"
#import "IPowerPNchartViewController.h"
#import "IPowerQueryViewController.h"
#import "PowerDataService.h"

#import "ZFDataTableView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ItemWidth ScreenWidth/4
#define ItemHeight 44
#define ScrollHeight (ItemHeight*10)



@interface IPowerExcelViewController ()<YHExcelTitleViewDataSource,YHExcelViewDataSource,UITableViewDelegate,ZFScrollDelegate, UIScrollViewDelegate>
{
    NSArray *Infolist;
    
    
//    __block NSMutableArray *titleArrayp;
//    __block NSMutableArray *footArrayp;
//    __block NSMutableArray *TotalRowArrayp;
}
@property (strong, nonatomic)  YHExcelTitleView *titleView;//表头
@property (strong, nonatomic)  YHExcelTitleView *footView;//表尾
@property (strong, nonatomic)  YHExcelView *excelView;//表内容
@property (strong, nonatomic)  NSArray *titleArray;
@property (strong, nonatomic)  NSArray *titleArray2;
@property (strong, nonatomic)  NSArray *colWidthArray;

@property (strong, nonatomic)NSArray *Infolist;



@property (strong, nonatomic)__block NSMutableArray *titleArrayp;
@property (strong, nonatomic)__block NSMutableArray *footArrayp;
@property (strong, nonatomic)__block NSMutableArray *TotalRowArrayp;

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIScrollView *headView;
@end

@implementation IPowerExcelViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:self.stringName];
      
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self setocntentUI];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"图表" style:UIBarButtonItemStylePlain target:self action:@selector(goNextViewController)];
    rightBtnItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 5;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBtnItem];
    
    
    
    
    
//    UIButton *queryButton  = [UIButton ButtonimageWithFrame:CGRectMake(10, self.footView.bottom, ScreenWidth-20, 30) Normal:nil Select:nil Title:@"查询"];
//    queryButton.backgroundColor = RGBAcolor(37, 137, 222, 1);
//    queryButton.layer.cornerRadius = 3;
//    [queryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [queryButton addTarget:self action:@selector(pushQueryVC) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:queryButton];
    
    
}
-(void)setocntentUI
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    //计算筛选数据
    [self setTitleWithPosition:@"center" title:self.stringName];

    
     NSArray *keys = @[@"TITLE_COL",@"TOTAL_COL",@"COL_1",@"COL_2",@"COL_3",@"COL_4",@"COL_5",@"COL_6",@"COL_7",@"COL_8",@"COL_9",@"COL_10",@"COL_11",@"COL_12",@"COL_13",@"COL_14",@"COL_15",@"COL_16",@"COL_17",@"COL_18",@"COL_19",@"COL_29"];
    self.titleArrayp = [NSMutableArray arrayWithCapacity:1];
    self.footArrayp = [NSMutableArray arrayWithCapacity:1];
    self.TotalRowArrayp = [NSMutableArray arrayWithCapacity:1];
    
    NSDictionary *headdic =self.dicInfo[@"HeaderRow"];
    NSDictionary *footdic =self.dicInfo[@"FootRow"];
    NSArray *dataRowArray =self.dicInfo[@"DataRow"];
    
    
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = obj;
        [headdic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqual:value]) {
                    [self.titleArrayp addObject:obj];
                    NSLog(@"%@",self.titleArrayp);
                }
        }];
        [footdic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqual:value]) {
                [self.footArrayp addObject:obj];
                NSLog(@"%@",self.footArrayp);
            }
        }];
        
        
    }];
    
    
    [dataRowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *Onedic = obj;
        
        
        __block NSMutableArray *RowArrayp = [NSMutableArray arrayWithCapacity:1];

        [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *value = obj;
            [Onedic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqual:value]) {
                    [RowArrayp addObject:obj];
                    NSLog(@"%@",self.titleArrayp);
                }
            }];
        }];
        
        
        [self.TotalRowArrayp addObject:RowArrayp];

        
    }];
    [self.TotalRowArrayp addObject:self.footArrayp];

    
    __block NSMutableArray *TotalLeftArrayp = [NSMutableArray arrayWithCapacity:1];
  
    [self.TotalRowArrayp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *jArray = (NSArray*)obj;
        [TotalLeftArrayp addObject:jArray[0]];
    }];

    
    CGFloat height1 =  ItemHeight*(self.TotalRowArrayp.count+2);
    
    //第一列tableView父视图
//    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ItemWidth, ScreenHeight-60)];
//    _headView.backgroundColor = [UIColor whiteColor];
//    _headView.userInteractionEnabled = YES;
//    //设置边框，形成表格
//    [self.view addSubview:_headView];
    _headView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ItemWidth, ScreenHeight-60)];
    _headView.contentSize = CGSizeMake(ItemWidth, self.TotalRowArrayp.count*ItemHeight);
    _headView.contentSize = CGSizeMake(ItemWidth, 0);
    _headView.showsHorizontalScrollIndicator = NO;
    _headView.showsVerticalScrollIndicator = NO;
    _headView.bounces = NO;
    _headView.delegate = self;
    //设置边框，形成表格
    [self.view addSubview:_headView];
    
    
    //可左右滑动tableView父视图
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(ItemWidth, 0, ScreenWidth-ItemWidth, ScreenHeight-60)];
//    _scroll.contentSize = CGSizeMake((self.titleArrayp.count-1)*ItemWidth, self.TotalRowArrayp.count*ItemHeight);
    _scroll.contentSize = CGSizeMake((self.titleArrayp.count-1)*ItemWidth, 0);
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    _scroll.delegate = self;
    _scroll.backgroundColor = [UIColor whiteColor];
    _scroll.alwaysBounceVertical = NO;
    _scroll.alwaysBounceHorizontal = NO;
    [self.view addSubview:_scroll];
    
    
    //第一列表
    ZFDataTableView *tableView = [[ZFDataTableView alloc] initWithFrame:CGRectMake(0, 0, ItemWidth, ScreenHeight-60)style:UITableViewStylePlain];

    tableView.tag = -1;
    tableView.titleArr = TotalLeftArrayp;
    tableView.headerStr = @"";
    tableView.scroll_delegate = self;
  

    [_headView addSubview:tableView];
    

    for (int i = 0; i < self.titleArrayp.count-1; i++)
    {
        
        ZFDataTableView *tableView = [[ZFDataTableView alloc] initWithFrame:CGRectMake(ItemWidth*i, 0, ItemWidth, _scroll.height) style:UITableViewStylePlain];
        tableView.tag = i;
        tableView.headerStr = self.titleArrayp[i+1];
        tableView.alwaysBounceVertical = NO;
        tableView.alwaysBounceHorizontal = NO;
        __block NSMutableArray *contentArrayp = [NSMutableArray arrayWithCapacity:1];
        
        [self.TotalRowArrayp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *jArray = (NSArray*)obj;
            [contentArrayp addObject:jArray[i+1]];
        }];
        tableView.titleArr = contentArrayp;
        [tableView reloadData];
        tableView.scroll_delegate = self;
        tableView.tag = i;
        [_scroll addSubview:tableView];
      
    }


}

//点头部
-(void)didSelectItemYlilne:(NSInteger)index :(NSString*)string
{
    NSLog(@"%@ -- %ld",string ,index);
    
    if ([string isEqualToString:@""]) {
        return;
    }
    
    __block NSMutableArray *titleArray1 = [NSMutableArray arrayWithCapacity:1];
    __block NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:1];
    
    [self.TotalRowArrayp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *list = (NSArray*)obj;
        [titleArray1 addObject:list[0]];
        [valueArray addObject:list[index+1]];
    }];
//    if ([string isEqualToString:@"合计"]) {
        [titleArray1 removeLastObject];
        [valueArray removeLastObject];
//    }
    
    IPowerPNchartViewController *VC = [[IPowerPNchartViewController alloc]initWithNibName:nil bundle:nil];
    VC.TitleString = [NSString stringWithFormat:@"%@-%@",self.stringName,string];
    VC.dataSource = valueArray;
    VC.itemtitleS = titleArray1;
    [self.navigationController pushViewController:VC animated:NO];
    

}
//点侧边
-(void)didSelectItemXlilne:(NSInteger)index :(NSString*)string
{
    
    if ([string isEqualToString:@""]) {
        return;
    }
     NSMutableArray *titleArray1 = [NSMutableArray arrayWithArray:self.TotalRowArrayp[index]];
     NSMutableArray *valueArray1 = [NSMutableArray arrayWithArray:self.titleArrayp];
    
    [titleArray1 removeObjectsInRange:NSMakeRange(0, 2)];
    [valueArray1 removeObjectsInRange:NSMakeRange(0, 2)];



    IPowerPNchartViewController *VC = [[IPowerPNchartViewController alloc]initWithNibName:nil bundle:nil];
    VC.TitleString = [NSString stringWithFormat:@"%@-%@",self.stringName,string];
    VC.dataSource = titleArray1;
    VC.itemtitleS = valueArray1;
    [self.navigationController pushViewController:VC animated:NO];
    
}
-(void)pushQueryVC
{
    
    IPowerQueryViewController *VC = [[IPowerQueryViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:VC animated:NO];
    
    
}




-(void)goNextViewController
{
    
    __block NSMutableArray *titleArray1 = [NSMutableArray arrayWithCapacity:1];
    __block NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:1];
    
    [self.TotalRowArrayp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *list = (NSArray*)obj;
        [titleArray1 addObject:list[0]];
        [valueArray addObject:list[1]];
    }];
    [titleArray1 removeLastObject];
    [valueArray removeLastObject];
    
    IPowerPNchartViewController *VC = [[IPowerPNchartViewController alloc]initWithNibName:nil bundle:nil];
    VC.TitleString = self.stringName;
    VC.TitleString = [NSString stringWithFormat:@"%@-%@",self.stringName,@" "];

    VC.dataSource = valueArray;
    VC.itemtitleS = titleArray1;
    [self.navigationController pushViewController:VC animated:NO];
    

   
}
//-(void)
- (void)backAction{
        [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - ZFScrollDelegate

-(void)dataTableViewContentOffSet:(CGPoint)contentOffSet
{
    for (UIView *subView in _scroll.subviews)
    {
        if ([subView isKindOfClass:[ZFDataTableView class]])
        {
            [(ZFDataTableView *)subView setTableViewContentOffSet:contentOffSet];
        }
    }
    
    for (UIView *subView in _headView.subviews)
    {
        [(ZFDataTableView *)subView setTableViewContentOffSet:contentOffSet];
    }
}
#pragma mark - UIScrollViewDelegate


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
