//
//  UIButton+BindArgs.m
//  EastAxe
//
//  Created by SunSet on 13-12-26.
//  Copyright (c) 2013年 SunSet. All rights reserved.
//

#import "UIButton+BindArgs.h"
#import <objc/runtime.h>
#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"

@implementation UIButton (BindArgs)


-(void)bindData:(NSString *)key Value:(id)value
{
    objc_setAssociatedObject(self, [key cStringUsingEncoding:30], value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
-(id)getData:(NSString *)key
{
    return objc_getAssociatedObject(self, [key cStringUsingEncoding:30]);
    
}
-(void)removeData
{
    objc_removeAssociatedObjects(self);
}
/*虚线边框的UIButton*/
+(instancetype)dashedLineButtonWithFrame:(CGRect)frame Title:(NSString *)title Title:(UIColor *)MainColor
{
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:MainColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"" size:13];
//        button.layer.cornerRadius = frame.size.height/2;
    }
    //虚线
    CAShapeLayer *  border = [CAShapeLayer layer];
    border.strokeColor = MainColor.CGColor;
    border.fillColor = nil;
    //长方形路径
    //border.path = [UIBezierPath bezierPathWithRect:button.layer.bounds].CGPath;
//    border.path = [UIBezierPath bezierPathWithRoundedRect:button.layer.bounds cornerRadius:frame.size.height/2].CGPath;
    border.path = [UIBezierPath bezierPathWithRoundedRect:button.layer.bounds cornerRadius:5].CGPath;
    border.frame = button.bounds;
    border.lineWidth = 1.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    [button.layer addSublayer:border];
    return button;

}



+(instancetype)ButtonWithFrame:(CGRect)frame Normal:(UIImage *)normal Select:(UIImage *)select Title:(NSString *)title
{
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:frame];
    if (title) {
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont fontWithName:@"" size:13];
    }
    if (normal) {
        [bt setBackgroundImage:normal forState:UIControlStateNormal];
    }
    if (select) {
        [bt setBackgroundImage:select forState:UIControlStateSelected];
        [bt setBackgroundImage:select forState:UIControlStateHighlighted];
    }
    return bt;
}

+(instancetype)ButtonimageWithFrame:(CGRect)frame Normal:(UIImage *)normal Select:(UIImage *)select Title:(NSString *)title
{
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:frame];
    if (title) {
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont fontWithName:@"" size:13];
    }
    if (normal) {
        [bt setImage:normal forState:UIControlStateNormal];
    }
    if (select) {
        [bt setImage:select forState:UIControlStateSelected];
        [bt setImage:select forState:UIControlStateHighlighted];
    }
    return bt;
    
    
}


+(instancetype)ButtonLeftIconAndRightTtitleWithFrame:(CGRect)frame LeftIcon:(UIImage *)iconImage  BGColor:(UIColor*)bgcolor Title:(NSString *)title TitleColor:(UIColor*)textcolor
{
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:frame];
    bt.backgroundColor = bgcolor;
    bt.layer.cornerRadius = 3;
    if (title) {
        [bt setTitle:title forState:UIControlStateNormal];
        [bt setTitleColor:textcolor forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont fontWithName:@"" size:13];
        [bt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if (iconImage) {
        [bt setImage:iconImage forState:UIControlStateNormal];
        [bt setImage:iconImage forState:UIControlStateSelected];
        [bt setImage:iconImage forState:UIControlStateHighlighted];
        [bt setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 30)];
    }
    
    return bt;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder Zip:(BOOL)iszip
{
    @synchronized(self){
        UIView * backbottom=[[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:backbottom];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSString *imagepathDir=[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImagesCache"];
            NSString * urlstr=[url description];
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
            
            id orignimage=nil;
            orignimage=[[UIImage alloc]initWithContentsOfFile:imagepath];
            
            UIImage *img=[orignimage isKindOfClass:[UIImage class]]?orignimage:placeholder;
            if (iszip) {
                
                //需要压缩的话
                CGSize size=self.frame.size;
                CGRect rect=CGRectMake(0, 0, size.width*2, size.height*2);
                UIGraphicsBeginImageContext(rect.size);
                [img drawInRect:rect];
                img=UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [backbottom removeFromSuperview];
                
                if ([img isEqual:placeholder]) {//图片存在的话
                    self.userInteractionEnabled=NO;
                }
                [self setBackgroundImage:img forState:UIControlStateNormal];
                
            });
        });
    }
}

-(CGRect)convertSameSize:(CGSize)imagesize
{
    if (imagesize.width>imagesize.height) {
        float x = (imagesize.width-imagesize.height)/2;
        return CGRectMake(x, 0, imagesize.height, imagesize.height);
    }
    float y=(imagesize.height-imagesize.width)/2;
    return CGRectMake(0, y, imagesize.width, imagesize.width);
}


@end

