//
//  UtilityMacro.h
//  WQExtension
//
//  Created by Jerry on 14/11/22.
//  Copyright (c) 2014年 Jerry. All rights reserved.
//

#ifndef WQExtension_UtilityMacro_h
#define WQExtension_UtilityMacro_h


//系统
#define iOSVersionStr [[UIDevice currentDevice] systemVersion]
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS7Later (iOSVersion >= 7.0)
#define iOS8Later (iOSVersion >= 8.0)
#define isIPhone5 ([[UIScreen mainScreen] bounds].size.height == 1136)
#define isBigIPhone ([[UIScreen mainScreen] bounds].size.height > 480)
//app
#define myAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define myAppBundleIdentifier [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey]
//颜色
#define ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorWithRGB(r,g,b) ColorWithRGBA(r,g,b,1)
#define ColorWithHexRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#define ColorWithHexRGB(rgbValue) ColorWithHexRGBA(rgbValue,1.0)
#define UIColorWhite [UIColor whiteColor]
#define UIColorBlack [UIColor blackColor]
#define UIColorClear [UIColor clearColor]
//字体
#define UIFontSystem(x) [UIFont systemFontOfSize:x]
#define UIFontBoldSystem(x) [UIFont boldSystemFontOfSize:x]
//图片
#define UIImageNamed(x) [UIImage imageNamed:x]
#define UIImageViewNamed(x) [[UIImageView alloc] initWithImage:UIImageNamed(x)]
//字符串
#define NSStringInt(x) [NSString stringWithFormat:@"%d", x]
#define NSStringFloat(x) [NSString stringWithFormat:@"%f", x]
#define NSStringDouble(x) [NSString stringWithFormat:@"%lf", x]
#define NoNullString(x) ((x && [x isKindOfClass:[NSString class]]) ? x : @"")
#define NoNullNumber(x) ((x && [x isKindOfClass:[NSNumber class]]) ? x : @(0))
//url
#define NSURLWithString(x) [NSURL URLWithString:x]
//其他
#define BlockSelf(x) __block typeof(self) x = self
#define WeakSelf(x) __weak typeof(self) x = self
#define StandardUserDefaults [NSUserDefaults standardUserDefaults]
#define DefaultNotificationCenter [NSNotificationCenter defaultCenter]
#define DefaultFileManager [NSFileManager defaultManager]

//屏幕
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define Tabbar_height 49  //tabbar高度
#define Nav_height 44 
#define StatusBar_height 20


#define NSNumberZero [NSNumber numberWithInt:0]
#define NSNumberInt(x) [NSNumber numberWithInt:x]
#define NSNumberBool(x) [NSNumber numberWithBool:x]
#define NSNumberFloat(x) [NSNumber numberWithFloat:x]
#define NSNumberDouble(x) [NSNumber numberWithDouble:x]

//log
#if DEBUG
#define MyLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);};
#else
#define MyLog(fmt, ...){}
#endif

#endif
