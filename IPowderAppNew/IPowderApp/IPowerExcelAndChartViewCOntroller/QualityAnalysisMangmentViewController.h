//
//  QualityAnalysisMangmentViewController.h
//  i动力
//
//  Created by 丁浪平 on 16/3/19.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "MangmentFViewController.h"
#import "MangmentSViewController.h"
@interface QualityAnalysisMangmentViewController : BaseTabBarViewController<UIAlertViewDelegate> {
    MangmentFViewController *FVC;
    MangmentSViewController *SVC;
    
    
    BOOL backToHomePage;
    
    //告警tab
    GaojingViewController *gaojingCtrl;
    //观察列表tab
    GuanchaViewController *guanchaCtrl;
    //故障派修tab
    GuzhangpaixiuViewController *guzhangpaixiuCtrl;
    
}
@property (nonatomic, strong)MangmentFViewController *FVC;
@property (nonatomic, strong)MangmentSViewController *SVC;

@property (nonatomic) BOOL backToHomePage;

//barbutton数组
@property (nonatomic, strong) NSMutableArray *tabs;


@property (nonatomic,strong) NSString *titleStr;

@property (nonatomic,strong) NSArray *siteList;

@end
