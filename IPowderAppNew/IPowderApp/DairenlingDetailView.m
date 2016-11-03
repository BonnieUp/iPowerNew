//
//  DairenlingDetailView.m
//  i动力
//
//  Created by 王敏 on 16/1/8.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "DairenlingDetailView.h"
#import "PowerDataService.h"
#import "CustomButtonWithData.h"

@implementation DairenlingDetailView{
    UIScrollView *scrollView;
    UIGlossyButton *selectAllbtn;
    UIGlossyButton *startBtn;
    UIView *operationView;
    NSString *planNum;
    NSMutableDictionary *planDic;
    float rowHeight;
    //当前选项卡索引
    NSUInteger selectedTab;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    rowHeight = 30;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-80)];
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0,scrollView.bottom,ScreenWidth,40)];
    operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    selectAllbtn = [[UIGlossyButton alloc]init];
    selectAllbtn.frame = CGRectMake(5, 5, (ScreenWidth-20)/2, 30);
    [selectAllbtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllbtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [selectAllbtn addTarget:self action:@selector(selectAllHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:selectAllbtn];
    
    startBtn = [[UIGlossyButton alloc]init];
    startBtn.frame = CGRectMake(selectAllbtn.right+10, 5, (ScreenWidth-20)/2, 30);
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setEnabled:NO];
    [startBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [startBtn addTarget:self action:@selector(startHandler:) forControlEvents:UIControlEventTouchUpInside];
    [operationView addSubview:startBtn];
    [self.view addSubview:operationView];
    
    float tabWidth = ScreenWidth / 4;
    float  _menuHeight = 40;
    NSArray *controllers = [[NSArray alloc]initWithObjects:@"待认领",@"待开始",@"进行中",@"已完成", nil];
    _tabs = [[NSMutableArray alloc] init];
    for (int i=0; i < controllers.count; i++)
    {
        // Create content view
        NSString *str = [controllers objectAtIndex:i];
        // Create button
        UIButton *tab = [[UIButton alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, _menuHeight)];
        [tab setTitle:str forState:UIControlStateNormal];
        tab.titleLabel.font = [UIFont systemFontOfSize:13];
        [tab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tab.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        //        [tab setBackgroundImage:[UIImage imageNamed:@"tabbar_background.png"] forState:UIControlStateSelected];
        [tab setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1] size:tab.size] forState:UIControlStateSelected];
        [tab addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tab];
        [_tabs addObject:tab];
        
        
        // Add separator
        if( i>0 )
        {
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(i*tabWidth,
                                                                   0,
                                                                   0.5,
                                                                   40)];
            [sep setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]];
            [self.view addSubview:sep];
        }
    }
    
    UIButton *tab = [_tabs objectAtIndex:0];
    [tab setSelected:YES];
    selectedTab = 0;
    UIView *bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0, _menuHeight- 1.0, ScreenWidth, 1.0)];
    //    bottomHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    bottomHeaderView.backgroundColor = [UIColor colorWithRed:69/255.0 green:133/255.0 blue:191/255.0 alpha:1];
    [self.view addSubview:bottomHeaderView];
}

-(void)selectTab:(id)sender{
    selectedTab = [_tabs indexOfObject:sender];
    if(selectedTab==0)
        return;
    NSString *selectStr = [NSString stringWithFormat:@"%lu",(unsigned long)selectedTab];
    //发送改变选项卡的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"donglihechachangetab" object:selectStr];
    
}

-(void)selectAllHandler:(id)sender{
    if([selectAllbtn.titleLabel.text isEqualToString:@"全选"]){
        for(NSString *key in planDic.allKeys){
            NSArray *sectionArray = (NSArray *)[planDic objectForKey:key];
            for(NSMutableDictionary *pieceDic in sectionArray){
                [pieceDic setValue:@"1" forKey:@"selected"];
            }
        }
    }else{
        for(NSString *key in planDic.allKeys){
            NSArray *sectionArray = (NSArray *)[planDic objectForKey:key];
            for(NSMutableDictionary *pieceDic in sectionArray){
                [pieceDic setValue:@"0" forKey:@"selected"];
            }
        }
    }
    [self drawViews];
    [self judgeButtonState];
}

-(void)startHandler:(id)sender{
    RequestCompleteBlock block = ^(id result) {
        [self setPlanNum:planNum];
    };
    PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
    [dataService excutePrCheckStationWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] operStatusNum:@"1" recordNumList:[self getSelectRecordNum] completeBlock:block loadingView:scrollView showHUD:YES];
}

