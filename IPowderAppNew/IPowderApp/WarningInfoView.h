//
//  WarningInfoView.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarningInfoView : UIView {
    NSMutableArray *gaojingjibieList;
}

@property (weak, nonatomic) IBOutlet UILabel *gaojingweizhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *gaojingtongdaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *gaojingyuanyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *shebeileixingLabel;
@property (weak, nonatomic) IBOutlet UILabel *gaojingjibieLabel;
@property (weak, nonatomic) IBOutlet UILabel *gaojingshijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *querenrenLabel;
@property (weak, nonatomic) IBOutlet UILabel *querenshijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *gaojingzhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *DKliushuihaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *WXliushuihaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *guzhangzhuangtaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangshangxianLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangxianLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiaxianLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiaxiaxianLabel;

@property (nonatomic,strong) NSDictionary *gaojingInfoDic;


+(WarningInfoView *)instanceWarningInfoView;

@end
