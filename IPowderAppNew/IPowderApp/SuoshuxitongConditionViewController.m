//
//  SuoshuxitongConditionViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-6.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "SuoshuxitongConditionViewController.h"

@interface SuoshuxitongConditionViewController () {
    UIView *containerView;
    UIButton *closeBtn;
    NSMutableArray *cells;
    NSInteger selectIndex;
    UIGlossyButton *submitBtn;
    UIScrollView *btnContainerView;
}

@end

@implementation SuoshuxitongConditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cells = [[NSMutableArray alloc]init];
    
    //容器
    containerView = [[UIView alloc]initWithFrame:CGRectZero];
    containerView.layer.cornerRadius = 5;
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    //名称
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 250, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"所属系统";
    [containerView addSubview:titleLabel];
    
    //关闭按钮
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(245, 5, 30, 30);
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_normal.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_pressed.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateSelected];
    [closeBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeBtn];
    
    //生成存放按钮的view
    btnContainerView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    btnContainerView.layer.borderWidth = 1;
    btnContainerView.layer.borderColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:0.2].CGColor;
    btnContainerView.layer.cornerRadius = 5;
    btnContainerView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1];
    [containerView addSubview:btnContainerView];
    
    //添加确定按钮
    submitBtn = [[UIGlossyButton alloc]init];
    submitBtn.frame = CGRectMake(10,btnContainerView.bottom+5,containerView.width-20,30);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitBtn addTarget:self action:@selector(submitHandler) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setEnabled:NO];
    [containerView addSubview:submitBtn];
}

//创建子类按钮
-(void)createSuoshuxitongBtn {
    float cellHei = 35;
    float maxHei = cellHei * _suoshuxitongList.count + 90;
    float aviMaxHei = ScreenHeight-STATUS_BAR_HEIGHT-20;
    
    if(maxHei < aviMaxHei ) {
        containerView.frame = CGRectMake((ScreenWidth-280)/2, (aviMaxHei-maxHei)/2, 280, maxHei);
        btnContainerView.frame = CGRectMake(10, 40, 260, maxHei-90);
        btnContainerView.contentSize = CGSizeMake(260, _suoshuxitongList.count*cellHei+10);
        submitBtn.frame = CGRectMake(10,btnContainerView.bottom+5,containerView.width-20,30);
    }else {
        containerView.frame = CGRectMake((ScreenWidth-280)/2, 5, 280, aviMaxHei);
        btnContainerView.frame = CGRectMake(10, 40, 260, aviMaxHei-90);
        btnContainerView.contentSize = CGSizeMake(260, _suoshuxitongList.count*cellHei);
        submitBtn.frame = CGRectMake(10,btnContainerView.bottom+5,containerView.width-20,30);
    }
    
    //生成设备大类子按钮
    for(int i=0;i<_suoshuxitongList.count;i++) {
        NSDictionary *cellDic = [_suoshuxitongList objectAtIndex:i];
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.frame = CGRectMake(10, i*cellHei, 250, cellHei);
        [self setUnSelectState:cellBtn];
        cellBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cellBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 215, 0, 0)];
        [cellBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-20,0,35)];
        [cellBtn setTitle:[cellDic objectForKey:@"SYS_CLASS_NAME"] forState:UIControlStateNormal];
        [cellBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cellBtn addTarget:self action:@selector(suoshuxitongBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        cellBtn.backgroundColor = [UIColor clearColor];
        [btnContainerView addSubview:cellBtn];
        
        [cells addObject:cellBtn];
        //添加分割线
        if(i!= _suoshuxitongList.count -1 ) {
            UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0,(i+1)*cellHei-1, 260, 0.5)];
            seperateView.backgroundColor = [UIColor grayColor];
            seperateView.alpha = 0.5;
            [btnContainerView addSubview:seperateView];
        }
    }
    
    //添加确定按钮
    submitBtn = [[UIGlossyButton alloc]init];
    submitBtn.frame = CGRectMake(10,btnContainerView.bottom+5,containerView.width-20,30);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    [submitBtn addTarget:self action:@selector(submitHandler) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setEnabled:NO];
    [containerView addSubview:submitBtn];
    
}

//将当前选中的按钮设定为选中状态
-(void)setSelectState:(UIButton *)btn {
    [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_radio_selected.png"] scaleToSize:CGSizeMake(30,30)] forState:UIControlStateNormal];
}

//将按钮设置为未选中状态
-(void)setUnSelectState:(UIButton *)btn {
    [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_radio_disable.png"] scaleToSize:CGSizeMake(30,30)] forState:UIControlStateNormal];
}

//设备大类里的字按钮点击事件
-(void)suoshuxitongBtnOnClick:(UIButton *)btn {
    [self resetAllBtn];
    //将选中设置为选中状态
    [self setSelectState:btn];
    
    selectIndex = [cells indexOfObject:btn];
    //将提交按钮设置为可选
    [submitBtn setEnabled:YES];
}

//关闭窗口
-(void)closeWindow{
    [self disappearWinow];
}


//重置所有按钮
-(void)resetAllBtn{
    for (UIButton *btn in cells) {
        [self setUnSelectState:btn];
    }
}

//点击提交按钮
-(void)submitHandler {
    if(selectIndex>=0) {
        NSDictionary *selectDic = [_suoshuxitongList objectAtIndex:selectIndex];
        if(_delegate && [_delegate respondsToSelector:@selector(submitSuoshuxitongCondition:)]) {
            [_delegate submitSuoshuxitongCondition:selectDic];
            //关闭窗口
            [self disappearWinow];
        }
    }
}

-(void)setSuoshuxitongList:(NSArray *)suoshuxitongList{
    if(![_suoshuxitongList isEqual:suoshuxitongList ]) {
        _suoshuxitongList = suoshuxitongList;
        
        //根据数据源生成按钮
        [self createSuoshuxitongBtn];
    }
}

-(void)setSelectSuoshuxitong:(NSString *)selectSuoshuxitong{
    if(![_selectSuoshuxitong isEqualToString:selectSuoshuxitong ]) {
        _selectSuoshuxitong = selectSuoshuxitong;
        NSInteger index;
        for (NSDictionary* dic in _suoshuxitongList) {
            if([[dic objectForKey:@"SYS_CLASS_NUM"] isEqualToString:selectSuoshuxitong] ) {
                index = [_suoshuxitongList indexOfObject:dic];
                break;
            }
        }
        
        if(index>=0) {
            UIButton *btn = [cells objectAtIndex:index];
            [self setSelectState:btn];
        }
    }
}

@end
