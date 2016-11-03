//
//  UITextField+BindArgs.m
//  TastyFood
//
//  Created by love_ping891122 on 14/12/14.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import "UITextField+BindArgs.h"

@implementation UITextField (BindArgs)
+(instancetype)textFieldWithFrame:(CGRect)frame fieldTag:(NSInteger)tag fieldFont:(CGFloat)font textColor:(UIColor*)tcolor fieldtext:(NSString*)textstring
{
    //用户名
    UITextField*  textField=[[UITextField alloc]initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont fontWithName:@"" size:font];
    textField.returnKeyType= UIReturnKeyDone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = tcolor;
    textField.tag = tag;
    textField.text= textstring;
    
    return textField;
    
    
}




/**
 *  监听限制UITextField字符长度
 *
 *  @param void
 *
 *  @return
 */
#define kMaxLength 15

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

@end
