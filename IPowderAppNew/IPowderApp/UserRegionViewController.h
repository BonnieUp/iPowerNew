//
//  UserRegionViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-1.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//-----------------------------
//用户所能访问的区局视图
//-----------------------------
#import "BaseModalViewController.h"
@protocol UserRegionDelegate <NSObject>

-(void)regionOnSelect:(BaseModalViewController *)ctrl
            regionDic:(NSDictionary *)regionDic;

@end
@interface UserRegionViewController : BaseModalViewController <UIScrollViewDelegate>{
    //背景图
    UIScrollView *containerView;
    NSMutableArray *cells;
}

@property (nonatomic,strong)NSArray *regionList;

@property (nonatomic,strong)NSDictionary *selectRegionDic;

@property (nonatomic,strong) id<UserRegionDelegate> delegate;

@end
