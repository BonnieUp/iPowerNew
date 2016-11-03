//
//  UIGestureRecognizer+BingArgs.h
//  KoreaProject
//
//  Created by meiquan on 15/6/9.
//  Copyright (c) 2015年 meiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (BingArgs)
-(void)bindData:(NSString *)key Value:(id)value;
-(id)getData:(NSString *)key;
@end
