//
//  UnEditPropertyCell.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnEditPropertyCell : UIView

-(id)initWithPropertyName:(NSString *)propertyName leftWidth:(int)leftWidth frame:(CGRect)frame;
-(void)setPropertyValue:(NSString *)value;
@end
