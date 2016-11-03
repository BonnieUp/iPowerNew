//
//  UIColor+TwoMiles.m
//  MyApp
//
//  Created by Dong Yiming on 2/3/15.
//  Copyright (c) 2015 dlt. All rights reserved.
//

#import "UIColor+TwoMiles.h"

@implementation UIColor (TwoMiles)

+(UIColor *)random
{
    return [self colorFromR:(arc4random() % 255) g:(arc4random() % 255) b:(arc4random() % 255)];
}

+(UIColor *)appMainGreen {
    return [UIColor colorFromR:126 g:211 b:33];
}

+(UIColor *)appMainBackground {
    return [UIColor colorFromR:243 g:242 b:242];
}

+(UIColor *)drivingSchoolGreen {
    return [UIColor colorFromR:28 g:175 b:35];
}

+(UIColor *)drivingSchoolGray {
    return [UIColor colorFromR:152 g:152 b:152];
}

+(UIColor *)naviBar {
    return [UIColor colorFromR:255 g:255 b:255 a:0.8];
}

+(UIColor *)naviBarTitle {
    return [UIColor colorFromR:65 g:65 b:77];
}


+(UIColor *)tabbarTitleNormal {
    return [UIColor colorFromR:151 g:151 b:151];
}

+(UIColor *)tabbarBg {
    return [UIColor colorFromR:255 g:255 b:255];
}

+(UIColor *)tabbarTopLine {
    return [UIColor colorFromR:178 g:178 b:178 a:0.5];
}


+(UIColor *)buttonTitleNormal {
    return [UIColor colorFromR:151 g:151 b:151];
}

+(UIColor *)buttonBgNormal {
    return [UIColor colorFromR:243 g:243 b:243];
}

+(UIColor *)titleGray {
    return [UIColor colorFromR:151 g:151 b:151];
}


#pragma mark - convienience

+(UIColor *)colorFromR:(int)aRed g:(int)aGreen b:(int)aBlue
{
    return [self colorFromR:aRed g:aGreen b:aBlue a:1.f];
}

+(UIColor *)colorFromR:(int)aRed g:(int)aGreen b:(int)aBlue a:(CGFloat)anAlpha
{
    return [UIColor colorWithRed:aRed / 255.f green:aGreen / 255.f blue:aBlue / 255.f alpha:anAlpha];
}

+(UIColor *)colorWithString:(NSString *)colorString{
    long x;
    NSString *_str;
    //如果是八位
    if([colorString length] == 9)
    {
        //取前两位alpha值
        NSString *alpha = [colorString substringToIndex:3];
        
        //取后面的几位颜色值
        NSString *color = [colorString substringFromIndex:3];
        const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
        x = strtol(cStr+1, NULL, 16);
        //_str = [NSString stringWithFormat:@"#%@",color];
        
        return [self colorWithHex:(UInt32)x withAlpha:alpha];
    }
    //如果是6位的颜色
    else if([colorString length] == 7){
        const char *cStr = [colorString cStringUsingEncoding:NSASCIIStringEncoding];
        x = strtol(cStr+1, NULL, 16);
        _str = @"#FF";
    }
    //如果格式不对就直接返回黑色颜色
    else
        return [UIColor blackColor];
    return [self colorWithHex:(UInt32)x withAlpha:_str];
}

+(UIColor *)colorWithHex:(UInt32)col withAlpha:(NSString*)alphaStr
{
    unsigned int r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    
    const char* aStr = [alphaStr cStringUsingEncoding:NSASCIIStringEncoding];
    long value = strtol(aStr+1, NULL, 16);
    CGFloat _alpha = (float)(value & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:_alpha];
}

@end
