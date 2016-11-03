//
//  ZFDataTableView.m
//  ZFExcelChart
//
//  Created by 任子丰 on 16/1/6.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import "ZFDataTableView.h"
#define ItemHeight 44

@implementation ZFDataTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.idxxx = 0;

        [self _initView];
    }
    return self;
}

-(void)_initView
{
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = NO;    //竖直
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;  //去掉分割线
    self.bounces = YES;
    self.rowHeight = ItemHeight;
    
}

-(void)setTableViewContentOffSet:(CGPoint)contentOffSet
{
    [self setContentOffset:contentOffSet];
}

-(void)setTitleArr:(NSArray *)titleArr
{
    _titleArr = titleArr;
}

#pragma mark - UITableView delegate/dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell1";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor = [UIColor clearColor];

        
    }
    
    
    for (UIView *sview in cell.contentView.subviews) {
        [sview removeFromSuperview];
    }
    //设置边框，形成表格
    cell.layer.borderWidth = .5f;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    //取消选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label2= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    label2.tag = 100;
    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label2];
    
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = [_titleArr objectAtIndex:indexPath.row];
    
    
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = label.frame;
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(didselectLabel:) forControlEvents:UIControlEventTouchUpInside];
    [button bindData:@"value" Value:[_titleArr objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:button];
    if ([label.text isEqualToString:@"0"]) {
        label.textColor = [UIColor blueColor];
    }
 
    if ((self.titleArr.count-1) == indexPath.row) {
//        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:12];
//        cell.backgroundColor = RGBAcolor(140, 150, 200, 1);


        cell.backgroundColor = [UIColor redColor];
    }
    if (self.tag == 0 &&((self.titleArr.count-1) == indexPath.row)) {
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:12];

    }
    if (self.tag==-1||self.tag==0) {
        cell.backgroundColor = RGBAcolor(140, 150, 200, 1);

        if (label.text.length>5) {
            label.font = [UIFont systemFontOfSize:11];

        }
    }
    if (self.tag==0) {
        label.font = [UIFont boldSystemFontOfSize:12];

    }
    return cell;
}
-(void)didselectLabel:(UIButton*)tap{
    NSString *te = [tap getData:@"value"];
    if( [self isPureInt:te] || [self isPureFloat:te])
    {
        return;
    }
    
    [self.scroll_delegate didSelectItemXlilne:tap.tag :[tap getData:@"value"]];
}
-(void)didselectLabel1:(UIButton*)tap
{
    
    NSString *te = [tap getData:@"value"];
    if( [self isPureInt:te] || [self isPureFloat:te])
    {
        return;
    }
    
    [self.scroll_delegate didSelectItemYlilne:self.tag :[tap getData:@"value"]];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, ItemHeight)];
    headerView.backgroundColor = RGBAcolor(140, 150, 200, 1);

    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.text = self.headerStr;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    
    if ([label.text isEqualToString:@"0"]) {
        label.textColor = [UIColor blueColor];
    }
    
    headerView.layer.borderColor = [UIColor blackColor].CGColor;
    headerView.layer.borderWidth = .5f;

    
    
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = label.frame;
    button.tag = self.idxxx;
    [button addTarget:self action:@selector(didselectLabel1:) forControlEvents:UIControlEventTouchUpInside];
    [button bindData:@"value" Value:self.headerStr];
    [headerView addSubview:button];
    
//    self.idxxx =     self.idxxx+1;
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ItemHeight;
}

#pragma mark - UIScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_scroll_delegate && [_scroll_delegate respondsToSelector:@selector(dataTableViewContentOffSet:)])
    {
        [_scroll_delegate dataTableViewContentOffSet:scrollView.contentOffset];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (_scroll_delegate && [_scroll_delegate respondsToSelector:@selector(dataTableViewContentOffSet:)])
    {
        [_scroll_delegate dataTableViewContentOffSet:scrollView.contentOffset];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    if (_scroll_delegate && [_scroll_delegate respondsToSelector:@selector(dataTableViewContentOffSet:)])
    {
        [_scroll_delegate dataTableViewContentOffSet:scrollView.contentOffset];
    }
}
-(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
