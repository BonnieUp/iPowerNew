//
//  PinfangaojingViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
@protocol PinfangaojingDelegate <NSObject>

-(void)setPinfangaojingAmount:(NSString *)amount;

@end

@interface PinfangaojingViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) id<PinfangaojingDelegate> delegate;
@property (nonatomic,strong) NSArray *siteList;

-(void)searchGaojingWithFilter:(NSDictionary *)dic;

-(void)getPinfangaojingWithregNum:(NSString *)regNum
                      stationName:(NSString *)stationName
                          devName:(NSString *)devName
                        pointName:(NSString *)pointName
                       alarmCount:(NSString *)alarmCount
                        startTime:(NSString *)startTime
                         stopTime:(NSString *)stopTime;
@end
