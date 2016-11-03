//
//  PowerUtils.m
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "PowerUtils.h"

@implementation PowerUtils


+(NSString *)getOperationTime:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+(NSString *)getFirstDay:(NSString *)formatString {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
    components.day = 1;
    NSDate *firstDay = [calendar dateFromComponents:components];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *currentDateStr = [dateFormatter stringFromDate:firstDay];
    return currentDateStr;
}

+(NSString *)getZeroDay:(NSString *)formatString {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:today];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+(NSString *)getLastDay:(NSString *)formatString {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:today];
    components.day = numberOfDaysInMonth;
    NSDate *lastday =  [calendar dateFromComponents:components];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *currentDateStr = [dateFormatter stringFromDate:lastday];
    return currentDateStr;
}
//将字符串按照指定format转换成date
+(NSDate *)stringToDate:(NSString *)dateStr withFormat:(NSString *)formatStr{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:formatStr];
    NSDate *returnDate = [inputFormatter dateFromString:dateStr];
    return returnDate;
}

//获取当前日期的一个月前的一天
+(NSString *)getLastMonthDay:(NSString *)formatString {
    NSDate *mydate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-1];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *currentDateStr = [dateFormatter stringFromDate:newdate];
    return currentDateStr;
}

//获取当前日期的一年前的一天
+(NSDate *)getLastYearay:(NSString *)formatString {
    NSDate *mydate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:-1];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    [adcomps setHour:-1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    return newdate;
}


//解析传递过来的url
+(NSDictionary *)parsePassType:(NSString *)url {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSRange range = [url rangeOfString:@"iPower://" options:NSCaseInsensitiveSearch];
    NSString *baseUrl = [url substringFromIndex:range.length];
    NSArray *urlList = [baseUrl componentsSeparatedByString:@"?"];
    //解析传递的类型
    NSString *passType = urlList[0];
    [dic setValue:passType forKey:[@"passType" uppercaseString]];
    
    //解析传递的参数
    NSArray *parameterList = [urlList[1] componentsSeparatedByString:@"&"];
    for (NSString *itemStr in parameterList) {
        NSArray *parameterItemArray = [itemStr componentsSeparatedByString:@"="];
        NSString *key = parameterItemArray[0];
        NSString *value = parameterItemArray[1];
        [dic setValue:value forKey:[key uppercaseString]];
    }
    return dic;
}

//获取字典里指定key的值，如果为空，返回指定的字符
+(NSString *)getMappingValue:(NSDictionary *)map
                   key:(NSString *)key
               nullStr:(NSString *)nullStr {
    NSString *value = [map objectForKey:key];
    if(value == nil || [value isEqualToString:@""]) {
        return nullStr;
    }else {
        return value;
    }
}

//根据文本的宽度和字体得到自适应的size
+(CGSize)getLabelSizeWithText:(NSString *)text
                        width:(float)width
                         font:(UIFont *)font {
    CGSize labelsize;
    //最大高度为120
    CGSize boundSize = CGSizeMake(width,120);
    
    if(IOS_LEVEL<7.0) {
          labelsize = [text sizeWithFont:font constrainedToSize:boundSize lineBreakMode:UILineBreakModeWordWrap];
    }else {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        labelsize = [text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    }
    if(labelsize.height<20)
        labelsize.height = 20;
    return labelsize;
}

//将图标缩放到指定大小
+(UIImage *)OriginImage:(UIImage *)image
            scaleToSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

//生成一张纯色图片
+(UIImage *)createImageWithColor:(UIColor *)color
                            size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;

}

//生成扫描二维码视图ctrl
+(ZBarReaderViewController *)createZbarController {
    return  nil;
}

+(void)showMessage:(NSString *)message duration:(NSTimeInterval)time
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor grayColor];
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(207, 999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.frame = CGRectMake(10, 5, labelSize.width +20, labelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    [showview addSubview:label];
//    showview.frame = CGRectMake(50, 50, 200, 100);
    showview.frame = CGRectMake((ScreenWidth - labelSize.width - 40)/2,
                                (ScreenHeight - labelSize.height-30)/2,
                                labelSize.width+40,
                                labelSize.height+10);
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
@end
