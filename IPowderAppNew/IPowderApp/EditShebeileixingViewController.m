//
//  EditShebeileixingViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "EditShebeileixingViewController.h"
#import "UIGlossyButton.h"
#import "PowerDataService.h"
@interface EditShebeileixingViewController ()

@end

@implementation EditShebeileixingViewController {
    UILabel *oriDeviceTypeLabel;
    UIButton *shebeidaleiBtn;
    UIButton *shebeizileiBtn;
    UIButton *shebeileixingBtn;
    
    UIView *shebeidaleiContainerView;
    UIView *shebeizileiContainerView;
    UIView *shebeileixingContainerView;
    
    NSMutableDictionary *shebeidalei;
    NSMutableDictionary *shebeizilei;
    NSMutableDictionary *shebeileixing;
    
    UIGlossyButton *submitBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"选择设备类型"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *oriTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    oriTypeView.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
    oriDeviceTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    oriDeviceTypeLabel.textAlignment = NSTextAlignmentCenter;
    oriDeviceTypeLabel.font = [UIFont systemFontOfSize:14];
    oriDeviceTypeLabel.backgroundColor = [UIColor clearColor];
    [oriTypeView addSubview:oriDeviceTypeLabel];
    [self.view addSubview:oriTypeView];
    
    shebeidaleiContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 40)];
    //设备大类
    UILabel *shebeidaleiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 39)];
    shebeidaleiLabel.text = @"设备大类";
    shebeidaleiLabel.textAlignment = NSTextAlignmentCenter;
    shebeidaleiLabel.font = [UIFont systemFontOfSize:14];
    shebeidaleiLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [shebeidaleiContainerView addSubview:shebeidaleiLabel];
    
    UIView *shebeidaleiSeperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
    shebeidaleiSeperateView.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
    [shebeidaleiContainerView addSubview:shebeidaleiSeperateView];
    
    shebeidaleiBtn = [self createButton];
    shebeidaleiBtn.frame = CGRectMake(85, 3, ScreenWidth-90, 33);
    [shebeidaleiBtn setTitle:@"请选择设备大类" forState:UIControlStateNormal];
    [shebeidaleiBtn addTarget:self action:@selector(shebeidaleiOnClickHandler) forControlEvents:UIControlEventTouchUpInside];
    shebeidaleiBtn.layer.borderWidth = 0.5;
    shebeidaleiBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [shebeidaleiContainerView addSubview:shebeidaleiBtn];
    [self.view addSubview:shebeidaleiContainerView];
    //设备子类
    shebeizileiContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 40)];
    UILabel *shebeizileiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 80, 39)];
    shebeizileiLabel.text = @"设备子类";
    shebeizileiLabel.textAlignment = NSTextAlignmentCenter;
    shebeizileiLabel.font = [UIFont systemFontOfSize:14];
    shebeizileiLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [shebeizileiContainerView addSubview:shebeizileiLabel];
    
    UIView *shebeizileiSeperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
    shebeizileiSeperateView.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
    [shebeizileiContainerView addSubview:shebeizileiSeperateView];
    
    shebeizileiBtn = [self createButton];
    shebeizileiBtn.frame = CGRectMake(85, 3, ScreenWidth-90, 33);
    [shebeizileiBtn setTitle:@"请选择设备子类" forState:UIControlStateNormal];
    [shebeizileiBtn addTarget:self action:@selector(shebeizileiOnClickHandler) forControlEvents:UIControlEventTouchUpInside];
    shebeizileiBtn.layer.borderWidth = 0.5;
    shebeizileiBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [shebeizileiContainerView addSubview:shebeizileiBtn];
    shebeizileiContainerView.hidden = YES;
    
    [self.view addSubview:shebeizileiContainerView];
    
    //设备类型
    shebeileixingContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, ScreenWidth, 40)];
    UILabel *shebeileixingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 80, 39)];
    shebeileixingLabel.text = @"设备类型";
    shebeileixingLabel.textAlignment = NSTextAlignmentCenter;
    shebeileixingLabel.font = [UIFont systemFontOfSize:14];
    shebeileixingLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [shebeileixingContainerView addSubview:shebeileixingLabel];
    
    UIView *shebeileixingSeperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
    shebeileixingSeperateView.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
    [shebeileixingContainerView addSubview:shebeileixingSeperateView];
    
    shebeileixingBtn = [self createButton];
    shebeileixingBtn.frame = CGRectMake(85, 3, ScreenWidth-90, 33);
    [shebeileixingBtn setTitle:@"请选择设备的具体类型" forState:UIControlStateNormal];
    [shebeileixingBtn addTarget:self action:@selector(shebeileixingOnClickHandler) forControlEvents:UIControlEventTouchUpInside];
    shebeileixingBtn.layer.borderWidth = 0.5;
    shebeileixingBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [shebeileixingContainerView addSubview:shebeileixingBtn];
    shebeileixingContainerView.hidden = YES;
    [self.view addSubview:shebeileixingContainerView];
    
    
    //submitbutton
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-40, ScreenWidth, 40)];
     operationView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    submitBtn = [[UIGlossyButton alloc]init];
    submitBtn.frame = CGRectMake(10,5,ScreenWidth-20, 30);
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [operationView addSubview:submitBtn];
    submitBtn.enabled = NO;
    [submitBtn addTarget:self action:@selector(submitShebeileixing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:operationView];
}

