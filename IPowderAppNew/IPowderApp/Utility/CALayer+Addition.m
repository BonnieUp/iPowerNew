//
//  CALayer+Addition.m
//  SXMedia
//
//  Created by Bonnie on 16/10/19.
//  Copyright © 2016年 lixiaopo. All rights reserved.
//

#import "CALayer+Addition.h"


@implementation CALayer (Additions)

//static const void *borderColorFromUIColorKey = &borderColorFromUIColorKey;

//@dynamic borderColorFromUIColor;

-(void)setBorderUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;

}

-(UIColor *)borderUICOlor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
