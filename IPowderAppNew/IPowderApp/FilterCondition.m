//
//  FilterConditionView.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "FilterCondition.h"
#import "PowerDataService.h"
#import "UIGlossyButton.h"
@implementation FilterCondition {
    NSString *shebeidalei;
    NSString *shebeizilei;
    NSString *suoshuxitong;
    NSString *suoshufangjian;
    NSString *shebeimingcheng;
    NSString *zichanbianhao;
    NSString *shiwubianhao;
    NSString *shebeichangjia;
    
    UIView *operateView;
    UIGlossyButton *submitBtn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    [_shebeidaleiBtn setImage:[UIImage imageNamed:@"arrow_right_normal.png"] forState:UIControlStateNormal];
    _shebeidaleiBtn.layer.borderWidth = 0.5;
    _shebeidaleiBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_shebeidaleiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 177, 0, 0)];
    [_shebeidaleiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -23, 0, 0)];
    [_shebeidaleiBtn addTarget:self action:@selector(popShebeidaleiWindow) forControlEvents:UIControlEventTouchUpInside];
    
    [_shebeizileiBtn setImage:[UIImage imageNamed:@"arrow_right_normal.png"] forState:UIControlStateNormal];
    _shebeizileiBtn.layer.borderWidth = 0.5;
    _shebeizileiBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_shebeizileiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 177, 0,0)];
    [_shebeizileiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -23, 0, 0)];
    [_shebeizileiBtn addTarget:self action:@selector(popShebeizileiWindow) forControlEvents:UIControlEventTouchUpInside];
    
    [_suoshuxitongBtn setImage:[UIImage imageNamed:@"arrow_right_normal.png"] forState:UIControlStateNormal];
    _suoshuxitongBtn.layer.borderWidth = 0.5;
    _suoshuxitongBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_suoshuxitongBtn setImageEdgeInsets:UIEdgeInsetsMake(0,177,0,0)];
    [_suoshuxitongBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -23, 0, 0)];
    [_suoshuxitongBtn addTarget:self action:@selector(popSuoshuxitongWindow) forControlEvents:UIControlEventTouchUpInside];
    
    [_suoshufangjianBtn setImage:[UIImage imageNamed:@"arrow_right_normal.png"] forState:UIControlStateNormal];
    _suoshufangjianBtn.layer.borderWidth = 0.5;
    _suoshufangjianBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_suoshufangjianBtn setImageEdgeInsets:UIEdgeInsetsMake(0,177,0,0)];
    [_suoshufangjianBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-23, 0, 0)];
    [_suoshufangjianBtn addTarget:self action:@selector(popSuoshufangjianWindow) forControlEvents:UIControlEventTouchUpInside];
    
    _shebeimingchengInput.layer.borderWidth = 0.5;
    _shebeimingchengInput.layer.borderColor = [UIColor grayColor].CGColor;
    _shebeimingchengInput.delegate = self;
    
    _zichanbianhaoInput.layer.borderWidth = 0.5;
    _zichanbianhaoInput.layer.borderColor = [UIColor grayColor].CGColor;
    _zichanbianhaoInput.delegate = self;
    
    _shiwubianhaoInput.layer.borderWidth = 0.5;
    _shiwubianhaoInput.layer.borderColor = [UIColor grayColor].CGColor;
    _shiwubianhaoInput.delegate = self;
    
    _shebeichangjiaInput.layer.borderWidth = 0.5;
    _shebeichangjiaInput.layer.borderColor = [UIColor grayColor].CGColor;
    _shebeichangjiaInput.delegate = self;
    
    [_zichanbianhaoBtn addTarget:self action:@selector(popZichanbianhaoWindow) forControlEvents:UIControlEventTouchUpInside];
    
    [_shiwubianhaoBtn addTarget:self action:@selector(popShiwubianhaoWindow) forControlEvents:UIControlEventTouchUpInside];
    
    operateView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40, ScreenWidth, 40)];
    operateView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    [self addSubview:operateView];
    [self bringSubviewToFront:operateView];
    
    submitBtn = [[UIGlossyButton alloc]init];
    submitBtn.frame = CGRectMake(5, 5, ScreenWidth-10, 30);
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitBtn addTarget:self action:@selector(submitHandler) forControlEvents:UIControlEventTouchUpInside];
    [operateView addSubview:submitBtn];
    submitBtn.enabled = NO;
}


-(void)layoutSubviews {
    [super layoutSubviews];
}

