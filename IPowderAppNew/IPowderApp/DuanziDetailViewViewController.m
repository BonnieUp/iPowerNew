//
//  DuanziDetailViewViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-9.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "DuanziDetailViewViewController.h"

@interface DuanziDetailViewViewController ()

@end

@implementation DuanziDetailViewViewController {
    UIScrollView *scrolView;
    UILabel *deviceNameLabel;
    NSArray *inoutTypeArray;
    NSArray *statusArray;
    NSArray *fujieArray;
    NSArray *xuniArray;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitleWithPosition:@"center" title:@"端子信息"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    inoutTypeArray = [NSArray arrayWithObjects:@"输入",@"输出",@"输入输出",nil];
    statusArray = [NSArray arrayWithObjects:@"",@"占用",@"空闲",@"损坏",@"预占",@"禁止使用",@"负荷已满",@"报废",@"款施工",@"拆除",nil];
    fujieArray = [NSArray arrayWithObjects:@"非复接",@"复接", nil];
    xuniArray = [NSArray arrayWithObjects:@"非虚拟端子(物理端子)",@"虚拟端子", nil];
    //添加设备名称label
    deviceNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    deviceNameLabel.font = [UIFont systemFontOfSize:15];
    deviceNameLabel.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
    deviceNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:deviceNameLabel];
    
    
    scrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40)];
    scrolView.bounces = NO;
    [self.view addSubview:scrolView];
}

-(void)setDeviceName:(NSString *)deviceName {
    if(![_deviceName isEqualToString:deviceName]) {
        _deviceName = deviceName;
        deviceNameLabel.text = deviceName;
    }
}
                 
-(void)setDuanziDic:(NSDictionary *)duanziDic {
    if(![_duanziDic isEqual:duanziDic]) {
        _duanziDic = duanziDic;
        [self createDuanziInfo];
    }
}

