//
//  UITextField+MaxLength.m
//  Consumo
//
//  Created by Roberto Veiga on 14/04/14.
//  Copyright (c) 2014 Roberto Veiga Jr. All rights reserved.
//

#import "UITextField+MaxLength.h"
#import <objc/runtime.h>

@implementation UITextField (MaxLength)

static char const * const ObjectTagKey = "maxLength";

@dynamic maxLength;

- (id)maxLength {
    return objc_getAssociatedObject(self, ObjectTagKey);
}

- (void)setMaxLength:(id)newObjectTag {
    self.delegate = self;
    objc_setAssociatedObject(self, ObjectTagKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return !(newLength > [self.maxLength integerValue]);
}

@end