//弹出设备大类
-(void)popShebeidaleiWindow {
    ShebeidaleiConditionViewController *shebeidaleiCtrl = [[ShebeidaleiConditionViewController alloc]init];
    shebeidaleiCtrl.delegate = self;
    if(shebeidalei!=nil) {
        shebeidaleiCtrl.selectDalei = shebeidalei;
    }
    shebeidaleiCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:shebeidaleiCtrl animated:YES completion:nil];
}

//弹出设备子类
-(void)popShebeizileiWindow {
    if(!shebeidalei) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请选择设备大类" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else {
        //先获取设备大类下的设备子类
        PowerDataService *dataService = [[PowerDataService alloc]init];
        RequestCompleteBlock block = ^(id result) {
            NSArray *zileiList = (NSArray *)result;
            
            ShebeizileiConditionViewController *shebeizileiCtrl = [[ShebeizileiConditionViewController alloc]init];
            shebeizileiCtrl.delegate = self;
            shebeizileiCtrl.zileiList = zileiList;
            if(shebeizilei!=nil) {
                shebeizileiCtrl.selectZilei = shebeizilei;
            }
            shebeizileiCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:shebeizileiCtrl animated:YES completion:nil];
            
        };
        [dataService getSubDeviceWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] devClassNum:shebeidalei devSubClassNum:@"" devSubClassName:@"" devTypeName:@"" completeBlock:block loadingView:nil showHUD:YES];
    }
}

//弹出所属系统
-(void)popSuoshuxitongWindow {
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
            NSArray *suoshuxitongList = (NSArray *)result;
            
            SuoshuxitongConditionViewController *suoshuxitongCtrl = [[SuoshuxitongConditionViewController alloc]init];
            suoshuxitongCtrl.delegate = self;
            suoshuxitongCtrl.suoshuxitongList = suoshuxitongList;
            if(suoshuxitong!=nil) {
                suoshuxitongCtrl.selectSuoshuxitong = suoshuxitong;
            }
            suoshuxitongCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:suoshuxitongCtrl animated:YES completion:nil];
            
        };
    [dataService getUserPowerSystemWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] stationNum:_stationNum sysClassNum:@"" completeBlock:block loadingView:nil showHUD:YES];
}

//弹出所属房间
-(void)popSuoshufangjianWindow {
    PowerDataService *dataService = [[PowerDataService alloc]init];
    RequestCompleteBlock block = ^(id result) {
        NSArray *suoshufangjianList = (NSArray *)result;
        
        SuoshufangjianConditionViewController *suoshufangjianCtrl = [[SuoshufangjianConditionViewController alloc]init];
        suoshufangjianCtrl.delegate = self;
        suoshufangjianCtrl.suoshufangjianList = suoshufangjianList;
        if(suoshufangjian!=nil) {
            suoshufangjianCtrl.selectSuoshufangjian = suoshufangjian;
        }
        suoshufangjianCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:suoshufangjianCtrl animated:YES completion:nil];
        
    };
    [dataService GetUserRoomDataWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"]  stationNum:_stationNum roomName:@"" completeBlock:block loadingView:nil showHUD:YES];
}

//弹出资产编号
-(void)popZichanbianhaoWindow {
    ShebeizichanViewController *shebeizichanCtrl = [[ShebeizichanViewController alloc]init];
    shebeizichanCtrl.delegate = self;
    if(zichanbianhao!=nil) {
        shebeizichanCtrl.selectZichan = zichanbianhao;
    }
    shebeizichanCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:shebeizichanCtrl animated:YES completion:nil];
}

//弹出实物编号
-(void)popShiwubianhaoWindow {
    ShebeishiwuConditionViewController *shebeishiwuCtrl = [[ShebeishiwuConditionViewController alloc]init];
    shebeishiwuCtrl.delegate = self;
    if(shiwubianhao!=nil) {
        shebeishiwuCtrl.selectShiwu = shiwubianhao;
    }
    shebeishiwuCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:shebeishiwuCtrl animated:YES completion:nil];
}

//弹出键盘时显示
-(void)keyboardShowHandler:(id)sender{
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;

    //当键盘显示时，重新设置scroller的contentsize;
    _mainScrollerView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-keyboardSize.height-40);
    _mainScrollerView.contentSize = CGSizeMake(ScreenWidth, 300);
    
    operateView.frame = CGRectMake(0, ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-keyboardSize.height-40, ScreenWidth,40);
}

-(void)keyboardHideHandler:(id)sender {
    //当键盘隐藏时，重新设置scroller的contentsize;
    _mainScrollerView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    _mainScrollerView.contentSize = CGSizeMake(ScreenWidth, 300);
    
    operateView.frame = CGRectMake(0,ScreenHeight-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-40,ScreenWidth,40);
}

