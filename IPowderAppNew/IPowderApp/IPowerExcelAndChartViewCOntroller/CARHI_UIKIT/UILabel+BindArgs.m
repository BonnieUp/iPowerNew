//
//  UILabel+BindArgs.m
//  TastyFood
//
//  Created by love_ping891122 on 14/12/13.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import "UILabel+BindArgs.h"
#define HYMAINFont @"fsdf"
@implementation UILabel (BindArgs)
+(instancetype)LabelWithFrame:(CGRect)frame text:(NSString*)textString color:(UIColor*)textColor font:(float)textfont
{
    
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.textColor = textColor;
    label.text = textString;
//    label.font = [UIFont fontWithName:HYMAINFont size:textfont];
    label.font = [UIFont systemFontOfSize:textfont];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+(instancetype)leftLabelWithFrame:(CGRect)frame text:(NSString*)textString color:(UIColor*)textColor font:(float)textfont
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = textColor;
    label.text = textString;
    label.font = [UIFont boldSystemFontOfSize:textfont];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

+(instancetype)RightLabelWithFrame:(CGRect)frame text:(NSString*)textString color:(UIColor*)textColor font:(float)textfont
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = textColor;
    label.text = textString;
    label.font = [UIFont systemFontOfSize:textfont];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}


+(instancetype)RightLabelFontWithFrame:(CGRect)frame text:(NSString*)textString color:(UIColor*)textColor fontName:(UIFont*)textfont
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = textColor;
    label.text = textString;
    label.font = textfont;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}





@end
