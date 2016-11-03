//
//  UserRegionViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-1.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "UserRegionViewController.h"

@interface UserRegionViewController ()

@end

@implementation UserRegionViewController

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
    containerView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    containerView.layer.cornerRadius = 5;
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];

}

-(void)setRegionList:(NSArray *)regionList {
    if(![_regionList isEqual:regionList]) {
        _regionList = regionList;
        [self displayData];
    }
}

-(void)setSelectRegionDic:(NSDictionary *)selectRegionDic {
    if(![_selectRegionDic isEqual:selectRegionDic]) {
        _selectRegionDic = selectRegionDic;
        [self setCurrentRegion];
    }
}

//根据数据显示区局信息
-(void)displayData {
    if(_regionList) {
        float cellHei = 35;
        
        float countHeight = cellHei*_regionList.count;
        
        if(countHeight>ScreenHeight-40){
            containerView.frame = CGRectMake((ScreenWidth-280)/2, 20, 280, ScreenHeight-40);
        }else{
            containerView.frame = CGRectMake((ScreenWidth-280)/2, (ScreenHeight-cellHei*_regionList.count)/2, 280, cellHei*_regionList.count);
        }
        [containerView setShowsHorizontalScrollIndicator:NO];
        [containerView setContentSize:CGSizeMake(280, cellHei*_regionList.count)];
        
        for(int i=0;i<_regionList.count;i++) {
            NSDictionary *cellDic = [_regionList objectAtIndex:i];
            UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cellBtn.frame = CGRectMake(0, i*cellHei, 280, cellHei);
            [self setUnSelectState:cellBtn];
            [cellBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 240, 0, 0)];
            [cellBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -220, 0,0)];
            [cellBtn setTitle:[cellDic objectForKey:@"REG_NAME"] forState:UIControlStateNormal];
            [cellBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cellBtn addTarget:self action:@selector(regionBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:cellBtn];
            
            [cells addObject:cellBtn];
            
            //添加分割线
            if(i!= _regionList.count -1 ) {
                UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(5, (i+1)*cellHei-1, 270, 0.5)];
                seperateView.backgroundColor = [UIColor grayColor];
                seperateView.alpha = 0.5;
                [containerView addSubview:seperateView];
            }
        }
    }
}

//点击
-(void)regionBtnOnClick:(UIButton *)sender {
    //现将所有按钮设定为未选中
    for (UIButton *btn in cells) {
        [self setUnSelectState:btn];
    }
    //将当前按钮设定为选中
    [self setSelectState:sender];
    NSUInteger index = [cells indexOfObject:sender];
    //获取选中的regionDic
    NSDictionary *regionDic = [_regionList objectAtIndex:index];
    //通知delegate
    if(_delegate && [_delegate respondsToSelector:@selector(regionOnSelect:regionDic:)]) {
        [_delegate regionOnSelect:self regionDic:regionDic];
    }
}

//将当前选中的按钮设定为选中状态
-(void)setSelectState:(UIButton *)btn {
        [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_radio_selected.png"] scaleToSize:CGSizeMake(30,30)] forState:UIControlStateNormal];
}

//将按钮设置为未选中状态
-(void)setUnSelectState:(UIButton *)btn {
        [btn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"btn_radio_disable.png"] scaleToSize:CGSizeMake(30,30)] forState:UIControlStateNormal];
}


-(void)setCurrentRegion {
    //设置当前选中的区局
    for (UIButton *btn in cells) {
        if([[btn titleForState:UIControlStateNormal] isEqualToString:[_selectRegionDic objectForKey:@"REG_NAME"]]) {
            [self setSelectState:btn];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
