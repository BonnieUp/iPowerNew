//
//  UIColor+TwoMiles.h
//  MyApp
//
//  Created by Dong Yiming on 2/3/15.
//  Copyright (c) 2015 dlt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TwoMiles)

+(UIColor *)random;
+(UIColor *)appMainGreen;
+(UIColor *)appMainBackground;
+(UIColor *)drivingSchoolGreen;
+(UIColor *)drivingSchoolGray;
+(UIColor *)naviBar;
+(UIColor *)naviBarTitle;
+(UIColor *)tabbarTitleNormal;
+(UIColor *)tabbarBg;
+(UIColor *)tabbarTopLine;
+(UIColor *)buttonTitleNormal;
+(UIColor *)buttonBgNormal;
+(UIColor *)titleGray;

#pragma mark - convienience

+(UIColor *)colorFromR:(int)aRed g:(int)aGreen b:(int)aBlue;
+(UIColor *)colorFromR:(int)aRed g:(int)aGreen b:(int)aBlue a:(CGFloat)anAlpha;
+(UIColor *)colorWithString:(NSString *)colorString;
+(UIColor *)colorWithHex:(UInt32)col withAlpha:(NSString*)alphaStr;

@end
