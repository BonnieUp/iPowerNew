//
//  XIYI_MBProgressHUD.m
//  XiYiXiChe
//
//  Created by leo on 15/9/29.
//  Copyright (c) 2015年 love_ping891122. All rights reserved.
//

#import "XIYI_MBProgressHUD.h"

@implementation XIYI_MBProgressHUD
+(instancetype)showHUDAddedTo:(UIView *)view WithMessage:(NSString*)message  hideAfter:(NSTimeInterval)delay
{
    XIYI_MBProgressHUD* hud = [XIYI_MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    [hud hide:YES afterDelay:delay];
    
    return hud;
}


+(instancetype)showHUDAddedTo:(UIView *)view WithTitle:(NSString*)aTitle message:(NSString*)message animated:(BOOL)animated
{
    XIYI_MBProgressHUD* hud = [XIYI_MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [hud setFrame:CGRectMake(0, 0, 100, 200)];
    
    hud.mode = MBProgressHUDModeText;
    
    hud.labelText = aTitle;
    hud.labelFont = [UIFont systemFontOfSize:14.f];
    hud.detailsLabelText =message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:12.f];
    [hud.customView.layer setCornerRadius:14.0f];
    hud.color = RGBAcolor(102,102,102,1);
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.2];
    return hud;
}

+(instancetype)showLoadingHUDAddedTo:(UIView *)view WithTitle:(NSString*)Info  animated:(BOOL)animated WithHide:(BOOL)isHide
{
    if(isHide)
        return [XIYI_MBProgressHUD showLoadingHUDAddedTo:view WithTitle:Info animated:animated WithHideAfterDelay:1.5];
    else
        return [XIYI_MBProgressHUD showLoadingHUDAddedTo:view WithTitle:Info animated:animated WithHideAfterDelay:0];
}

+(instancetype)showLoadingHUDAddedTo:(UIView *)view WithTitle:(NSString*)Info  animated:(BOOL)animated
{
    return [XIYI_MBProgressHUD showLoadingHUDAddedTo:view WithTitle:Info animated:animated WithHide:NO];
}
+(instancetype)showLoadingHUDAddedTo:(UIView *)view WithTitle:(NSString*)Info  animated:(BOOL)animated WithHideAfterDelay:(NSInteger)delay
{
    if(!view || ![view isKindOfClass:[UIView class]])
    {
        NSLog(@"~~~~~~~~~HUDView异常~~~~~~~~~~");
    }
    XIYI_MBProgressHUD* hud = [XIYI_MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setFrame:CGRectMake(0, 0, 100, 200)];
    hud.mode = MBProgressHUDModeCustomView;
    
    //    hud.labelText = [NSString stringWithFormat:@"           %@",Info];
    //    hud.labelFont = [UIFont systemFontOfSize:14.f];
    hud.detailsLabelText =[NSString stringWithFormat:@"%@                      ",Info];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.f];
    [hud.customView.layer setCornerRadius:14.0f];
    hud.color = RGBAcolor(0, 0, 0, 0.6);
    hud.removeFromSuperViewOnHide = YES;
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(hud.customView.origin.x, hud.customView.origin.y, 40, 40)];
//    [iconImg setImage:UIImage Named(@"icon_loadingrw@3x.png")];
    iconImg.image = [UIImage imageNamed:@"icon_loadingrw.png"];
    hud.customView =iconImg ;
    
    {
        CAKeyframeAnimation* rotateAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        rotateAnim.values = @[[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI_2*2, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI_2*3, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI_2*4, 0, 0, 1)]];
        rotateAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotateAnim.duration = 1;
        rotateAnim.repeatCount = 100;
        rotateAnim.autoreverses = NO;
        rotateAnim.removedOnCompletion = NO;
        rotateAnim.delegate = self;
        [iconImg.layer addAnimation:rotateAnim forKey:@"ScanImage"];
    }
    
    if(delay > 0)
        [hud hide:YES afterDelay:delay];
    return hud;
}

+(instancetype)showLoadingHUDAddedToKeyWindowWithTitle:(NSString*)Info  animated:(BOOL)animated
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    XIYI_MBProgressHUD *hud = [[XIYI_MBProgressHUD alloc] initWithView:window];
    [window addSubview:hud];
    [hud show:animated];
    [hud setFrame:CGRectMake(0, 0, 100, 200)];
    hud.mode = MBProgressHUDModeCustomView;
    hud.detailsLabelText =[NSString stringWithFormat:@"%@                      ",Info];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.f];
    [hud.customView.layer setCornerRadius:14.0f];
    hud.color = RGBAcolor(0, 0, 0, 0.6);
    hud.removeFromSuperViewOnHide = YES;
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(hud.customView.origin.x, hud.customView.origin.y, 40, 40)];
    //    [iconImg setImage:UIImageNamed(@"icon_loadingrw@3x.png")];
   [iconImg setImage: [UIImage imageNamed:@"icon_loadingrw.png"]];
    hud.customView =iconImg ;
    {
        CAKeyframeAnimation* rotateAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        rotateAnim.values = @[[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI_2*2, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI_2*3, 0, 0, 1)], [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI_2*4, 0, 0, 1)]];
        rotateAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotateAnim.duration = 1;
        rotateAnim.repeatCount = 100;
        rotateAnim.autoreverses = NO;
        rotateAnim.removedOnCompletion = NO;
        rotateAnim.delegate = self;
        [iconImg.layer addAnimation:rotateAnim forKey:@"ScanImage"];
    }
    [hud hide:YES afterDelay:3];
    return hud;
}




@end
