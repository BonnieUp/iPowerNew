//
//  UIImage+ImageHeigth.m
//  Meiquer
//
//  Created by Bin WU on 15/1/2.
//  Copyright (c) 2015年 Bin WU. All rights reserved.
//

#import "UIImage+ImageHeigth.h"

@implementation UIImage (ImageHeigth)
+ (CGFloat)height:(UIImage *)contentImage widthOfFatherView:(CGFloat)width
{
    CGSize size = CGSizeMake(width, (width/contentImage.size.width)*contentImage.size.height);
    return size.height;
}

@end
