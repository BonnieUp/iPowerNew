//
//  UIButton+BindArgs.h
//  EastAxe
//
//  Created by SunSet on 13-12-26.
//  Copyright (c) 2013年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BindArgs)

/*设置网络图片*/
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder Zip:(BOOL)iszip;

/*根据键值绑定数据*/
-(void)bindData:(NSString *)key Value:(id)value;
/*根据键值获取绑定的数据*/
-(id)getData:(NSString *)key;
/*移除数据绑定*/
-(void)removeData;

/* backgroundimage*/
+(instancetype)ButtonWithFrame:(CGRect)frame Normal:(UIImage *)normal Select:(UIImage *)select Title:(NSString *)title;

/*setimage*/
+(instancetype)ButtonimageWithFrame:(CGRect)frame Normal:(UIImage *)normal Select:(UIImage *)select Title:(NSString *)title;

+(instancetype)ButtonLeftIconAndRightTtitleWithFrame:(CGRect)frame LeftIcon:(UIImage *)iconImage  BGColor:(UIColor*)bgcolor Title:(NSString *)title TitleColor:(UIColor*)textcolor;

/*虚线边框的UIButton*/
+(instancetype)dashedLineButtonWithFrame:(CGRect)frame Title:(NSString *)title Title:(UIColor *)MainColor;

@end
