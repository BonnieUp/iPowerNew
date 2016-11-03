//
//  UIImageView+BindArgs.h
//  TastyFood
//
//  Created by love_ping891122 on 14/12/12.
//  Copyright (c) 2014年 love_ping891122. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (BindArgs)

/*创建有带image的imageview*/
+(instancetype)imageViewWithFrame:(CGRect)frame :(NSString*)imageName;

/*根据键值绑定数据*/
-(void)bindData:(NSString *)key Value:(id)value;
/*根据键值获取绑定的数据*/
-(id)getData:(NSString *)key;

@end
