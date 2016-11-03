//
//  UIScrollView+BindArgs.m
//  TastyFood
//
//  Created by love_ping891122 on 14/12/12.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import "UIScrollView+BindArgs.h"

@implementation UIScrollView (BindArgs)
+(instancetype)ScrollViewWithFrame:(CGRect)Scrollframe contentSize:(CGSize)ScrollContentsize tag:(NSInteger)ScrollTag
{
    UIScrollView *Scrollview = [[UIScrollView alloc]initWithFrame:Scrollframe];
    Scrollview.tag = 501;
    Scrollview.bounces = YES;
    Scrollview.pagingEnabled = NO;
    Scrollview.showsHorizontalScrollIndicator = NO;
    Scrollview.userInteractionEnabled = YES;
    [Scrollview setContentSize:ScrollContentsize]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [Scrollview setContentOffset:CGPointMake(0, 0)];
    
    return Scrollview;
}
@end
