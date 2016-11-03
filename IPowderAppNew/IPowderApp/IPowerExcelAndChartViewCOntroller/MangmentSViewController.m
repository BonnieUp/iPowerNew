//
//  MangmentSViewController.m
//  i动力
//
//  Created by 丁浪平 on 16/3/19.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "MangmentSViewController.h"
#import "IconView.h"
#import "IPowerExcelViewController.h"
#import "PowerDataService.h"
@interface MangmentSViewController ()<IconViewDelegate>{
    NSArray *dataSourceArray;
}
@property(nonatomic,strong)    NSArray *dataSourceArray;


@end

@implementation MangmentSViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"质量分析报表";
//        [self setTitleWithPosition:@"left" title:@"我的网管"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    //获取模块
    
    
    
    RequestCompleteBlock block = ^(id result) {
        self.dataSourceArray = (NSArray*)result;
//        [MBProgressHUD hideHUDForView:self.view.window animated:NO];

    UIView *ffff = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    ffff.backgroundColor = [UIColor redColor];
    
    IconView *Icon1 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon1.delegate = self;
    Icon1.tag = 1;
    Icon1.frame =  CGRectMake(20, 10, 70, 90);
    Icon1.imageNameString = self.dataSourceArray[0][@"IMAGE_NAME"];
    Icon1.IconTitleString = self.dataSourceArray[0][@"REPORT_TYPE_NAME"];
    
    IconView *Icon2 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon2.delegate = self;
    Icon2.tag = 2;
    
    Icon2.frame =  CGRectMake(125, 10, 70, 90);
    Icon2.imageNameString = self.dataSourceArray[1][@"IMAGE_NAME"];
    Icon2.IconTitleString = self.dataSourceArray[1][@"REPORT_TYPE_NAME"];
    
    IconView *Icon3 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon3.delegate = self;
    Icon3.tag = 3;
    Icon3.frame =  CGRectMake(230, 10, 70, 90);
    Icon3.imageNameString = self.dataSourceArray[2][@"IMAGE_NAME"];
    Icon3.IconTitleString = self.dataSourceArray[2][@"REPORT_TYPE_NAME"];
    
    IconView *Icon4 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon4.delegate = self;
    Icon4.tag = 4;
    Icon4.frame =  CGRectMake(20, 110, 70, 90);
    Icon4.imageNameString = self.dataSourceArray[3][@"IMAGE_NAME"];
    Icon4.IconTitleString = self.dataSourceArray[3][@"REPORT_TYPE_NAME"];
    
    
    IconView *Icon5 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon5.delegate = self;
    Icon5.tag = 5;
    Icon5.frame =  CGRectMake(125, 110, 70, 90);
        
        Icon5.imageNameString = self.dataSourceArray[4][@"IMAGE_NAME"];
        Icon5.IconTitleString = self.dataSourceArray[4][@"REPORT_TYPE_NAME"];
        
    IconView *Icon6 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon6.delegate = self;
    Icon6.tag = 6;
    Icon6.frame =  CGRectMake(230, 110, 70, 90);
    Icon6.imageNameString = self.dataSourceArray[5][@"IMAGE_NAME"];
    Icon6.IconTitleString = self.dataSourceArray[5][@"REPORT_TYPE_NAME"];
    
        IconView *Icon7 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
        Icon7.delegate = self;
        Icon7.tag = 7;
        Icon7.frame =  CGRectMake(20, 210, 70, 90);
        Icon7.imageNameString = self.dataSourceArray[6][@"IMAGE_NAME"];
        Icon7.IconTitleString = self.dataSourceArray[6][@"REPORT_TYPE_NAME"];
    
        IconView *Icon8 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
        Icon8.delegate = self;
        Icon8.tag = 8;
        Icon8.frame =  CGRectMake(125, 210, 70, 90);
        Icon8.imageNameString = self.dataSourceArray[7][@"IMAGE_NAME"];
        Icon8.IconTitleString = self.dataSourceArray[7][@"REPORT_TYPE_NAME"];
        
        IconView *Icon9 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
        Icon9.delegate = self;
        Icon9.tag = 9;
        Icon9.frame =  CGRectMake(230, 210, 70, 90);
        Icon9.imageNameString = self.dataSourceArray[8][@"IMAGE_NAME"];
        Icon9.IconTitleString = self.dataSourceArray[8][@"REPORT_TYPE_NAME"];
        
        IconView *Icon10 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
        Icon10.delegate = self;
        Icon10.tag = 10;
        Icon10.frame =  CGRectMake(20, 310, 70, 90);
        Icon10.imageNameString = self.dataSourceArray[9][@"IMAGE_NAME"];
        Icon10.IconTitleString = self.dataSourceArray[9][@"REPORT_TYPE_NAME"];
        
        IconView *Icon11 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
        Icon11.delegate = self;
        Icon11.tag = 11;
        Icon11.frame =  CGRectMake(125, 310, 70, 90);
        Icon11.imageNameString = self.dataSourceArray[10][@"IMAGE_NAME"];
        Icon11.IconTitleString = self.dataSourceArray[10][@"REPORT_TYPE_NAME"];
        
        
        
    [self.view addSubview:Icon1];
    [self.view addSubview:Icon2];
    [self.view addSubview:Icon3];
    [self.view addSubview:Icon4];
    [self.view addSubview:Icon5];
    [self.view addSubview:Icon6];
    
    
        [self.view addSubview:Icon7];
        [self.view addSubview:Icon8];
        [self.view addSubview:Icon9];
        [self.view addSubview:Icon10];
        [self.view addSubview:Icon11];
    };

    
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    
    [dataService getMangmentIconList:AccessToken Type:@"2" operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:self.view.window showHUD:YES];
