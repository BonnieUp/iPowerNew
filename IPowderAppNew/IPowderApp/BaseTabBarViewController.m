//
//  BaseTabBarViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-21.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController {
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
        // Custom initialization
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

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    for (UIView *view in self.navigationController.navigationBar.subviews) {
//        if(view.tag == 100 || view.tag == 101 ) {
//            [view removeFromSuperview];
//        }
//        
//        
//    }
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    if (viewControllers.count > 1 ) {
//        leftButtonItem = [[UIButton alloc]init];
//        if([customPosition isEqualToString:@"left"]) {
//            leftButtonItem.frame = CGRectMake(0, 0, 100,NAVIGATION_BAR_HEIGHT);
//            if(customTitle != nil) {
//                [leftButtonItem setTitle:customTitle forState:UIControlStateNormal];
//            }
//        }else {
//            leftButtonItem.frame = CGRectMake(0, 0, 40, NAVIGATION_BAR_HEIGHT);
//        }
//        [leftButtonItem setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"widget_left.png"] scaleToSize:CGSizeMake(10, 15)] forState:UIControlStateNormal];
//        leftButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        leftButtonItem.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        leftButtonItem.titleLabel.font = [UIFont systemFontOfSize:14];
//        leftButtonItem.tag = 100;
//        [leftButtonItem setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12, 0)];
//        [leftButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(12, 10, 12, 0)];
//        [leftButtonItem addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationController.navigationBar addSubview:leftButtonItem];
//    }
//    
//    if([customPosition isEqualToString:@"center"]) {
//        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NAVIGATION_BAR_HEIGHT)];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.font = [UIFont systemFontOfSize:14];
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.tag = 101;
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        if(customTitle!=nil) {
//            titleLabel.text = customTitle;
//        }
//        [self.navigationController.navigationBar addSubview:titleLabel];
//    }
//}
//
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//
////
//-(void)setTitleWithPosition:(NSString *)position
//                      title:(NSString *)title {
//    customPosition = position;
//    customTitle = title;
//    if(titleLabel) {
//        titleLabel.text = customTitle;
//    }
//}
//
//-(NSString *)getCustomTitle {
//    return customTitle;
//}

@end
