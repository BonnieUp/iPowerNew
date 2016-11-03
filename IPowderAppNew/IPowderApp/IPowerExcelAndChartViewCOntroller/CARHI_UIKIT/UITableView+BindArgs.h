//
//  UITableView+BindArgs.h
//  TastyFood
//
//  Created by love_ping891122 on 14/12/12.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (BindArgs)

/*创建有带image的imageview*/
+(instancetype)tableViewWithFrame:(CGRect)frame tag:(NSInteger)tableTag;

@end