//    [MBProgressHUD showHUDAddedTo:self.view.window animated:NO];

    
    // Do any additional setup after loading the view.
}
- (void)didSelectIcon:(NSInteger)tag
{
    
    NSString *methodNameString = self.dataSourceArray[tag-1][@"METHOD_NAME"];
    
    
    //获取模块
    RequestCompleteBlock block = ^(id result) {
        [MBProgressHUD hideHUDForView:self.view.window animated:NO];

        NSArray *list = (NSArray*)result;
        
        
        if (list==nil) {
            
            return ;
        }
        //没有数据时调用接口3
        if ([list count]==0) {
            
            RequestCompleteBlock block1 = ^(id result) {
                [MBProgressHUD hideHUDForView:self.view.window animated:NO];

                NSDictionary *dicInfo = (NSDictionary*)result;
                
                //获取表格数据
                IPowerExcelViewController *VC = [[IPowerExcelViewController alloc]initWithNibName:nil bundle:nil];
                VC.stringName = self.dataSourceArray[tag-1][@"REPORT_TYPE_NAME"];
                VC.dicInfo = dicInfo;
                [self.navigationController pushViewController:VC animated:NO];
                
            };
            
            
            
            PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
            [dataService getData:AccessToken Type:methodNameString EnNamedic:nil operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block1 loadingView:self.view.window showHUD:YES];
            
            [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];

        }else
        {
            
            
            
            IPowerQueryViewController *VC = [[IPowerQueryViewController alloc]initWithNibName:nil bundle:nil];
            VC.dataSource =list;
            VC.stringName = self.dataSourceArray[tag-1][@"REPORT_TYPE_NAME"];
            VC.stringNameMETHOD_NAME = self.dataSourceArray[tag-1][@"METHOD_NAME"];
            [self.navigationController pushViewController:VC animated:NO];
            //查询页面
            
        }
        
    };
    
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    [dataService getQueryReportDetail:AccessToken Type:methodNameString operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:self.view.window showHUD:YES];
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];

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
