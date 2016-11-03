//
//  GuzhangpaixiuFilterConditionViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GuzhangpaixiuFilterConditionViewController.h"
#import "BaseNavigationController.h"
#import "GuzhangpaixiuFilterResultViewController.h"

@interface GuzhangpaixiuFilterConditionViewController ()

@end

@implementation GuzhangpaixiuFilterConditionViewController {
    EditFilterCell *qujvCell;
    EditFilterCell *jvzhanCell;
    EditFilterCell *shebeiCell;
    EditFilterCell *shebeidaleiCell;
    EditFilterCell *guzhangdengjiCell;
    EditFilterCell *guzhangxianxiangCell;
    EditFilterCell *paidanleixingCell;
    EditFilterCell *kaishishijianCell;
    EditFilterCell *jieshushijianCell;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"故障派修查询"];
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
    
    shebeiCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 40) required:NO labelTitle:@"设备" oriValue:nil type:EDITCELL_INPUT];
    [self.view addSubview:shebeiCell];
    
    shebeidaleiCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 120, ScreenWidth, 40) required:NO labelTitle:@"设备大类" oriValue:nil type:EDITCELL_COMBOBOX];
    [self.view addSubview:shebeidaleiCell];
    
    guzhangdengjiCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 160, ScreenWidth, 40) required:NO labelTitle:@"故障等级" oriValue:nil type:EDITCELL_COMBOBOX];
    [self.view addSubview:guzhangdengjiCell];
    
    guzhangxianxiangCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 40) required:NO labelTitle:@"故障现象" oriValue:nil type:EDITCELL_INPUT];
    [self.view addSubview:guzhangxianxiangCell];
    
    paidanleixingCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 240, ScreenWidth, 40) required:NO labelTitle:@"派单类型" oriValue:nil type:EDITCELL_WITCH_CON];
    [paidanleixingCell setSwitchOnImage:[UIImage imageNamed:@"btn_switcher_on_auto_mend.png"] offImage:[UIImage imageNamed:@"btn_switcher_off_auto_mend.png"]];
    [self.view addSubview:paidanleixingCell];
    
    kaishishijianCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 280, ScreenWidth, 40) required:YES labelTitle:@"开始时间" oriValue:nil type:EDITCELL_DATE];
    kaishishijianCell.delegate = self;
    [self.view addSubview:kaishishijianCell];
    
    jieshushijianCell = [[EditFilterCell alloc]initWithFrame:CGRectMake(0, 320, ScreenWidth, 40) required:YES labelTitle:@"结束时间" oriValue:nil type:EDITCELL_DATE];
    jieshushijianCell.delegate = self;
    [self.view addSubview:jieshushijianCell];
    
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

-(void)submitHandler {
    if([[kaishishijianCell getCurrentDic] allKeys].count==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请选择开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if([[jieshushijianCell getCurrentDic] allKeys].count==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSDate *kaishiDate = [kaishishijianCell getCurrentDicWithDate];
    NSDate *jieshuDate = [jieshushijianCell getCurrentDicWithDate];
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
    [dic setValue:[[shebeiCell getCurrentDic] objectForKey:@"value"] forKey:@"shebei"];
    [dic setValue:[[shebeidaleiCell getCurrentDic] objectForKey:@"value"] forKey:@"shebeidalei"];
    [dic setValue:[[guzhangdengjiCell getCurrentDic] objectForKey:@"value"] forKey:@"guzhangdengji"];
    [dic setValue:[[guzhangxianxiangCell getCurrentDic] objectForKey:@"value"] forKey:@"guzhangxianxiang"];
    [dic setValue:[[paidanleixingCell getCurrentDic] objectForKey:@"value"] forKey:@"paidanleixing"];
    [dic setValue:[[kaishishijianCell getCurrentDic] objectForKey:@"value"] forKey:@"kaishishijian"];
    [dic setValue:[[jieshushijianCell getCurrentDic] objectForKey:@"value"] forKey:@"jiesushijian"];
//    if(_delegate && [_delegate respondsToSelector:@selector(guzhangpaixiuFilterOnChange:)]) {
//        [_delegate guzhangpaixiuFilterOnChange:dic];
//        
//        BaseNavigationController *rootCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//        [rootCtrl popViewControllerAnimated:YES];
//    }
    GuzhangpaixiuFilterResultViewController *guzhangResultCtrl = [[GuzhangpaixiuFilterResultViewController alloc]init];
    guzhangResultCtrl.siteList = _siteList;
    BaseNavigationController *rootCtrl = (BaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootCtrl pushViewController:guzhangResultCtrl animated:YES];
    [guzhangResultCtrl searchGaojingWithFilter:dic];
    
}


-(void)setDeviceClassList:(NSArray *)deviceClassList {
    _deviceClassList = deviceClassList;
    shebeidaleiCell.enumDataSource = _deviceClassList;
}

-(void)setGuzhangdengjiList:(NSArray *)guzhangdengjiList {
    _guzhangdengjiList = guzhangdengjiList;
    guzhangdengjiCell.enumDataSource = _guzhangdengjiList;
}

@end
