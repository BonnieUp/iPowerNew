//
//  WarningInfoView.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "WarningInfoView.h"

@implementation WarningInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib {
    gaojingjibieList = [[NSMutableArray alloc]initWithObjects:@"严重告警",@"一般告警", @"重大告警",nil];
}
+(WarningInfoView *)instanceWarningInfoView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WarningInfoView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)setGaojingInfoDic:(NSDictionary *)gaojingInfoDic {
    if(![_gaojingInfoDic isEqual:gaojingInfoDic]) {
        _gaojingInfoDic = gaojingInfoDic;
        [self displayInfo];
    }
}

-(void)displayInfo {
    //reset first
    _gaojingweizhiLabel.text = @"";
    _gaojingtongdaoLabel.text = @"";
    _gaojingyuanyinLabel.text = @"";
    _shebeileixingLabel.text = @"";
    _gaojingjibieLabel.text = @"";
    _gaojingshijianLabel.text = @"";
    _querenrenLabel.text = @"";
    _querenshijianLabel.text = @"";
    _gaojingzhiLabel.text = @"";
    _DKliushuihaoLabel.text = @"";
    _WXliushuihaoLabel.text = @"";
    _guzhangzhuangtaiLabel.text  =@"";
    _shangshangxianLabel.text = @"";
    _shangxianLabel.text = @"";
    _xiaxianLabel.text = @"";
    _xiaxiaxianLabel.text = @"";
    if(_gaojingInfoDic != nil ) {
        _gaojingweizhiLabel.text = [NSString stringWithFormat:@"%@-%@",[PowerUtils getMappingValue:_gaojingInfoDic key:@"ROOM_NAME" nullStr:@"--"],[PowerUtils getMappingValue:_gaojingInfoDic key:@"DEV_NAME" nullStr:@"--"]];
        _gaojingtongdaoLabel.text = [PowerUtils getMappingValue:_gaojingInfoDic key:@"POINT_NAME" nullStr:@"--"];
        _gaojingyuanyinLabel.text = [PowerUtils getMappingValue:_gaojingInfoDic key:@"ALARM_DESCRIPT" nullStr:@"--"];
        _shebeileixingLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[_gaojingInfoDic objectForKey:@"DEV_CLASS_NAME"],[_gaojingInfoDic objectForKey:@"DEV_SUBCLASS_NAME"],[_gaojingInfoDic objectForKey:@"DEV_TYPE_NAME"]];
        _gaojingjibieLabel.text = [gaojingjibieList objectAtIndex:[[_gaojingInfoDic objectForKey:@"ALARM_LEVEL"] integerValue]];
        _gaojingshijianLabel.text = [PowerUtils getMappingValue:_gaojingInfoDic key:@"ALARM_TIME" nullStr:@"--"];        _querenrenLabel.text = [PowerUtils getMappingValue:_gaojingInfoDic key:@"CC_CONF_PERSON" nullStr:@"--"];        _querenshijianLabel.text = [PowerUtils getMappingValue:_gaojingInfoDic key:@"CC_CONF_TIME" nullStr:@"--"];
        _gaojingzhiLabel.text =[PowerUtils getMappingValue:_gaojingInfoDic key:@"NEWEST_VALUE" nullStr:@"--"];        _DKliushuihaoLabel.text = [PowerUtils getMappingValue:_gaojingInfoDic key:@"MEND_NUM" nullStr:@"--"];
        _WXliushuihaoLabel.text = [PowerUtils getMappingValue:_gaojingInfoDic key:@"WX_FULLNO" nullStr:@"--"];
        _guzhangzhuangtaiLabel.text = [PowerUtils getMappingValue:_gaojingInfoDic key:@"MEND_STATUS" nullStr:@"--"];;
        _shangshangxianLabel.text = [NSString stringWithFormat:@"%@/%@",[PowerUtils getMappingValue:_gaojingInfoDic key:@"UPUP_BOUND_SET" nullStr:@"--"],[PowerUtils getMappingValue:_gaojingInfoDic key:@"UPUP_BOUND_VALUE" nullStr:@"--"]];
        _shangxianLabel.text = [NSString stringWithFormat:@"%@/%@",[PowerUtils getMappingValue:_gaojingInfoDic key:@"UP_BOUND_SET" nullStr:@"--"],
            [PowerUtils getMappingValue:_gaojingInfoDic key:@"UP_BOUND_VALUE" nullStr:@"--"]];
        _xiaxianLabel.text = [NSString stringWithFormat:@"%@/%@",[PowerUtils getMappingValue:_gaojingInfoDic key:@"DOWNDOWN_BOUND_SET" nullStr:@"--"],
            [PowerUtils getMappingValue:_gaojingInfoDic key:@"DOWN_BOUND_VALUE" nullStr:@"--"]];
        _xiaxiaxianLabel.text = [NSString stringWithFormat:@"%@/%@",[PowerUtils getMappingValue:_gaojingInfoDic key:@"DOWN_BOUND_SET" nullStr:@"--"],[PowerUtils getMappingValue:_gaojingInfoDic key:@"DOWNDOWN_BOUND_VALUE" nullStr:@"--"]];
    }
}

@end
