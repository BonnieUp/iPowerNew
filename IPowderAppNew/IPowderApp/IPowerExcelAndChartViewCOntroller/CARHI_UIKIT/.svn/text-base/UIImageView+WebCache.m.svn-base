//
//  UIImageView+WebCache.m
//  EastAxe
//
//  Created by SunSet on 14-2-25.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"
#import <objc/runtime.h>

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    @synchronized(self){

        [self setImage:placeholder];
        //加风火轮
        UIActivityIndicatorView * activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame=self.bounds;
        [activityView startAnimating];
        activityView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:activityView];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSString * urlstr=[url description];
            NSString *imagepathDir=[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImagesCache"];
            
            NSString *imagename=[[urlstr componentsSeparatedByString:@" /"] lastObject]?[[urlstr componentsSeparatedByString:@"/"] lastObject]:@"1.png";
            NSString *imagepath=[imagepathDir stringByAppendingPathComponent:imagename];
            
            BOOL _isReload=NO;//是否重新加载
            if (![[NSFileManager defaultManager] fileExistsAtPath:imagepath]) {
                _isReload=YES;
            }
            else{
                if ([[[NSFileManager defaultManager] attributesOfItemAtPath:imagepath error:nil] fileSize]==0) {//如果存入的文件大小为0
                    _isReload=YES;
                    [[NSFileManager defaultManager] removeItemAtPath:imagepath error:nil];
                }
            }
            
            if (_isReload) {
                NSURL *url=[NSURL URLWithString:urlstr];
                //绕过https验证
                [NSURLRequest allowsAnyHTTPSCertificateForHost:urlstr];
                
                NSURLRequest *request=[NSURLRequest requestWithURL:url];
                NSHTTPURLResponse *response=nil;
                NSError *error=nil;
                NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                if (response.statusCode==200&&!error) {
                    //输出流存储操作
                    NSOutputStream *output=[[NSOutputStream alloc]initToFileAtPath:imagepath append:NO];
                    //NSAssert([output hasSpaceAvailable], @"图片缓存内容无法被写入");//抛出宏
                    [output open];
                    uint8_t * byte=(uint8_t *)[data bytes];
                    [output write:byte maxLength:[data length]];
                    [output close];
                }
            }
            //
            id orignimage=[[UIImage alloc]initWithContentsOfFile:imagepath];
//            UIImage *img=[orignimage isKindOfClass:[UIImage class]]?orignimage:placeholder;
//            CGSize size=self.frame.size;
//            CGRect rect=CGRectMake(0, 0, size.width, size.height);
//            UIGraphicsBeginImageContext(rect.size);
//            [img drawInRect:rect];
//            UIImage * newimg=UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (activityView) {//去除蒙版
                    [activityView removeFromSuperview];
                }
                if (orignimage) {
                    [self setImage:orignimage];
                }
            });
        });
    }
}



-(void)bindData:(NSString *)key Value:(id)value
{
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)getData:(NSString *)key
{
    return objc_getAssociatedObject(self, [key cStringUsingEncoding:30]);
}


@end
