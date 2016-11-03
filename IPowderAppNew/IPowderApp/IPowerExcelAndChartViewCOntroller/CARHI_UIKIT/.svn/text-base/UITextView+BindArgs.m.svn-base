//
//  UITextView+BindArgs.m
//  TastyFood
//
//  Created by love_ping891122 on 14/12/14.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import "UITextView+BindArgs.h"

@implementation UITextView (BindArgs)

+(instancetype)textViewWithFrame:(CGRect)frame viewTag:(NSInteger)tag viewFont:(CGFloat)font textColor:(UIColor*)tcolor
{
    UITextView *textview = [[UITextView alloc]initWithFrame:frame];
    textview.backgroundColor = [UIColor clearColor];
    textview.tag = tag;
//    textview.font = [UIFont fontWithName:HYFontFamily size:font];
    textview.textColor = tcolor;
    return textview;
}


#define kMaxLength 10

-(void)textViewDidChange:(NSNotification *)obj
{
    UITextView *textField = (UITextView *)obj.object;
    
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
