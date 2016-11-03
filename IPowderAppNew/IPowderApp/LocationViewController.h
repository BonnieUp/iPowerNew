//
//  LoactionViewController.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//
//-------------
//----站点定位视图
//-------------
#import "BaseViewController.h"
#import "ZBarSDK.h"
#import "UIGlossyButton.h"
@interface LocationViewController : BaseViewController<ZBarReaderDelegate>{
    //坐标定位按钮
    UIGlossyButton *zuobiaoBtn;
    //扫描定位按钮
    UIGlossyButton *saomiaoBtn;
}

@end
