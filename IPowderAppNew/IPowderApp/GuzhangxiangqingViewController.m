//
//  GuzhangxiangqingViewController.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "GuzhangxiangqingViewController.h"
#import "PowerDataService.h"
#import "UnEditPropertyCell.h"

@interface GuzhangxiangqingViewController ()

@end

@implementation GuzhangxiangqingViewController {
    UnEditPropertyCell *shebeimingchengCell;
    UnEditPropertyCell *shebeileixingCell;
    UnEditPropertyCell *guzhangyuanyinCell;
    UnEditPropertyCell *guzhangweizhiCell;
    UnEditPropertyCell *guzhangjibieCell;
    UnEditPropertyCell *guzhanglishiCell;
    UnEditPropertyCell *guzhangzuidalishiCell;
    UnEditPropertyCell *baoxiurenCell;
    UnEditPropertyCell *baoxiushijianCell;
    UnEditPropertyCell *shoulishijianCell;
    UnEditPropertyCell *xiulishijianCell;
    UnEditPropertyCell *xiufushijianCell;
    UnEditPropertyCell *paixiuleixing;
    UnEditPropertyCell *paixiuzhuangtaiCell;
    UnEditPropertyCell *chulirenCell;
    UnEditPropertyCell *chulibanzuCell;
    UnEditPropertyCell *wxno;
    UnEditPropertyCell *beizhuCell;
    NSDictionary *guzhangDic;
    NSMutableArray *paidanList;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    paidanList = [[NSMutableArray alloc]initWithObjects:@"人工派单",@"系统自动派单", nil];
    // Do any additional setup after loading the view.
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-40)];
    scrollView.contentSize = CGSizeMake(scrollView.width, 720);
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    //设备名称
    shebeimingchengCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"设备名称" leftWidth:100 frame:CGRectMake(0,0,ScreenWidth,40)];
    [scrollView addSubview:shebeimingchengCell];
    
    shebeileixingCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"设备类型" leftWidth:100 frame:CGRectMake(0,40,ScreenWidth,40)];
    [scrollView addSubview:shebeileixingCell];
    
    guzhangyuanyinCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"故障原因" leftWidth:100 frame:CGRectMake(0,80,ScreenWidth,40)];
    [scrollView addSubview:guzhangyuanyinCell];
    
    guzhangweizhiCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"故障位置" leftWidth:100 frame:CGRectMake(0,120,ScreenWidth,40)];
    [scrollView addSubview:guzhangweizhiCell];
    
    guzhangjibieCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"故障等级" leftWidth:100 frame:CGRectMake(0,160,ScreenWidth,40)];
    [scrollView addSubview:guzhangjibieCell];
    
    guzhanglishiCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"故障历时" leftWidth:100 frame:CGRectMake(0,200,ScreenWidth,40)];
    [scrollView addSubview:guzhanglishiCell];
    
    guzhangzuidalishiCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"故障最大历时" leftWidth:100 frame:CGRectMake(0,240,ScreenWidth,40)];
    [scrollView addSubview:guzhangzuidalishiCell];
    
    baoxiurenCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"报修人" leftWidth:100 frame:CGRectMake(0,280,ScreenWidth,40)];
    [scrollView addSubview:baoxiurenCell];
    
    baoxiushijianCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"报修时间" leftWidth:100 frame:CGRectMake(0,320,ScreenWidth,40)];
    [scrollView addSubview:baoxiushijianCell];
    
    shoulishijianCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"受理时间" leftWidth:100 frame:CGRectMake(0,360,ScreenWidth,40)];
    [scrollView addSubview:shoulishijianCell];
    
    xiulishijianCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"修理时间" leftWidth:100 frame:CGRectMake(0,400,ScreenWidth,40)];
    [scrollView addSubview:xiulishijianCell];
    
    xiufushijianCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"修复时间" leftWidth:100 frame:CGRectMake(0,440,ScreenWidth,40)];
    [scrollView addSubview:xiufushijianCell];
    
    paixiuleixing = [[UnEditPropertyCell alloc]initWithPropertyName:@"派修类型" leftWidth:100 frame:CGRectMake(0,480,ScreenWidth,40)];
    [scrollView addSubview:paixiuleixing];
    
    paixiuzhuangtaiCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"派修状态" leftWidth:100 frame:CGRectMake(0,520,ScreenWidth,40)];
    [scrollView addSubview:paixiuzhuangtaiCell];
    
    chulirenCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"处理人" leftWidth:100 frame:CGRectMake(0,560,ScreenWidth,40)];
    [scrollView addSubview:chulirenCell];
    
    chulibanzuCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"处理班组" leftWidth:100 frame:CGRectMake(0,600,ScreenWidth,40)];
    [scrollView addSubview:chulibanzuCell];
    
    wxno = [[UnEditPropertyCell alloc]initWithPropertyName:@"WX流水号" leftWidth:100 frame:CGRectMake(0,640,ScreenWidth,40)];
    [scrollView addSubview:wxno];
    
    beizhuCell = [[UnEditPropertyCell alloc]initWithPropertyName:@"备注" leftWidth:100 frame:CGRectMake(0,680,ScreenWidth,40)];
    [scrollView addSubview:beizhuCell];
    
}

