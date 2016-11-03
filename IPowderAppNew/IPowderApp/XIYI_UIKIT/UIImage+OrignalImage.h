//
//  UIImage+OrignalImage.h
//  Meiquer
//
//  Created by Bin WU on 15/2/4.
//  Copyright (c) 2015年 Bin WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OrignalImage)
+ (UIImage *)fixOrientation:(UIImage *)aImage;
- (UIImage*)MLImageCrop_imageByCropForRect:(CGRect)targetRect;

#pragma mark--添加贴纸
+(UIImage *)saveImage:(UIView *)view;
@end
