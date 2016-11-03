//
//  UIImageView+BindArgs.m
//  TastyFood
//
//  Created by love_ping891122 on 14/12/12.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import "UIImageView+BindArgs.h"
#import <objc/runtime.h>

@implementation UIImageView (BindArgs)
/*创建有带image的imageview*/
+(instancetype)imageViewWithFrame:(CGRect)frame :(NSString*)imageName
{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:frame];
    imageview.image = [UIImage imageNamed:imageName];
    return imageview;
}

-(void)bindData:(NSString *)key Value:(id)value
{
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)getData:(NSString *)key
{
    return objc_getAssociatedObject(self, [key cStringUsingEncoding:30]);
}

@end
