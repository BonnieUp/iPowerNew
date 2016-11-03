//
//  UIGestureRecognizer+BingArgs.m
//  KoreaProject
//
//  Created by meiquan on 15/6/9.
//  Copyright (c) 2015年 meiquan. All rights reserved.
//

#import "UIGestureRecognizer+BingArgs.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (BingArgs)








-(void)bindData:(NSString *)key Value:(id)value
{
    //    关联的对象
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(id)getData:(NSString *)key
{
    return objc_getAssociatedObject(self, [key cStringUsingEncoding:30]);
    
}

@end
