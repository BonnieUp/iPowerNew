//
//  XudianchiFilterConditionViewController.h
//  i动力
//
//  Created by 王敏 on 16/1/1.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
@protocol XudianchiFilterDelegate <NSObject>

-(void)submitFilterHandler:(NSDictionary *)dic;

@end

@interface XudianchiFilterConditionViewController : BaseViewController


-(void)setXudianchiTitle:(NSString *)title;


@property (nonatomic,strong) NSArray *qujuList;

@property (nonatomic,strong) id<XudianchiFilterDelegate> delegate;

@end
