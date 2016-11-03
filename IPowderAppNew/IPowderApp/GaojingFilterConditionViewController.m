//
//  GaojingFilterConditionViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GaojingFilterConditionViewController.h"

#import "UIGlossyButton.h"
#import "UnEditPropertyCell.h"
#import "BaseNavigationController.h"
#import "DangqianfilterResultViewController.h"
#import "LishigaojingFilterResultViewController.h"
#import "ZhongdagaojingFilterResultViewController.h"

@interface GaojingFilterConditionViewController ()

@end

@implementation GaojingFilterConditionViewController {
    EditFilterCell *qujvCell;
    EditFilterCell *jvzhanCell;
    EditFilterCell *shebeidaleiCell;
    EditFilterCell *gaojingdengjiCell;
    EditFilterCell *gaojingyuanyinCell;
    EditFilterCell *kaishishijianCell;
    EditFilterCell *jiesushijianCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    qujvCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) required:NO labelTitle:@"区局" oriValue:nil type:EDITCELL_LABEL];
//    [self.view addSubview:qujvCell];
    
    jvzhanCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 40) required:NO labelTitle:@"局站" oriValue:nil type:EDITCELL_INPUT];
    [self.view addSubview:jvzhanCell];
    
    shebeidaleiCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 40) required:NO labelTitle:@"设备大类" oriValue:nil type:EDITCELL_COMBOBOX];
    [self.view addSubview:shebeidaleiCell];
    
    gaojingdengjiCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 120, ScreenWidth, 40) required:NO labelTitle:@"告警等级" oriValue:nil type:EDITCELL_COMBOBOX];
    [self.view addSubview:gaojingdengjiCell];
    
    gaojingyuanyinCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 160, ScreenWidth, 40) required:NO labelTitle:@"告警原因" oriValue:nil type:EDITCELL_INPUT];
    [self.view addSubview:gaojingyuanyinCell];
    
    kaishishijianCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 40) required:YES labelTitle:@"开始时间" oriValue:nil type:EDITCELL_DATE];
    kaishishijianCell.delegate = self;
    [self.view addSubview:kaishishijianCell];
    
    jiesushijianCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 240, ScreenWidth, 40) required:YES labelTitle:@"结束时间" oriValue:nil type:EDITCELL_DATE];
    jiesushijianCell.delegate = self;
    [self.view addSubview:jiesushijianCell];
    
    UIView *operateView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40, ScreenWidth, 40)];
    operateView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    
    UIGlossyButton *submitBtn = [[UIGlossyButton alloc]init];
    submitBtn.frame = CGRectMake(10, 5, ScreenWidth-20, 30);
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitBtn addTarget:self action:@selector(submitHandler) forControlEvents:UIControlEventTouchUpInside];
    [operateView addSubview:submitBtn];
    [self.view addSubview:operateView];
    
    //添加tap事件
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(hideKeyboard) ];
    [self.view addGestureRecognizer:tapGes];
    
}

-(void)popDatePickerActionSheet {
    [self hideKeyboard];
}

-(void)hideKeyboard {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)setSiteList:(NSArray *)siteList {
    _siteList = siteList;
    [self changeQujvPiece];
}

-(void)changeQujvPiece {

    //如果只有一个可选区局
    if(_siteList.count == 1) {
        qujvCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) required:NO labelTitle:@"区局" oriValue:nil type:EDITCELL_LABEL];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSDictionary *siteDic = [_siteList objectAtIndex:0];
        [dic setValue:[siteDic objectForKey:@"REG_NAME"] forKey:@"name"];
        [dic setValue:[siteDic objectForKey:@"REG_NUM"] forKey:@"value"];
        [qujvCell setCurrentDic:dic];
        [self.view addSubview:qujvCell];
    }else {
        qujvCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) required:NO labelTitle:@"区局" oriValue:nil type:EDITCELL_COMBOBOX];
        NSMutableArray *siteArray =[[NSMutableArray alloc]init];
        for (NSDictionary *itemDic in _siteList) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[itemDic objectForKey:@"REG_NAME"] forKey:@"name"];
            [dic setValue:[itemDic objectForKey:@"REG_NUM"] forKey:@"value"];
            [siteArray addObject:dic];
        }
        qujvCell.enumDataSource = siteArray;
        [self.view addSubview:qujvCell];
    }
}

