//
//  UIView+BindArgs.m
//  IBM
//
//  Created by love_ping891122 on 14-6-25.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import "UIView+BindArgs.h"
#import <objc/runtime.h>

@implementation UIView (BindArgs)

-(void)bindData:(NSString *)key Value:(id)value
{
//    关联的对象
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(id)getData:(NSString *)key
{
    return objc_getAssociatedObject(self, [key cStringUsingEncoding:30]);
    
}

+(instancetype)ViewWithFrame:(CGRect)frame :(UIColor*)bcolor
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:bcolor];
    return view;
}
/*初始化横线方法*/

/*初始化竖线方法*/
+(instancetype)lineViewWithx:(float)linex y:(float)liney height:(float)lineheight :(UIColor*)linecolor
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(linex, liney, 0.5, lineheight)];
    [view setBackgroundColor:linecolor];
    return view;
}

+(void)startShake:(UIView*)shakeView
{
    static NSString * const kAFViewShakerAnimationKey = @"kAFViewShakerAnimationKey";
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx =10;
    animation.delegate = self;
    animation.duration = 0.5;
    animation.values = @[ @(currentTx), @(currentTx + 5), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
    //  4.通常来讲,通过使用 times 这个字段,来给每帧动画指定一个时间。如果你没有指定这些,核心动画就
    //    会通过你在 values 这个字段指定的值分割出时间段。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [shakeView.layer addAnimation:animation forKey:kAFViewShakerAnimationKey];
}



@end
