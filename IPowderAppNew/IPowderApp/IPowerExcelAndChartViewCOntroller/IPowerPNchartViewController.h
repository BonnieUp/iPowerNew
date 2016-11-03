//
//  IPowerPNchartViewController.h
//  i动力
//
//  Created by 丁浪平 on 16/3/18.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPowerPNchartViewController : BaseViewController
{
    NSString *TitleString;
    NSArray *dataSource;
}
@property(nonatomic,strong)    NSString *TitleString;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSArray *itemtitleS;

@end