-(void)setPlanNum:(NSString *)num{
        planNum = num;
        RequestCompleteBlock block = ^(id result) {
            //按照日期排序
            NSComparator cmptr = ^(id obj1, id obj2){
                NSDate *date1 = [PowerUtils stringToDate:[obj1 objectForKey:@"PLAN_CHECK_DATE"] withFormat:@"MM-dd"];
                NSDate *date2 = [PowerUtils stringToDate:[obj2 objectForKey:@"PLAN_CHECK_DATE"] withFormat:@"MM-dd"];
                NSComparisonResult result = [date1 compare:date2 ];
                return result;
            };
            NSArray *sortArray = [(NSArray *)result sortedArrayUsingComparator:cmptr];
            [self setPlanData:(NSArray *)sortArray];
        };
        PowerDataService *dataService = [[PowerDataService alloc]initUserJsonHead];
        [dataService getPrCheckStationDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] checkStatusNum:@"1" planNum:planNum completeBlock:block loadingView:self.view showHUD:YES];
}

-(void)setPlanData:(NSArray *)dic{
    planDic = [[NSMutableDictionary alloc]init];
    for(NSDictionary *itemDic in dic){
        NSString *regName = [itemDic objectForKey:@"REG_NAME"];
        //如果没有该REG_NAME，创建
        if([planDic objectForKey:regName]==nil){
            NSMutableArray *itemArray = [[NSMutableArray alloc]init];
            [planDic setValue:itemArray forKey:regName];
        }
        //找到array
        NSMutableArray *itemArray = [planDic objectForKey:regName];
        NSMutableDictionary *itemMutableDic = [[NSMutableDictionary alloc]initWithDictionary:itemDic];
        [itemMutableDic setValue:@"0" forKey:@"selected"];
        [itemArray addObject:itemMutableDic];
    }
    [self drawViews];
    [self judgeButtonState];
}

-(void)drawViews{
    //先删掉scrollView里的所有内容
    for(UIView *view in scrollView.subviews){
        [view removeFromSuperview];
    }
    //根据planDic按照日期升序排序转成array
    NSMutableArray *planArray = [[NSMutableArray alloc]init];
    for(NSString *key in planDic.allKeys){
        NSArray *sectionArray = (NSArray *)[planDic objectForKey:key];
        [planArray addObject:sectionArray];
    }
    NSComparator cmptr = ^(id obj1, id obj2){
        NSArray *array1 = (NSArray *)obj1;
        NSArray *array2 = (NSArray *)obj2;
        NSDictionary *dic1 = [array1 objectAtIndex:array1.count-1];
        NSDictionary *dic2 = [array2 objectAtIndex:array2.count-1];
        NSDate *date1 = [PowerUtils stringToDate:[dic1 objectForKey:@"PLAN_CHECK_DATE"] withFormat:@"MM-dd"];
        NSDate *date2 = [PowerUtils stringToDate:[dic2 objectForKey:@"PLAN_CHECK_DATE"] withFormat:@"MM-dd"];
        NSComparisonResult result = [date1 compare:date2 ];
        return result;
    };
    NSArray *sortArray = [planArray sortedArrayUsingComparator:cmptr];
    //根据数据生成
    CGFloat height = 2;
    CGFloat gap = 2;
    for(NSArray *itemArray in sortArray){
        UIView *sectionView = [self createSectionView:itemArray];
        float sectionHeight = [self caculateSectionHeight:itemArray];
        sectionView.frame = CGRectMake(2, height, ScreenWidth-4, sectionHeight);
        height+=sectionHeight+gap;
        [scrollView addSubview:sectionView];
    }
    [scrollView setContentSize:CGSizeMake(ScreenWidth, height)];
}

