//
//  ZFDataTableView.h
//  ZFExcelChart
//
//  Created by 任子丰 on 16/1/6.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置同步滑动代理
@protocol ZFScrollDelegate <NSObject>

-(void)dataTableViewContentOffSet:(CGPoint)contentOffSet;
-(void)didSelectItemXlilne:(NSInteger)index :(NSString*)string;
-(void)didSelectItemYlilne:(NSInteger)index :(NSString*)string;

@end

@interface ZFDataTableView : UITableView<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    NSInteger idxxx;
}
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSString *headerStr;
@property (nonatomic, assign)NSInteger idxxx;


@property (nonatomic, assign) id<ZFScrollDelegate> scroll_delegate;

-(void)setTableViewContentOffSet:(CGPoint)contentOffSet;

@end
