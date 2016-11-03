//
//  BaseViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController {
    UIButton *leftButtonItem;
    UIBarButtonItem *rightButtonItem;
    UILabel *titleLabel;
    NSString *customTitle;
    NSString *customPosition;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        if (IOS_LEVEL >= 7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
            
        }
        //隐藏自带的bar
        [self.navigationItem setHidesBackButton:YES];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self recreateLabel];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
//    UIBarButtonItem *rightButtonItem;
//    UILabel *titleLabel;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//
-(void)setTitleWithPosition:(NSString *)position
                      title:(NSString *)title {
    customPosition = position;
    customTitle = title;
    [self recreateLabel];
}

-(NSString *)getCustomTitle {
    return customTitle;
}

-(void)recreateLabel{
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if(view.tag == 100 || view.tag == 101 ) {
            [view removeFromSuperview];
        }
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 ) {
        //        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 12, 10, 15)];
        //        [backBtn setBackgroundImage:[PowerUtils OriginImage:[UIImage imageNamed:@"widget_left.png"] scaleToSize:CGSizeMake(10, 15)] forState:UIControlStateNormal];
        //        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        //        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        //        self.navigationItem.leftBarButtonItem = leftButtonItem;
        leftButtonItem = [[UIButton alloc]init];
        if([customPosition isEqualToString:@"left"]) {
            leftButtonItem.frame = CGRectMake(0, 0, 130,NAVIGATION_BAR_HEIGHT);
            if(customTitle != nil) {
                [leftButtonItem setTitle:customTitle forState:UIControlStateNormal];
            }
        }else {
            leftButtonItem.frame = CGRectMake(0, 0, 60, NAVIGATION_BAR_HEIGHT);
        }
        [leftButtonItem setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"left_s.png"] scaleToSize:CGSizeMake(20,20)] forState:UIControlStateNormal];
        leftButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        leftButtonItem.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        leftButtonItem.titleLabel.font = [UIFont systemFontOfSize:13];
        leftButtonItem.tag = 100;
        [leftButtonItem setImageEdgeInsets:UIEdgeInsetsMake(10, 5,10, 0)];
        [leftButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(8,5,10, 0)];
        [leftButtonItem addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:leftButtonItem];
    }
    
    if([customPosition isEqualToString:@"center"]) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NAVIGATION_BAR_HEIGHT)];
        titleLabel.backgroundColor = [UIColor clearColor];
        if(_titleFont!=nil){
            titleLabel.font = _titleFont;
        }else{
            titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.tag = 101;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if(customTitle!=nil) {
            titleLabel.text = customTitle;
        }
        [self.navigationController.navigationBar addSubview:titleLabel];
    }
}
@end
