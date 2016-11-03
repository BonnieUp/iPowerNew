//
//  JifanggongdianguanliViewController.h
//  i动力
//  机房供电管理
//  Created by 王敏 on 15/12/26.
//  Copyright © 2015年 Min.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface JifanggongdianguanliViewController : BaseViewController<EGORefreshTableDelegate,UIScrollViewDelegate>{
    NSArray *levelDataList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIView *contentView;
    UIScrollView *scrollView;
}
@property(nonatomic,strong)    NSArray *levelDataList;
-(BOOL)ishaveData;


//获取等级统计数据
-(void)getLevelData;

@property (nonatomic,strong )NSString *regNO;

@end