-(UIButton *)createButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"arrow_right_normal.png"] scaleToSize:CGSizeMake(15,15)] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, ScreenWidth-105, 0,5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -12,0,20);
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    return btn;
}

-(void)shebeidaleiOnClickHandler {
    ShebeidaleiConditionViewController *shebeidaleiCtrl = [[ShebeidaleiConditionViewController alloc]init];
    shebeidaleiCtrl.delegate = self;
    shebeidaleiCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:shebeidaleiCtrl animated:YES completion:nil];
}

-(void)shebeizileiOnClickHandler {
    //先获取设备大类下的设备子类
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        NSArray *zileiList = (NSArray *)result;
        
        ShebeizileiConditionViewController *shebeizileiCtrl = [[ShebeizileiConditionViewController alloc]init];
        shebeizileiCtrl.delegate = self;
        shebeizileiCtrl.zileiList = zileiList;
        shebeizileiCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:shebeizileiCtrl animated:YES completion:nil];
        
    };
    [dataService getSubDeviceWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devClassNum:[shebeidalei objectForKey:@"value"] devSubClassNum:@"" devSubClassName:@"" devTypeName:@"" completeBlock:block loadingView:nil showHUD:YES];
}

-(void)shebeileixingOnClickHandler {
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        NSMutableArray *enumDatasource = [[NSMutableArray alloc]init];
        NSArray *zileiList = (NSArray *)result;
        for (NSDictionary *item in zileiList) {
            NSMutableDictionary *enumDic = [[NSMutableDictionary alloc]init];
            [enumDic setValue:[item objectForKey:@"DEV_TYPE_NAME"] forKey:@"name"];
            [enumDic setValue:[item objectForKey:@"DEV_TYPE_NUM"] forKey:@"value"];
            [enumDatasource addObject:enumDic];
        }
        CommonPropertyModelViewController *propertyCtrl = [[CommonPropertyModelViewController alloc]init];
        propertyCtrl.delegate = self;
        propertyCtrl.titleStr = @"设备类型";
        propertyCtrl.dataList = enumDatasource;
        propertyCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:propertyCtrl animated:YES completion:nil];
        
    };
    [dataService GetDeviceTypeDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devClassNum:[shebeidalei objectForKey:@"value"] devSubClassNum:[shebeizilei objectForKey:@"value"] devSubClassName:@"" devTypeName:@"" completeBlock:block loadingView:nil showHUD:YES];
}

-(void)setOriTypeName:(NSString *)oriTypeName {
    _oriTypeName = oriTypeName;
    oriDeviceTypeLabel.text = _oriTypeName;
}

#pragma -- shebeidalei delegate
-(void)submitShebeidaleiCondition:(NSDictionary *)dic {
    shebeidalei = [NSMutableDictionary dictionaryWithDictionary:dic];
    [shebeidaleiBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
    shebeizileiContainerView.hidden = NO;
    
    shebeizilei = nil;
    [shebeizileiBtn setTitle:@"请选择设备子类" forState:UIControlStateNormal];
    submitBtn.enabled = NO;
    
    shebeileixing = nil;
    [shebeileixingBtn setTitle:@"请选择设备类型" forState:UIControlStateNormal];
    submitBtn.enabled = NO;
}

-(void)submitShebeizileiCondition:(NSDictionary *)dic {
    shebeizilei = [[NSMutableDictionary alloc]init];
    [shebeizilei setValue:[dic objectForKey:@"DEV_SUBCLASS_NAME"] forKey:@"name"];
    [shebeizilei setValue:[dic objectForKey:@"DEV_SUBCLASS_NUM"] forKey:@"value"];
    [shebeizileiBtn setTitle:[shebeizilei objectForKey:@"name"] forState:UIControlStateNormal];
    shebeileixingContainerView.hidden = NO;
    shebeileixing = nil;
    [shebeileixingBtn setTitle:@"请选择设备类型" forState:UIControlStateNormal];
    submitBtn.enabled = NO;
}

-(void)submitHandler:(NSDictionary *)dic {
    shebeileixing = [NSMutableDictionary dictionaryWithDictionary:dic];
    [shebeileixingBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
    submitBtn.enabled = YES;
    
}

-(void)submitShebeileixing {
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc]init];
    [returnDic setValue:[NSString stringWithFormat:@"%@-%@-%@",[shebeidalei objectForKey:@"name"],[shebeizilei objectForKey:@"name"],[shebeileixing objectForKey:@"name"]] forKey:@"name"];
    [returnDic setValue:[shebeileixing objectForKey:@"value"] forKey:@"value"];
    
    if(_delegate && [_delegate respondsToSelector:@selector(submitDeviceleixing:)]) {
        [_delegate submitDeviceleixing:returnDic];
        
        
    }
}
@end
