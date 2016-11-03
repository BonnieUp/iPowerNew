//
//  UIAlertView+BindArgs.m
//  IBM
//
//  Created by love_ping891122 on 14-8-15.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import "UIAlertView+BindArgs.h"
#import <objc/runtime.h>

@implementation UIAlertView (BindArgs)


-(void)bindData:(NSString *)key Value:(id)value
{
    //    关联的对象
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(id)getData:(NSString *)key
{
    return objc_getAssociatedObject(self, [key cStringUsingEncoding:30]);
    
}
+(instancetype)showalert:(NSString *)Title :(NSString *)message :(BOOL)ishaveOtherbutton {

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Title message:message delegate:self cancelButtonTitle:ishaveOtherbutton==NO?@"OK":@"Cancel" otherButtonTitles:ishaveOtherbutton==YES?@"OK":nil, nil];
    return alert;
}

@end
