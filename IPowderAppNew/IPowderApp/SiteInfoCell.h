//
//  SiteInfoCell.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-13.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiteInfoCell : UITableViewCell {
    //局站名称
    UILabel * nameLabel;
    //局站类型
    UILabel * typeLabel;
    //按钮
    UIButton *btn;
    
    NSArray *typeArray;
}


@property (nonatomic,strong)NSDictionary *infoDic;

@end
