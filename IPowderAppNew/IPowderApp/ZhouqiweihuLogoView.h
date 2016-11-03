//
//  ZhouqiweihuLogoView.h
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhouqiweihuLogoView : UIView {
    //周期维护图标
    UIImageView *weihuImage;
    //显示我的待处理任务数量
    UIImageView *myTaskAmountView;
    //显示组任务数量
    UIImageView *myGroupAmountView;
    //名称label
    UILabel *nameLabel;
    
}


//我的待处理任务数量
@property (nonatomic,strong) NSString *myTaskAmount;
//组任务数量
@property (nonatomic,strong) NSString *groupTaskAmount;


@end