//创建端子信息
-(void)createDuanziInfo {
    //创建行
    UIView *rowView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, ScreenWidth, 38)];
    UILabel *rowNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    rowNameLabel.textAlignment = NSTextAlignmentCenter;
    rowNameLabel.text = @"行";
    rowNameLabel.font = [UIFont systemFontOfSize:13];
    rowNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [rowView addSubview:rowNameLabel];
    
    UILabel *rowValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    rowValueLabel.textAlignment = NSTextAlignmentLeft;
    rowValueLabel.text = [_duanziDic objectForKey:@"CONTR_ROW"];
    rowValueLabel.font = [UIFont systemFontOfSize:13];
    [rowView addSubview:rowValueLabel];
    [scrolView addSubview:rowView];
    
    //创建列
    UIView *columnView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, ScreenWidth, 38)];
    UILabel *columnNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    columnNameLabel.textAlignment = NSTextAlignmentCenter;
    columnNameLabel.text = @"列";
    columnNameLabel.font = [UIFont systemFontOfSize:13];
    columnNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [columnView addSubview:columnNameLabel];
    
    UILabel *columnValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    columnValueLabel.textAlignment = NSTextAlignmentLeft;
    columnValueLabel.text = [_duanziDic objectForKey:@"CONTR_COLUMN"];
    columnValueLabel.font = [UIFont systemFontOfSize:13];
    [columnView addSubview:columnValueLabel];
    [scrolView addSubview:columnView];
    
    //创建I/O类型
    UIView *inoutView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, ScreenWidth, 38)];
    UILabel *inoutNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    inoutNameLabel.textAlignment = NSTextAlignmentCenter;
    inoutNameLabel.text = @"I/0类型";
    inoutNameLabel.font = [UIFont systemFontOfSize:13];
    inoutNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [inoutView addSubview:inoutNameLabel];
    
    UILabel *inoutValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    inoutValueLabel.textAlignment = NSTextAlignmentLeft;
    inoutValueLabel.font = [UIFont systemFontOfSize:13];
    inoutValueLabel.text = [inoutTypeArray objectAtIndex:[[_duanziDic objectForKey:@"INOUT_TYPE"] integerValue]];
    [inoutView addSubview:inoutValueLabel];
    [scrolView addSubview:inoutView];
    
    //创建端子类型
    UIView *duanziTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 121, ScreenWidth, 38)];
    UILabel *duanziTypeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    duanziTypeNameLabel.textAlignment = NSTextAlignmentCenter;
    duanziTypeNameLabel.text = @"端子类型";
    duanziTypeNameLabel.font = [UIFont systemFontOfSize:13];
    duanziTypeNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [duanziTypeView addSubview:duanziTypeNameLabel];
    
    UILabel *duanziTypeValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    duanziTypeValueLabel.textAlignment = NSTextAlignmentLeft;
    duanziTypeValueLabel.font = [UIFont systemFontOfSize:13];
    duanziTypeValueLabel.text = [_duanziDic objectForKey:@"CONTR_TYPE"];
    [duanziTypeView addSubview:duanziTypeValueLabel];
    [scrolView addSubview:duanziTypeView];
    
    //创建使用状态
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 161, ScreenWidth, 38)];
    UILabel *statusNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    statusNameLabel.textAlignment = NSTextAlignmentCenter;
    statusNameLabel.text = @"使用状态";
    statusNameLabel.font = [UIFont systemFontOfSize:13];
    statusNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [statusView addSubview:statusNameLabel];
    
    UILabel *statusValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    statusValueLabel.textAlignment = NSTextAlignmentLeft;
    statusValueLabel.font = [UIFont systemFontOfSize:13];
    statusValueLabel.text = [statusArray objectAtIndex:[[_duanziDic objectForKey:@"CONTR_STATUS"] integerValue]];
    [statusView addSubview:statusValueLabel];
    [scrolView addSubview:statusView];
    
    //创建是否复接
    UIView *fujieView = [[UIView alloc]initWithFrame:CGRectMake(0, 201, ScreenWidth, 38)];
    UILabel *fujieNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    fujieNameLabel.textAlignment = NSTextAlignmentCenter;
    fujieNameLabel.text = @"是否复接";
    fujieNameLabel.font = [UIFont systemFontOfSize:13];
    fujieNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [fujieView addSubview:fujieNameLabel];
    
    UILabel *fujieValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    fujieValueLabel.textAlignment = NSTextAlignmentLeft;
    fujieValueLabel.font = [UIFont systemFontOfSize:13];
    fujieValueLabel.text = [fujieArray objectAtIndex:[[_duanziDic objectForKey:@"IS_REUSE"] integerValue]];
    [fujieView addSubview:fujieValueLabel];
    [scrolView addSubview:fujieView];
    
    //是否虚拟端子
    UIView *xuniView = [[UIView alloc]initWithFrame:CGRectMake(0, 241, ScreenWidth, 38)];
    UILabel *xuniNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    xuniNameLabel.textAlignment = NSTextAlignmentCenter;
    xuniNameLabel.font = [UIFont systemFontOfSize:13];
    xuniNameLabel.text = @"是否虚拟端子";
    fujieValueLabel.font = [UIFont systemFontOfSize:13];
    xuniNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [xuniView addSubview:xuniNameLabel];
    
    UILabel *xuniValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    xuniValueLabel.textAlignment = NSTextAlignmentLeft;
    xuniValueLabel.font = [UIFont systemFontOfSize:13];
    xuniValueLabel.text = [xuniArray objectAtIndex:[[_duanziDic objectForKey:@"IS_DUMMY_CONTR"] integerValue]];
    [xuniView addSubview:xuniValueLabel];
    [scrolView addSubview:xuniView];
    
    //端子型号
    UIView *xinghaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 281, ScreenWidth, 38)];
    UILabel *xinghaoNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    xinghaoNameLabel.textAlignment = NSTextAlignmentCenter;
    xinghaoNameLabel.text = @"端子型号";
    xinghaoNameLabel.font = [UIFont systemFontOfSize:13];
    xinghaoNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [xinghaoView addSubview:xinghaoNameLabel];
    
    UILabel *xinghaoValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    xinghaoValueLabel.textAlignment = NSTextAlignmentLeft;
    xinghaoValueLabel.font = [UIFont systemFontOfSize:13];
    xinghaoValueLabel.text = [_duanziDic objectForKey:@"CONTR_MODEL"];
    [xinghaoView addSubview:xinghaoValueLabel];
    [scrolView addSubview:xinghaoView];
    
    //额定容量
    UIView *rongliangView = [[UIView alloc]initWithFrame:CGRectMake(0, 321, ScreenWidth, 38)];
    UILabel *rongliangNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    rongliangNameLabel.textAlignment = NSTextAlignmentCenter;
    rongliangNameLabel.text = @"额定容量";
    rongliangNameLabel.font = [UIFont systemFontOfSize:13];
    rongliangNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [rongliangView addSubview:rongliangNameLabel];
    
    UILabel *rongliangValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    rongliangValueLabel.textAlignment = NSTextAlignmentLeft;
    rongliangValueLabel.font = [UIFont systemFontOfSize:13];
    rongliangValueLabel.text = [_duanziDic objectForKey:@"CONTR_CAPACITY"];
    [rongliangView addSubview:rongliangValueLabel];
    [scrolView addSubview:rongliangView];
    
    //载流量
    UIView *liuliangView = [[UIView alloc]initWithFrame:CGRectMake(0, 361, ScreenWidth, 38)];
    UILabel *liuliangNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    liuliangNameLabel.textAlignment = NSTextAlignmentCenter;
    liuliangNameLabel.text = @"载流量";
    liuliangNameLabel.font = [UIFont systemFontOfSize:13];
    liuliangNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [liuliangView addSubview:liuliangNameLabel];
    
    UILabel *liuliangValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    liuliangValueLabel.textAlignment = NSTextAlignmentLeft;
    liuliangValueLabel.font = [UIFont systemFontOfSize:13];
    liuliangValueLabel.text = [_duanziDic objectForKey:@"MAX_LOAD"];
    [liuliangView addSubview:liuliangValueLabel];
    [scrolView addSubview:liuliangView];
    
    //备注
    UIView *beizhuView = [[UIView alloc]initWithFrame:CGRectMake(0, 401, ScreenWidth, 38)];
    UILabel *beizhuNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 38)];
    beizhuNameLabel.textAlignment = NSTextAlignmentCenter;
    beizhuNameLabel.text = @"备注";
    beizhuNameLabel.font = [UIFont systemFontOfSize:13];
    beizhuNameLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    [beizhuView addSubview:beizhuNameLabel];
    
    UILabel *beizhuValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 210, 38)];
    beizhuValueLabel.textAlignment = NSTextAlignmentLeft;
    beizhuValueLabel.font = [UIFont systemFontOfSize:13];
    beizhuValueLabel.text = [_duanziDic objectForKey:@"CONTR_REMARK"];
    [beizhuView addSubview:beizhuValueLabel];
    [scrolView addSubview:beizhuView];
    
    //添加seperateView
    for(int i=0;i<11;i++) {
        UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), ScreenWidth, 0.5)];
        seperateView.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
        [scrolView addSubview:seperateView];
    }
    
    scrolView.contentSize = CGSizeMake(ScreenWidth, 481);
    
}

@end
