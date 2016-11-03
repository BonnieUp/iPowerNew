//
//  PowerUtils.h
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface PowerUtils : NSObject


//获取当前操作时间
+(NSString *)getOperationTime:(NSString *)formatString;

//获取当前月的第一天
+(NSString *)getFirstDay:(NSString *)formatString;

//获取当前月最后一天
+(NSString *)getLastDay:(NSString *)formatString;

//将字符串按照指定format转换成date
+(NSDate *)stringToDate:(NSString *)dateStr withFormat:(NSString *)formatStr;

//获取当前日期的一个月前的一天
+(NSString *)getLastMonthDay:(NSString *)formatString;

//获取当前日期的一年前的一天
+(NSDate *)getLastYearay:(NSString *)formatString;

//获取当前日期的0点
+(NSString *)getZeroDay:(NSString *)formatString;

//解析传递过来的参数
+(NSDictionary *)parsePassType:(NSString *)url;

//获取字典里指定key的value
+(NSString *)getMappingValue:(NSDictionary *)map
                         key:(NSString *)key
                     nullStr:(NSString *)nullStr;

//根据文本的宽度和字体得到自适应的size
+(CGSize)getLabelSizeWithText:(NSString *)text
                        width:(float)width
                         font:(UIFont *)font;

//将图标缩放到指定大小
+(UIImage *)OriginImage:(UIImage *)image
            scaleToSize:(CGSize)size;

//生成一张纯色图片
+(UIImage *)createImageWithColor:(UIColor *)color
                            size:(CGSize)size;
//弹出信息，数秒后消失
+(void)showMessage:(NSString *)message duration:(NSTimeInterval)time;
@end
