//
//  UITextView+BindArgs.h
//  TastyFood
//
//  Created by love_ping891122 on 14/12/14.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (BindArgs)
+(instancetype)textViewWithFrame:(CGRect)frame viewTag:(NSInteger)tag viewFont:(CGFloat)font textColor:(UIColor*)tcolor;
+(instancetype)placeholdtextViewWithFrame:(CGRect)frame viewTag:(NSInteger)tag viewFont:(CGFloat)font textColor:(UIColor*)tcolor;



/**
 *  监听限制UITextView字符长度
 *
 *  @param void
 *
 *  用法:  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange::)
 name:@"UITextViewTextDidChangeNotification"
 object:self.nickTextField];
 *
 */
#define kMaxLength 10

-(void)textViewDidChange:(NSNotification *)obj;
@end
