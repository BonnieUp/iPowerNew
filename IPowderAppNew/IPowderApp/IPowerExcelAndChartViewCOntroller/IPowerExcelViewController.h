//
//  IPowerExcelViewController.h
//  i动力
//
//  Created by 丁浪平 on 16/3/18.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPowerExcelViewController : BaseViewController{
    
    NSString     *stringName;
    NSDictionary * dicInfo;

}

@property(nonatomic,copy)NSString     *stringName;
@property(nonatomic,copy)NSDictionary * dicInfo;

@end
