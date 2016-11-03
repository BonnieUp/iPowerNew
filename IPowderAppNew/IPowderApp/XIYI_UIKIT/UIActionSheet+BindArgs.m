//
//  UIActionSheet+BindArgs.m
//  Meiquer
//
//  Created by meiquan on 15/4/13.
//  Copyright (c) 2015年 Bin WU. All rights reserved.
//

#import "UIActionSheet+BindArgs.h"
#import <objc/runtime.h>

@implementation UIActionSheet (BindArgs)

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