//根据数据创建出对应的sectionView
-(UIView *)createSectionView:(NSArray *)sectionArray{
    UIView *sectionView = [[UIView alloc]init];
    sectionView.layer.borderWidth = 0.5f;
    sectionView.layer.borderColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1].CGColor;
    sectionView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    //headView
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-4, rowHeight)];
    UILabel *leftView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (ScreenWidth-120), rowHeight)];
    leftView.textAlignment = NSTextAlignmentLeft;
    leftView.font = [UIFont systemFontOfSize:14];
    [headView addSubview:leftView];
    
    UILabel *rightView = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-120, 0, 110, rowHeight)];
    rightView.textAlignment = NSTextAlignmentRight;
    rightView.font = [UIFont systemFontOfSize:14];
    [headView addSubview:rightView];
    [sectionView addSubview:headView];
    
    //赋值
    if(sectionArray.count>0){
        NSMutableDictionary *dic = (NSMutableDictionary *)[sectionArray objectAtIndex:0];
        leftView.text = [dic objectForKey:@"REG_NAME"];
        rightView.text = [dic objectForKey:@"PLAN_CHECK_DATE"];
    }
    
    //contentView
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, rowHeight, ScreenWidth-4, rowHeight*sectionArray.count)];
    float yPosition = 0;
    //sectionArray按照首字母排序
    NSComparator cmptr = ^(id obj1, id obj2){
        NSString *str1 = [obj1 objectForKey:@"STATION_NAME"];
        NSString *str2 = [obj2 objectForKey:@"STATION_NAME"];
        NSComparisonResult result = [str1 localizedCaseInsensitiveCompare:str2];
        return result;
    };
    NSArray *sortSectionArray = [sectionArray sortedArrayUsingComparator:cmptr];
    for(NSMutableDictionary *pieceDic in sortSectionArray){
        UIView *pieceView = [[UIView alloc]initWithFrame:CGRectMake(0, yPosition, ScreenWidth-4, rowHeight)];
        pieceView.layer.borderWidth = 0.5f;
        pieceView.layer.borderColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1].CGColor;
        
        CustomButtonWithData *selectBtn = selectBtn = [CustomButtonWithData buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(5,0,ScreenWidth-5,30 );
        //checkbox状态
        if([[pieceDic objectForKey:@"selected"] isEqualToString:@"1"]) {
            [selectBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_check_on_normal.png"]  scaleToSize:CGSizeMake(25, 25)]forState:UIControlStateNormal];
        }
        else {
            [selectBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_check_off_disable.png"]  scaleToSize:CGSizeMake(25, 25)]forState:UIControlStateNormal];
        }
        selectBtn.customData = pieceDic;
        [selectBtn setTitle:[pieceDic objectForKey:@"STATION_NAME"] forState:UIControlStateNormal];
        selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        selectBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [selectBtn addTarget:self action:@selector(onTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
        [pieceView addSubview:selectBtn];
        
        //title
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 200, rowHeight)];
//        titleLabel.text = [pieceDic objectForKey:@"STATION_NAME"];
//        titleLabel.font = [UIFont boldSystemFontOfSize:13];
//        [pieceView addSubview:titleLabel];
        
        
        [contentView addSubview:pieceView];
        yPosition+=rowHeight;
    }
    [sectionView addSubview:contentView];
    return sectionView;
}

//根据数据返回对应的section的height
-(CGFloat)caculateSectionHeight:(NSArray *)sectionArray{
    return sectionArray.count *rowHeight + rowHeight;
}

-(void)onTouchHandler:(CustomButtonWithData *)sender{
    CustomButtonWithData *selectBtn = (CustomButtonWithData *)sender;
    NSMutableDictionary *pieceDic = (NSMutableDictionary *)selectBtn.customData;
    NSString *selected = [pieceDic objectForKey:@"selected"];
    if([selected isEqualToString:@"0"]){
        [pieceDic setValue:@"1" forKey:@"selected"];
    }else{
        [pieceDic setValue:@"0" forKey:@"selected"];
    }
    [self drawViews];
    [self judgeButtonState];
}

-(void)judgeButtonState{
    BOOL hasSelected = NO;
    BOOL isAllSelected = YES;
    for(NSString *key in planDic.allKeys){
        NSArray *sectionArray = (NSArray *)[planDic objectForKey:key];
        for(NSDictionary *pieceDic in sectionArray){
            if([@"1" isEqualToString:[pieceDic objectForKey:@"selected"]]){
                hasSelected = YES;
            }else{
                isAllSelected = NO;
            }
        }
    }
    if(hasSelected==YES){
        [startBtn setEnabled:YES];
    }else{
        [startBtn setEnabled:NO];
    }
    
    if(isAllSelected == YES ){
        [selectAllbtn setTitle:@"全否" forState:UIControlStateNormal];
    }else{
        [selectAllbtn setTitle:@"全选" forState:UIControlStateNormal];
    }
}

-(NSString *)getSelectRecordNum{
    NSMutableString *str = [[NSMutableString alloc]initWithString:@""];
    for(NSString *key in planDic.allKeys){
        NSArray *sectionArray = (NSArray *)[planDic objectForKey:key];
        for(NSDictionary *pieceDic in sectionArray){
            if([@"1" isEqualToString:[pieceDic objectForKey:@"selected"]]){
                if([@"" isEqualToString:str]){
                    [str appendString:[pieceDic objectForKey:@"RECORD_NUM"]];
                }else{
                    [str appendFormat:@",%@",[pieceDic objectForKey:@"RECORD_NUM"]];
                }
            }
        }
    }
    return str;
}

@end
