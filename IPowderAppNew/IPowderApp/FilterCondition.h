//
//  FilterConditionView.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShebeidaleiConditionViewController.h"
#import "ShebeizileiConditionViewController.h"
#import "SuoshuxitongConditionViewController.h"
#import "SuoshufangjianConditionViewController.h"
#import "ShebeishiwuConditionViewController.h"
#import "ShebeizichanViewController.h"
@protocol conditionViewDelegate <NSObject>
@optional
//当选择设备大类以后点击提交触发
-(void)submitConditionWithRoomNum:(NSString *)roomNum
                           sysNum:(NSString *)sysNum
                       articleNum:(NSString *)articleNum
                        assetsNum:(NSString *)assetsNum
                         devMaker:(NSString *)devMaker
                      devClassNum:(NSString *)devClassNum
                   devSubClassNum:(NSString *)devSubClassNum;
@end

@interface FilterCondition : UIView<ShebeidaleiConditionDelegate,ShebeizileiConditionDelegate,SuoshuxitongConditionDelegate,SuoshufangjainConditionDelegate,ShebeishiwuConditionDelegate,ShebeizichanConditionDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *shebeidaleiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shebeizileiBtn;
@property (weak, nonatomic) IBOutlet UIButton *suoshuxitongBtn;
@property (weak, nonatomic) IBOutlet UIButton *suoshufangjianBtn;
@property (weak, nonatomic) IBOutlet UITextField *shebeimingchengInput;
@property (weak, nonatomic) IBOutlet UITextField *zichanbianhaoInput;
@property (weak, nonatomic) IBOutlet UITextField *shiwubianhaoInput;
@property (weak, nonatomic) IBOutlet UITextField *shebeichangjiaInput;
@property (weak, nonatomic) IBOutlet UIButton *zichanbianhaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *shiwubianhaoBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollerView;

@property (nonatomic,strong) NSString *stationNum;
//@property (weak, nonatomic) IBOutlet UIView *operateView;
//
//@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

+(FilterCondition *)instanceFilterCondition;

@property (nonatomic,strong) id<conditionViewDelegate>delegate;

-(void)keyboardShowHandler:(id)sender;
-(void)keyboardHideHandler:(id)sender;


@end
