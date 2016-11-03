//
//  UILabel+BindArgs.h
//  TastyFood
//
//  Created by love_ping891122 on 14/12/13.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BindArgs)
+(instancetype)LabelWithFrame:(CGRect)frame text:(NSString*)textString color:(UIColor*)textColor font:(float)textfont;
+(instancetype)leftLabelWithFrame:(CGRect)frame text:(NSString*)textString color:(UIColor*)textColor font:(float)textfont;
+(instancetype)RightLabelWithFrame:(CGRect)frame text:(NSString*)textString color:(UIColor*)textColor font:(float)textfont;

+(instancetype)MLEmojiLabelWithFrame:(CGRect)frame text:(NSString*)textString color:(UIColor*)textColor font:(float)textfont;


#pragma mark --- other
//B2应用 标签label
+(UILabel*)getTagLabel:(NSString*)LabelString;
@end