//提交筛选条件
-(void)submitHandler {
    if(_delegate && [_delegate respondsToSelector:@selector(submitConditionWithRoomNum:sysNum:articleNum:assetsNum:devMaker:devClassNum:devSubClassNum:)]) {
        [_delegate submitConditionWithRoomNum:suoshufangjian sysNum:suoshuxitong articleNum:shiwubianhao assetsNum:zichanbianhao devMaker:shebeichangjia devClassNum:shebeidalei devSubClassNum:shebeizilei];
    }
}

//判断能否提交
-(void)judgeSubmitState{
    if(shebeidalei || shebeizilei || suoshuxitong || suoshufangjian || shebeimingcheng ||
       shebeichangjia ||zichanbianhao || shiwubianhao) {
        //判断资产编号是否符合条件
       if(zichanbianhao && ![zichanbianhao isEqualToString:@"尚未下达"] &&
          ![zichanbianhao isEqualToString:@"拆分中"] &&
          ![zichanbianhao isEqualToString:@"非资产资源"]) {
           int zichanIntValue = [zichanbianhao intValue];
           //如果不是8位数字
           if([NSString stringWithFormat:@"%i",zichanIntValue].length!=8) {
               [submitBtn setEnabled:NO];
           }else {
               [submitBtn setEnabled:YES];
           }
       }else {
           [submitBtn setEnabled:YES];
       }
       //判断实物编号是否符合条件
        if(shiwubianhao &&  ![shiwubianhao isEqualToString:@"尚未下达"] &&
           ![shiwubianhao isEqualToString:@"拆分中"] &&
           ![shiwubianhao isEqualToString:@"非实物资源"]) {
            int shiwuIntValue = [shiwubianhao intValue];
            //如果不是12位数字
            if([NSString stringWithFormat:@"%i",shiwuIntValue].length!=12) {
                [submitBtn setEnabled:NO];
            }else {
                [submitBtn setEnabled:YES];
            }
        }else {
            [submitBtn setEnabled:YES];
        }
    }else {
        [submitBtn setEnabled:NO];
    }
    
}

#pragma  condition delegate
-(void)submitShebeidaleiCondition:(NSDictionary *)dic {
    shebeidalei = [dic objectForKey:@"value"];
    shebeizilei = nil;
    [_shebeizileiBtn setTitle:@"请选择设备子类" forState:UIControlStateNormal];
    [_shebeidaleiBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
    [_shebeidaleiBtn.titleLabel setTextColor:[UIColor blackColor]];
    [self judgeSubmitState];
}

-(void)submitShebeizileiCondition:(NSDictionary *)dic {
    shebeizilei = [dic objectForKey:@"DEV_SUBCLASS_NUM"];
    [_shebeizileiBtn setTitle:[dic objectForKey:@"DEV_SUBCLASS_NAME"] forState:UIControlStateNormal];
    [_shebeizileiBtn.titleLabel setTextColor:[UIColor blackColor]];
    [self judgeSubmitState];
}

-(void)submitSuoshuxitongCondition:(NSDictionary *)dic {
    suoshuxitong = [dic objectForKey:@"SYS_CLASS_NUM"];
    [_suoshuxitongBtn setTitle:[dic objectForKey:@"SYS_CLASS_NAME"] forState:UIControlStateNormal];
    [_suoshuxitongBtn.titleLabel setTextColor:[UIColor blackColor]];
    [self judgeSubmitState];
}

-(void)submitSuoshufangjianCondition:(NSDictionary *)dic {
    suoshufangjian = [dic objectForKey:@"ROOM_NUM"];
    [_suoshufangjianBtn setTitle:[dic objectForKey:@"ROOM_NAME"] forState:UIControlStateNormal];
    [_suoshufangjianBtn.titleLabel setTextColor:[UIColor blackColor]];
    [self judgeSubmitState];
}

-(void)submitShebeishiwuCondition:(NSString *)str {
    shiwubianhao = str;
    [_shiwubianhaoInput setText:str];
    [_shiwubianhaoInput resignFirstResponder];
    [self judgeSubmitState];
}

-(void)submitShebeizichanCondition:(NSString *)str {
    zichanbianhao = str;
    [_zichanbianhaoInput setText:str];
    [_zichanbianhaoInput resignFirstResponder];
    [self judgeSubmitState];
}


#pragma mark----textfield delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self judgeSubmitState];
    return YES;
}

+(FilterCondition *)instanceFilterCondition {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FilterCondition" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
