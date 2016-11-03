//
//  PinfangaojingFilterViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"
#import "EditFilterCell.h"
@protocol PinfangaojingFilterDelegate <NSObject>
@optional
-(void)pinfangaojingFilterOnChange:(NSDictionary *)dic;
@end
@interface PinfangaojingFilterViewController : BaseViewController<EditFilterCellDelegate>

@property (nonatomic,strong) NSArray *siteList;
@property (nonatomic,strong) id<PinfangaojingFilterDelegate>delegate;

@end
