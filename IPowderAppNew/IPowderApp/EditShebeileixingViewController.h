//
//  EditShebeileixingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseModalViewController.h"
#import "ShebeidaleiConditionViewController.h"
#import "ShebeizileiConditionViewController.h"
#import "CommonPropertyModelViewController.h"
@protocol EditShebeileixingDelegate <NSObject>

-(void)submitDeviceleixing:(NSDictionary *)dic;

@end

@interface EditShebeileixingViewController : BaseViewController<ShebeidaleiConditionDelegate,ShebeizileiConditionDelegate,CommonPropertyDelegate>

@property (nonatomic,strong) NSString *oriTypeName;

@property (nonatomic,strong) id<EditShebeileixingDelegate> delegate;

@end
