//
//  MangmentFViewController.m
//  i动力
//
//  Created by 丁浪平 on 16/3/19.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "MangmentFViewController.h"
#import "IconView.h"
#import "IPowerExcelViewController.h"
#import "PowerDataService.h"
@interface MangmentFViewController ()<IconViewDelegate>
{
    NSArray *dataSourceArray;
}
@property(nonatomic,strong)    NSArray *dataSourceArray;

@end

@implementation MangmentFViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"质量管控报表";
//        [self setTitleWithPosition:@"left" title:@"我的网管"];

    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   

}


- (void)viewDidLoad {
    [super viewDidLoad];

    //获取模块
    RequestCompleteBlock block = ^(id result) {
//        [MBProgressHUD hideHUDForView:self.view.window animated:NO];

        
        self.dataSourceArray = (NSArray*)result;
        
        
 
    
    
    UIView *ffff = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    ffff.backgroundColor = [UIColor redColor];
    
    IconView *Icon1 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon1.delegate = self;
    Icon1.tag = 0;
    Icon1.frame =  CGRectMake(20, 10, 70, 90);
    Icon1.imageNameString = self.dataSourceArray[0][@"IMAGE_NAME"];
    Icon1.IconTitleString = self.dataSourceArray[0][@"REPORT_TYPE_NAME"];
    
    IconView *Icon2 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon2.delegate = self;
    Icon2.tag = 1;

    Icon2.frame =  CGRectMake(125, 10, 70, 90);
    Icon2.imageNameString = self.dataSourceArray[1][@"IMAGE_NAME"];
    Icon2.IconTitleString = self.dataSourceArray[1][@"REPORT_TYPE_NAME"];
    
    IconView *Icon3 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon3.delegate = self;
    Icon3.tag = 2;
    Icon3.frame =  CGRectMake(230, 10, 70, 90);
    Icon3.imageNameString = self.dataSourceArray[2][@"IMAGE_NAME"];
    Icon3.IconTitleString = self.dataSourceArray[2][@"REPORT_TYPE_NAME"];
    
    IconView *Icon4 = [[IconView alloc]initIconViewWithValue:@"as" title:@"sada" ];
    Icon4.delegate = self;
    Icon4.tag = 3;
    Icon4.frame =  CGRectMake(20, 110, 70, 90);
    Icon4.imageNameString = self.dataSourceArray[3][@"IMAGE_NAME"];
    Icon4.IconTitleString = self.dataSourceArray[3][@"REPORT_TYPE_NAME"];
    
    [self.view addSubview:Icon1];
    [self.view addSubview:Icon2];
    [self.view addSubview:Icon3];
    [self.view addSubview:Icon4];


    
    };

  
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    
    [dataService getMangmentIconList:AccessToken Type:@"1" operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:self.view.window showHUD:YES];
//    [MBProgressHUD showHUDAddedTo:self.view.window animated:NO];

    
    // Do any additional setup after loading the view.
}
- (void)didSelectIcon:(NSInteger)tag
{
    
    NSString *methodNameString = self.dataSourceArray[tag][@"METHOD_NAME"];
    
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
                NSDictionary *dicInfo = (NSDictionary*)result;
                [MBProgressHUD hideHUDForView:self.view.window animated:NO];

                //获取表格数据
                IPowerExcelViewController *VC = [[IPowerExcelViewController alloc]initWithNibName:nil bundle:nil];
                VC.stringName = self.dataSourceArray[tag][@"REPORT_TYPE_NAME"];
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
            VC.stringName = self.dataSourceArray[tag][@"REPORT_TYPE_NAME"];
            VC.stringNameMETHOD_NAME = self.dataSourceArray[tag][@"METHOD_NAME"];

            [self.navigationController pushViewController:VC animated:NO];
            //查询页面
            
        }
        
    };
    
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    [dataService getQueryReportDetail:AccessToken Type:methodNameString operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] completeBlock:block loadingView:self.view.window showHUD:YES];
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
   
}
-(void)backAction
{
    //如果可以跳转到主界面
    if(self.backToHomePage==YES){
        [super backAction];
    }
    //跳转到i运维
    else {
        NSString *urlStr = @"telecom://iPower/returnTelecom?fnType=iPowerPR";
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
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
