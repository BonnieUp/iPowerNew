//
//  GuzhangpaixiuFilterConditionViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "EditFilterCell.h"
@protocol GuzhangpaixiuFilterDelegate <NSObject>
@optional
-(void)guzhangpaixiuFilterOnChange:(NSDictionary *)dic;
@end
@interface GuzhangpaixiuFilterConditionViewController : BaseViewController<EditFilterCellDelegate>

@property (nonatomic,strong) NSArray *siteList;
@property (nonatomic,strong) id<GuzhangpaixiuFilterDelegate>delegate;
@property (nonatomic,strong) NSArray *deviceClassList;
@property (nonatomic,strong) NSArray *guzhangdengjiList;
@end