-(void)setWXFULLNO:(NSString *)WXFULLNO {
    _WXFULLNO = WXFULLNO;
    [self getGuzhangxiangqing];
}


-(void)getGuzhangxiangqing {
    RequestCompleteBlock block = ^(id result) {
        guzhangDic = (NSDictionary *)result;
        [self loadInfo];
    };
    PowerDataService *dataService = [[PowerDataService alloc]init];
    [dataService getDeviceFaultDetailWithAccessToken:AccessToken operationTime:[PowerUtils getOperationTime:@"yyyy-MM-dd-HH:mm:ss"] WXFULLNO:_WXFULLNO completeBlock:block loadingView:self.view showHUD:YES];
}

-(void)loadInfo {
    [shebeimingchengCell setPropertyValue:[guzhangDic objectForKey:@"DEV_NAME"]];
    [shebeileixingCell setPropertyValue:[guzhangDic objectForKey:@"DEV_TYPE_NAME"]];
    [guzhangyuanyinCell setPropertyValue:[guzhangDic objectForKey:@"FAULT_DESCRIPT"]];
    BOOL isSingle = YES;
    if(_siteList.count > 1) {
        isSingle = NO;
    }
    if(isSingle == YES ) {
        [guzhangweizhiCell setPropertyValue:[NSString stringWithFormat:@"%@-%@-%@",[guzhangDic objectForKey:@"STATION_NAME"],[guzhangDic objectForKey:@"ROOM_NAME"],[guzhangDic objectForKey:@"DEV_NAME"]]];
    }else {
        [guzhangweizhiCell setPropertyValue:[NSString stringWithFormat:@"%@-%@-%@-%@",[guzhangDic objectForKey:@"REG_NAME"],[guzhangDic objectForKey:@"STATION_NAME"],[guzhangDic objectForKey:@"ROOM_NAME"],[guzhangDic objectForKey:@"DEV_NAME"]]];
    }

    [guzhangjibieCell setPropertyValue:[guzhangDic objectForKey:@"FAULT_LEVEL_NAME"]];
    [guzhanglishiCell setPropertyValue:[NSString stringWithFormat:@"%@分钟",[guzhangDic objectForKey:@"MEND_FAULTPERIOD"]]];
    [guzhangzuidalishiCell setPropertyValue:[NSString stringWithFormat:@"%@小时",[guzhangDic objectForKey:@"FAULT_MAX_PERIOD"]]];
    [baoxiurenCell setPropertyValue:[guzhangDic objectForKey:@"REPORT_PERSON"]];
    [baoxiushijianCell setPropertyValue:[guzhangDic objectForKey:@"REPORT_TIME"]];
    [shoulishijianCell setPropertyValue:[guzhangDic objectForKey:@"ACCEPT_TIME"]];
    [paixiuleixing setPropertyValue:[paidanList objectAtIndex:[[guzhangDic objectForKey:@"IS_AUTO_MEND"] integerValue]]];
    [paixiuzhuangtaiCell setPropertyValue:[guzhangDic objectForKey:@"MEND_STATUS"]];
    [chulirenCell setPropertyValue:[guzhangDic objectForKey:@"MEND_PERSON"]];
    [chulibanzuCell setPropertyValue:[guzhangDic objectForKey:@"MEND_TEAM_NAME"]];
    [wxno setPropertyValue:[guzhangDic objectForKey:@"WX_FULLNO"]];
    [beizhuCell setPropertyValue:[guzhangDic objectForKey:@"MEND_REMARK"]];
}

@end
