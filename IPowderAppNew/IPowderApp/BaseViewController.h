//
//  BaseViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController

-(void)backAction;

-(void)setTitleWithPosition:(NSString *)position
                      title:(NSString *)title;

-(NSString *)getCustomTitle;

@property (nonatomic,strong) UIFont *titleFont;

@end
