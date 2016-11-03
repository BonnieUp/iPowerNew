//
//  LoactionViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "LocationViewController.h"
#import "ZuobiaodingweiViewController.h"
#import "SaomiaodingweiViewController.h"
@interface LocationViewController ()

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"站点定位"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    zuobiaoBtn =  [[UIGlossyButton alloc]init];
    zuobiaoBtn.frame = CGRectMake((ScreenWidth-150)/2,(ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40)/2-60, 150, 40);
    [zuobiaoBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [zuobiaoBtn setTitle:@"坐标定位" forState:UIControlStateNormal];
    zuobiaoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    zuobiaoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    zuobiaoBtn.titleLabel.textColor = [UIColor whiteColor];
    [zuobiaoBtn addTarget:self action:@selector(zuobiaodingweiHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zuobiaoBtn];
    
    saomiaoBtn = [[UIGlossyButton alloc]init];
    saomiaoBtn.frame = CGRectMake((ScreenWidth-150)/2,(ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40)/2, 150, 40);
//    [saomiaoBtn setBackgroundImage:[UIImage imageNamed:@"btn_big_blue.9.png"] forState:UIControlStateNormal];
    [saomiaoBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [saomiaoBtn setTitle:@"扫描定位" forState:UIControlStateNormal];
    saomiaoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    saomiaoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    saomiaoBtn.titleLabel.textColor = [UIColor whiteColor];
    [saomiaoBtn addTarget:self action:@selector(saomiaodingweiHandler) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:saomiaoBtn];
	// Do any additional setup after loading the view.
}

//坐标定位视图
-(void)zuobiaodingweiHandler{
    ZuobiaodingweiViewController *zuobiaoCtrl = [[ZuobiaodingweiViewController alloc]init];
    [self.navigationController pushViewController:zuobiaoCtrl animated:YES];
}

//扫描定位视图
-(void)saomiaodingweiHandler {
    //弹出扫描视图
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.navigationItem.hidesBackButton = YES;
    //非全屏
    reader.wantsFullScreenLayout = NO;
    //隐藏底部按钮
    reader.showsZBarControls = NO;
    
    [self setOverlayPickerView:reader];
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self.navigationController pushViewController:reader animated:YES];
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader
{
    //清除原有控件
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
            
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }
    //画中间的基准线
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    line.backgroundColor = [UIColor greenColor];
    [reader.view addSubview:line];
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:upView];
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    labIntroudction.font = [UIFont systemFontOfSize:14];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [reader.view addSubview:labIntroudction];
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:leftView];
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:rightView];
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 120)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:downView];
    //用于取消操作的button
    UIGlossyButton *cancelButton = [[UIGlossyButton alloc]init];
    [cancelButton setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [cancelButton setFrame:CGRectMake(20, 370, 280, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:cancelButton];
}

//取消button方法

- (void)dismissOverlayView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark zbar delegate
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [self.navigationController popViewControllerAnimated:NO];
    [self scanWithResNo:symbol.data];
}


-(void)scanWithResNo:(NSString *)resNo {
    SaomiaodingweiViewController *saomiaoCtrl = [[SaomiaodingweiViewController alloc]init];
    saomiaoCtrl.resNo = resNo;
    [self.navigationController pushViewController:saomiaoCtrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