-(void)setDeviceClassList:(NSArray *)deviceClassList {
    _deviceClassList = deviceClassList;
    shebeidaleiCell.enumDataSource = _deviceClassList;
}

-(void)setGaojingdengjiList:(NSArray *)gaojingdengjiList {
    _gaojingdengjiList = gaojingdengjiList;
    gaojingdengjiCell.enumDataSource = _gaojingdengjiList;
}

-(void)submitHandler {
    if([[kaishishijianCell getCurrentDic] allKeys].count==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请选择开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if([[jiesushijianCell getCurrentDic] allKeys].count==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSDate *kaishiDate = [kaishishijianCell getCurrentDicWithDate];
    NSDate *jieshuDate = [jiesushijianCell getCurrentDicWithDate];
    //结束时间不能比开始时间早
    if([jieshuDate compare:kaishiDate]==NSOrderedAscending) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"结束时间不能早于开始时间，请从新选择日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    //如果是单区局用户，起止时间间隔不能超出31天
    if(_siteList.count == 1){
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = nil;
        comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:jieshuDate];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:-31];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:jieshuDate options:0];
        if([kaishiDate compare:newdate]==NSOrderedAscending) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"起止时间间隔超出1月，请从新选择日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }else if(_siteList.count > 1){
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = nil;
        comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:jieshuDate];
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:-7];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:jieshuDate options:0];
        if([kaishiDate compare:newdate]==NSOrderedAscending) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"起止时间间隔超出1周，请从新选择日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[[qujvCell getCurrentDic] objectForKey:@"value"] forKey:@"qujv"];
    [dic setValue:[[jvzhanCell getCurrentDic] objectForKey:@"value"] forKey:@"jvzhan"];
    [dic setValue:[[shebeidaleiCell getCurrentDic] objectForKey:@"value"] forKey:@"shebeidalei"];
    [dic setValue:[[gaojingdengjiCell getCurrentDic] objectForKey:@"value"] forKey:@"gaojingdengji"];
    [dic setValue:[[gaojingyuanyinCell getCurrentDic] objectForKey:@"value"] forKey:@"gaojingyuanyin"];
    [dic setValue:[[kaishishijianCell getCurrentDic] objectForKey:@"value"] forKey:@"kaishishijian"];
    [dic setValue:[[jiesushijianCell getCurrentDic] objectForKey:@"value"] forKey:@"jiesushijian"];
//    if(_delegate && [_delegate respondsToSelector:@selector(gaojingFilterOnChange:)]) {
//        BaseNavigationController *rootCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//        [rootCtrl popViewControllerAnimated:NO];
//        
//        [_delegate gaojingFilterOnChange:dic];
//        
//
//    }
    //当前告警
    if( [_selectTabIndex isEqualToString:@"1"]){
        DangqianfilterResultViewController *dangqianResultCtrl = [[DangqianfilterResultViewController alloc]init];
        dangqianResultCtrl.siteList = _siteList;
        BaseNavigationController *rootCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [rootCtrl pushViewController:dangqianResultCtrl animated:YES];
        [dangqianResultCtrl searchGaojingWithFilter:dic];
    }
    //历史告警
    else if([_selectTabIndex isEqualToString:@"2"]) {
        LishigaojingFilterResultViewController *lishiResultCtrl = [[LishigaojingFilterResultViewController alloc]init];
        lishiResultCtrl.siteList = _siteList;
        BaseNavigationController *rootCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [rootCtrl pushViewController:lishiResultCtrl animated:YES];
        [lishiResultCtrl searchGaojingWithFilter:dic];
    }else if([_selectTabIndex isEqualToString:@"3"]) {
        ZhongdagaojingFilterResultViewController *zhongdaResultCtrl = [[ZhongdagaojingFilterResultViewController alloc]init];
        zhongdaResultCtrl.siteList = _siteList;
        BaseNavigationController *rootCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [rootCtrl pushViewController:zhongdaResultCtrl animated:YES];
        [zhongdaResultCtrl searchGaojingWithFilter:dic];
    }
}
@end
