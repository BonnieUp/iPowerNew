//
//  FilterConditionListViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterCondition.h"
#import "UIGlossyButton.h"
#import "FilterCondition.h"
@interface FilterConditionListViewController : BaseViewController {
//    UIGlossyButton *submitBtn;
}

@property (nonatomic,strong) NSString *stationNum;

@property (nonatomic,strong) FilterCondition *conditionView;
@end
