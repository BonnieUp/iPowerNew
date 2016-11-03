//
//  ShebeidaleiConditionViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-6.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "ShebeidaleiConditionViewController.h"

@interface ShebeidaleiConditionViewController ()

@end

@implementation ShebeidaleiConditionViewController {
    NSArray *shebeidaleiList;
    UIView *containerView;
    UIButton *closeBtn;
    NSMutableArray *cells;
    NSInteger selectIndex;
    UIGlossyButton *submitBtn;
}

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
    //读取plist文件里设备大类信息
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Resource-Info" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    shebeidaleiList = [data objectForKey:@"shebeidalei"];
    
    float cellHei = 35;
    
    //容器
    containerView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-280)/2, (ScreenHeight-100-cellHei*shebeidaleiList.count-STATUS_BAR_HEIGHT)/2, 280, cellHei*shebeidaleiList.count+100)];
    containerView.layer.cornerRadius = 5;
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    //名称
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, containerView.width-10, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设备大类";
    [containerView addSubview:titleLabel];
    
    //关闭按钮
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(245, 5, 30, 30);
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_normal.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [closeBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_close_pressed.png"] scaleToSize:CGSizeMake(30, 30)] forState:UIControlStateSelected];
    [closeBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeBtn];
    
    //生成存放按钮的view
    UIView *btnContainerView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, containerView.width-20, cellHei*shebeidaleiList.count)];
    btnContainerView.layer.borderWidth = 1;
    btnContainerView.layer.borderColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:0.2].CGColor;
    btnContainerView.layer.cornerRadius = 5;
    btnContainerView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1];
    [containerView addSubview:btnContainerView];
    //生成设备大类子按钮
    for(int i=0;i<shebeidaleiList.count;i++) {
        NSDictionary *cellDic = [shebeidaleiList objectAtIndex:i];
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.frame = CGRectMake(10, i*cellHei, 250, cellHei);
        [self setUnSelectState:cellBtn];
        cellBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cellBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 215, 0, 0)];
        [cellBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-20,0,35)];
        [cellBtn setTitle:[cellDic objectForKey:@"name"] forState:UIControlStateNormal];
        [cellBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cellBtn addTarget:self action:@selector(shebeidaleiBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnContainerView addSubview:cellBtn];
        
        [cells addObject:cellBtn];
        //添加分割线
        if(i!= shebeidaleiList.count -1 ) {
            UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(10, 50+(i+1)*cellHei-1, 260, 0.5)];
            seperateView.backgroundColor = [UIColor grayColor];
            seperateView.alpha = 0.5;
            [containerView addSubview:seperateView];
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

//设备大类里的字按钮点击事件
-(void)shebeidaleiBtnOnClick:(UIButton *)btn {
    [self resetAllBtn];
    //将选中设置为选中状态
    [self setSelectState:btn];
    
    selectIndex = [cells indexOfObject:btn];
    //将提交按钮设置为可选
    [submitBtn setEnabled:YES];
}

//点击提交按钮
-(void)submitHandler {
    if(selectIndex>=0) {
        NSDictionary *selectDic = [shebeidaleiList objectAtIndex:selectIndex];
        if(_delegate && [_delegate respondsToSelector:@selector(submitShebeidaleiCondition:)]) {
            [_delegate submitShebeidaleiCondition:selectDic];
            //关闭窗口
            [self disappearWinow];
        }
    }
}

-(void)setSelectDalei:(NSString *)selectDalei {
    if(![_selectDalei isEqualToString:selectDalei ]) {
        _selectDalei = selectDalei;
        
        //设置当前所选的大类
        NSInteger index;
        for (NSDictionary *item in shebeidaleiList ) {
            if([[item objectForKey:@"value"] isEqualToString:selectDalei]) {
                index = [shebeidaleiList indexOfObject:item];
                break;
            }
        }
        if(index>=0) {
            selectIndex = index;
            UIButton *selectBtn = [cells objectAtIndex:selectIndex];
            [self setSelectState:selectBtn];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
