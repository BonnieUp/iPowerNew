//
//  UIView+BindArgs.h
//  IBM
//
//  Created by love_ping891122 on 14-6-25.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BindArgs)

/*根据键值绑定数据*/
-(void)bindData:(NSString *)key Value:(id)value;
/*根据键值获取绑定的数据*/
-(id)getData:(NSString *)key;
/*初始化UIview方法*/
+(instancetype)ViewWithFrame:(CGRect)frame :(UIColor*)bcolor;
/*初始化横线方法*/
+(instancetype)lineViewWithx:(float)linex y:(float)liney wight:(float)wight :(UIColor*)linecolor;
/*初始化竖线方法*/
+(instancetype)lineViewWithx:(float)linex y:(float)liney height:(float)lineheight :(UIColor*)linecolor;

//视图图层摇晃震动动画
+(void)startShake:(UIView*)shakeView;
@end
