//
//  IPowerPNchartViewController.m
//  i动力
//
//  Created by 丁浪平 on 16/3/18.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "IPowerPNchartViewController.h"
#import "ZFChart.h"

@interface IPowerPNchartViewController ()<ZFGenericChartDataSource, ZFBarChartDelegate>
{
    NSMutableArray *dataSourceTitles;
    NSMutableArray *dataSourceValues;
}
@property(nonatomic,strong)    NSMutableArray *dataSourceTitles;
@property(nonatomic,strong) NSMutableArray *dataSourceValues;
@end

@implementation IPowerPNchartViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __block NSMutableArray *listValue = [NSMutableArray arrayWithCapacity:1 ];
    __block NSMutableArray *litName = [NSMutableArray arrayWithCapacity:1 ];
    
    self.dataSourceValues = (NSMutableArray*)self.dataSource;
    self.dataSourceTitles = (NSMutableArray*)self.itemtitleS;
    
//    [self.dataSourceValues removeObjectAtIndex:0];
//    [self.dataSourceTitles removeObjectAtIndex:0];

    
//
//    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *fkkh = obj;
//        [listValue addObject:  [[fkkh componentsSeparatedByString:@":"] objectAtIndex:1]];
//        [litName addObject:  [[fkkh componentsSeparatedByString:@":"] objectAtIndex:0]];
//        
//    }];
//    if (listValue &&[listValue count]>0) {
//        self.dataSourceTitles = (NSArray*)litName;
//        self.dataSourceValues = (NSArray*)listValue;
//    }
    
    
    
    
    
    
    
    [self setTitleWithPosition:@"center" title:[[self.TitleString componentsSeparatedByString:@"-"] objectAtIndex:0]];

    
    ZFBarChart * barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    barChart.dataSource = self;
    barChart.delegate = self;
    barChart.topic = [[self.TitleString componentsSeparatedByString:@"-"] objectAtIndex:1];
    barChart.unit = @"";
    barChart.topicColor = ZFPurple;
    [self.view addSubview:barChart];
    [barChart strokePath];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
  
}
#pragma mark - ZFGenericChartDataSource




- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{

    return self.dataSourceValues;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
  
    return self.dataSourceTitles;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue];
}

- (CGFloat)yLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    
   __block NSInteger MaxValule = 10;
    [self.dataSourceValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj integerValue]>=MaxValule) {
            MaxValule = [obj integerValue];
        }
    }];
    
    return MaxValule;
}

- (NSInteger)yLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
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
