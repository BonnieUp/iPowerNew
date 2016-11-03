//
//  PowerDataService.m
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "PowerDataService.h"
#import "RequestData.h"
#import "AppDelegate.h"

#define noDataTag 10010

@implementation PowerDataService


-(id)init {
    self = [super init];
    if(self ){
        request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"POST"];
        NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];

        selfData = [[NSMutableData alloc]init];
    }
    return self;
}


-(id)initUserJsonHead{
    self = [super init];
    if(self){
        request = [[NSMutableURLRequest alloc]init];
        [request setHTTPMethod:@"POST"];
        NSString *contentType = [NSString stringWithFormat:@"application/json"];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        selfData = [[NSMutableData alloc]init];
    }
    return self;
}

//获取任务数量
-(void)getTaskAmountWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime taskScope:(NSString *)taskScope taskStatus:(NSString *)taskStatus startDate:(NSString *)startDate endDate:(NSString *)endDate completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{

    //设置服务类型
    if([taskScope isEqualToString:@"1"])
        requestType = GET_MY_TASK_AMOUNT;
    if([taskScope isEqualToString:@"2"])
        requestType = GET_GROUP_TASK_AMOUNT;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getTaskAmountUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSMutableData *postBody = [NSMutableData data];
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"taskStat" value:taskStatus];
    [requestData addParameter:@"taskScope" value:taskScope];
    [requestData addParameter:@"startDate" value:startDate];
    [requestData addParameter:@"endDate" value:endDate];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}
//获取站点信息
-(void)getSiteInfoWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime lng:(NSString *)lng lat:(NSString *)lat resNo:(NSString *)resNo completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{
    //设置服务类型
    if(resNo != nil) {
        requestType = GET_SITE_INFO_WITH_RES_NO;
    }else {
        requestType = GET_SITE_INFO_WITH_LOCATION;
    }
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getSiteInfoUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    
    NSMutableData *postBody = [NSMutableData data];
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"lng" value:lng];
    [requestData addParameter:@"lat" value:lat];
    [requestData addParameter:@"resNo" value:resNo];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}


//获取任务列表
-(void)getTaskAmountBySiteWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                 taskStat:(NSString *)taskStat
                                   siteId:(NSString *)siteId
                                    resNo:(NSString *)resNo
                                 taskKind:(NSString *)taskKind
                                taskScope:(NSString *)taskScope
                                startDate:(NSString *)startDate
                                  endDate:(NSString *)endDate
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                        showHUD:(BOOL)showHUD{
    if([taskScope isEqualToString:@"1"] ) {
        requestType = GET_MY_TASK_LIST;
    }
    if([taskScope isEqualToString:@"2"]) {
        requestType = GET_GROUP_TASK_LIST;
    }
    loadingView = view;
    selfShowHUD = showHUD;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getTaskAmountBySiteUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"taskStat" value:taskStat];
    [requestData addParameter:@"siteId" value:siteId];
    [requestData addParameter:@"resNo" value:resNo];
    [requestData addParameter:@"taskKind" value:taskKind];
    [requestData addParameter:@"taskScope" value:taskScope];
    [requestData addParameter:@"startDate" value:startDate];
    [requestData addParameter:@"endDate" value:endDate];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取二级任务列表
-(void)getTaskWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime siteId:(NSString *)siteId taskTypeId:(NSString *)taskTypeId taskStat:(NSString *)taskStat resNo:(NSString *)resNo startDate:(NSString *)startDate endDate:(NSString *)endDate completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{


    requestType = GET_SUB_TASK_LIST;
    loadingView = view;
    selfShowHUD = showHUD;
    
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getTaskInfoUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"taskStat" value:taskStat];
    [requestData addParameter:@"siteId" value:siteId];
    [requestData addParameter:@"taskTypeId" value:taskTypeId];
    [requestData addParameter:@"startDate" value:startDate];
    [requestData addParameter:@"endDate" value:endDate];
    [requestData addParameter:@"resNo" value:resNo];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取进行中的任务列表
-(void)getProcessingTaskWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime siteId:(NSString *)siteId subTaskStat:(NSString *)subTaskStat taskStat:(NSString *)taskStat startDate:(NSString *)startDate endDate:(NSString *)endDate completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD {
    requestType = GET_PROCESSING_TASK_LIST;
    loadingView = view;
    selfShowHUD = showHUD;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getTaskInfoUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"taskStat" value:taskStat];
    [requestData addParameter:@"siteId" value:siteId];
    [requestData addParameter:@"subTaskStat" value:subTaskStat];
    [requestData addParameter:@"startDate" value:startDate];
    [requestData addParameter:@"endDate" value:endDate];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取进行中的任务清单信息
-(void)getTaskDetailInfoWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime taskId:(NSString *)taskId subTaskStat:(NSString *)subTaskStat completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD {

    if([subTaskStat isEqualToString:@"0"])
        requestType = GET_UNFINISHING_TASK_DETAIL;
    if([subTaskStat isEqualToString:@"1"])
        requestType = GET_PROCESSING_TASK_DETAIL;
    if([subTaskStat isEqualToString:@"2"])
        requestType = GET_FINISHED_TASK_DETAIL;
    loadingView = view;
    selfShowHUD = showHUD;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getTaskDetailUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"taskId" value:taskId];
    [requestData addParameter:@"subTaskStat" value:subTaskStat];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}


//开始维护
-(void)startProcessTaskWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime subTaskIdList:(NSString *)subTaskIdList isAuto:(NSString *)isAuto completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD {

    requestType = START_PROCESS_TASK;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:startProcessTaskUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"subTaskIdList" value:subTaskIdList];
    [requestData addParameter:@"isAuto" value:isAuto];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//结束维护
-(void)stopProcessTaskWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime subTaskId:(NSString *)subTaskId isFinished:(NSString *)isFinished remark:(NSString *)remark taskContent:(NSString *)taskContent faultNO:(NSString *)faultNO completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{

    requestType = STOP_PROCESS_TASK;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:stopProcessTaskUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"subTaskIdList" value:subTaskId];
    [requestData addParameter:@"isFinished" value:isFinished];
    [requestData addParameter:@"remark" value:remark];
    [requestData addParameter:@"taskContent" value:taskContent];
    [requestData addParameter:@"faultNO" value:faultNO];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;


}

//获取告警信息列表
-(void)getAlarmListWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime siteId:(NSString *)siteId startDate:(NSString *)startDate endDate:(NSString *)endDate alarmType:(NSString *)alarmType completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD {

    requestType = GET_ALARM_LIST;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getAlarmInfoUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"startDate" value:startDate];
    [requestData addParameter:@"endDate" value:endDate];
    [requestData addParameter:@"alarmType" value:alarmType];
    [requestData addParameter:@"siteId" value:siteId];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取实时告警信息
-(void)getRunTimeAlarmInfoWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime alarmNum:(NSString *)alarmNum alarmType:(NSString *)alarmType completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD {

    requestType = GET_ALARM_RUNTIME_INFO;
    selfShowHUD = showHUD;
    loadingView = view;
    
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getRuntimeAlarmInfo];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"alarmNum" value:alarmNum];
    [requestData addParameter:@"alarmType" value:alarmType];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}


//获取实时告警数据
-(void)getRunTimeAlarmDataWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime nuId:(NSString *)nuId dataType:(NSString *)dataType completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD {

    requestType = GET_ALARM_RUNTIME_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getRuntimeAlarmData];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"nuId" value:nuId];
    [requestData addParameter:@"dataType" value:dataType];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取用户能访问的区局信息
-(void)getUserRegionDataWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD {

    requestType = GET_USER_REGION_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    NSString *urlString = [BaseUrl stringByAppendingString:getUserRegionDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取指定区局下的相关站点数据
-(void)getUserStationDataWithAccessToken:(NSString *)token
                           operationTime:(NSString *)operationTime
                                  regNum:(NSString *)regNum
                             stationName:(NSString *)stationName
                       stationSubTypeNum:(NSString *)stationSubTypeNum
                             stationAddr:(NSString *)stationAddr
                              articleNum:(NSString *)articleNum
                         stationLevelNum:(NSString *)stationLevelNum
                           completeBlock:(RequestCompleteBlock)block
                             loadingView:(UIView *)view
                                 showHUD:(BOOL)showHUD {
    requestType = GET_USER_STATION_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getUserStationDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"regNum" value:regNum];
    [requestData addParameter:@"stationName" value:stationName];
    [requestData addParameter:@"stationSubTypeNum" value:stationSubTypeNum];
    [requestData addParameter:@"stationAddr" value:stationAddr];
    [requestData addParameter:@"articleNum" value:articleNum];
    [requestData addParameter:@"stationLevelNum" value:stationLevelNum];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}


//获取设备清单数据
-(void)getUserDeviceDataWithAccessToken:(NSString *)token
                          operationTime:(NSString *)operationTime
                             stationNum:(NSString *)stationNum
                                roomNum:(NSString *)roomNum
                                 sysNum:(NSString *)sysNum
                             articleNum:(NSString *)articleNum
                              assetsNum:(NSString *)assetsNum
                               devMaker:(NSString *)devMaker
                            devClassNum:(NSString *)devClassNum
                         devSubClassNum:(NSString *)devSubClassNum
                          completeBlock:(RequestCompleteBlock)block
                            loadingView:(UIView *)view
                                showHUD:(BOOL)showHUD {

    requestType = GET_USER_DEVICE_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getUserDeviceDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"stationNum" value:stationNum];
    [requestData addParameter:@"roomNum" value:roomNum];
    [requestData addParameter:@"sysNum" value:sysNum];
    [requestData addParameter:@"articleNum" value:articleNum];
    [requestData addParameter:@"assetsNum" value:assetsNum];
    [requestData addParameter:@"devMaker" value:devMaker];
    [requestData addParameter:@"devClassNum" value:devClassNum];
    [requestData addParameter:@"devSubClassNum" value:devSubClassNum];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}

//获取指定设备大类下的设备子类列表
-(void)getSubDeviceWithAccessToken:(NSString *)token
                     operationTime:(NSString *)operationTime
                       devClassNum:(NSString *)devClassNum
                    devSubClassNum:(NSString *)devSubClassNum
                   devSubClassName:(NSString *)devSubClassName
                       devTypeName:(NSString *)devTypeName
                     completeBlock:(RequestCompleteBlock)block
                       loadingView:(UIView *)view
                           showHUD:(BOOL)showHUD {
    requestType = GET_DEVICE_SUBCLASS_LIST;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getSubDeviceUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"devClassNum" value:devClassNum];
    [requestData addParameter:@"devSubClassNum" value:devSubClassNum];
    [requestData addParameter:@"devSubClassName" value:devSubClassName];
    [requestData addParameter:@"devTypeName" value:devTypeName];

    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}

//获取指定站点下的动力系统数据
-(void)getUserPowerSystemWithAccessToken:(NSString *)token
                           operationTime:(NSString *)operationTime
                              stationNum:(NSString *)stationNum
                             sysClassNum:(NSString *)sysClassNum
                           completeBlock:(RequestCompleteBlock)block
                             loadingView:(UIView *)view
                                 showHUD:(BOOL)showHUD {
    requestType = GET_USER_POWER_SYSTEM_LIST;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getUserPowerSystemDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"stationNum" value:stationNum];
    [requestData addParameter:@"sysClassNum" value:sysClassNum];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}


//获取指定站点下的机房数据
-(void)GetUserRoomDataWithAccessToken:(NSString *)token
                        operationTime:(NSString *)operationTime
                           stationNum:(NSString *)stationNum
                             roomName:(NSString *)roomName
                        completeBlock:(RequestCompleteBlock)block
                          loadingView:(UIView *)view
                              showHUD:(BOOL)showHUD {
    requestType = GET_USER_ROOM_LIST;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getUserRoomDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"stationNum" value:stationNum];
    [requestData addParameter:@"roomName" value:roomName];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取与设备有关的信息
-(void)getDeviceCommonInfoWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                   devNum:(NSString *)devNum
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD {
    requestType = GET_DEVICE_COMMON_INFO;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceCommonInfoUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"devNum" value:devNum];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}


//获取设备的扩展信息
-(void)getDeviceExtendInfoWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                   devNum:(NSString *)devNum
                               devTypeNum:(NSString *)devTypeNum
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD {
    requestType = GET_DEVICE_EXTEND_INFO;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceExtendInfoUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"devNum" value:devNum];
    [requestData addParameter:@"devTypeNum" value:devTypeNum];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取设备的端子信息
-(void)getDeviceConnectorInfoWithAccessToken:(NSString *)token
                               operationTime:(NSString *)operationTime
                                      devNum:(NSString *)devNum
                               completeBlock:(RequestCompleteBlock)block
                                 loadingView:(UIView *)view
                                     showHUD:(BOOL)showHUD {
    requestType = GET_DEVICE_CONNECTOR_INFO;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceConnectorInfoUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"devNum" value:devNum];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取设备状态数据
-(void)getDeviceStatusInfoWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD {

    requestType = GET_DEVICE_STATUS_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceStatusInfoUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}

//获取指定设备大类下的设备类型数据
-(void)GetDeviceTypeDataWithAccessToken:(NSString *)token
                          operationTime:(NSString *)operationTime
                            devClassNum:(NSString *)devClassNum
                         devSubClassNum:(NSString *)devSubClassNum
                        devSubClassName:(NSString *)devSubClassName
                            devTypeName:(NSString *)devTypeName
                          completeBlock:(RequestCompleteBlock)block
                            loadingView:(UIView *)view
                                showHUD:(BOOL)showHUD
{
    requestType = GET_DEVICE_TYPE_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceTypeDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"devClassNum" value:devClassNum];
    [requestData addParameter:@"devSubClassNum" value:devSubClassNum];
    [requestData addParameter:@"devSubClassName" value:devSubClassName];
    [requestData addParameter:@"devTypeName" value:devTypeName];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取某类设备的前十位厂家数据(PR)
-(void)GetDeviceBFDataWithAccessToken:(NSString *)token
                        operationTime:(NSString *)operationTime
                               devNum:(NSString *)devNum
                           devTypeNum:(NSString *)devTypeNum
                       devSubClassNum:(NSString *)devSubClassNum
                          devClassNum:(NSString *)devClassNum
                      devSubClassName:(NSString *)devSubClassName
                          devTypeName:(NSString *)devTypeName
                             devMaker:(NSString *)devMaker
                        completeBlock:(RequestCompleteBlock)block
                          loadingView:(UIView *)view
                              showHUD:(BOOL)showHUD {
    requestType = GET_DEVICE_BF_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceBFDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"devNum" value:devNum];
    [requestData addParameter:@"devTypeNum" value:devTypeNum];
    [requestData addParameter:@"devSubClassNum" value:devSubClassNum];
    [requestData addParameter:@"devClassNum" value:devClassNum];
    [requestData addParameter:@"devSubClassName" value:devSubClassName];
    [requestData addParameter:@"devTypeName" value:devTypeName];
    [requestData addParameter:@"devMaker" value:devMaker];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}

//保存设备相关数据
-(void)saveDevicePropertyWithAccessToken:(NSString *)token
                           operationTime:(NSString *)operationTime
                                 devInfo:(NSString *)devInfo
                           completeBlock:(RequestCompleteBlock)block
                             loadingView:(UIView *)view
                                 showHUD:(BOOL)showHUD {
    requestType = SAVE_DEVICE_PROPERTY;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:saveDevicePropertyUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"devInfo" value:devInfo];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}

//提交巡检报告数据
-(void)saveDeviceReportWithAccessToken:(NSString *)token
                         operationTime:(NSString *)operationTime
                             checkInfo:(NSString *)checkInfo
                         completeBlock:(RequestCompleteBlock)block
                           loadingView:(UIView *)view
                               showHUD:(BOOL)showHUD {
    requestType = SAVE_DEVICE_REPORT;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:saveDeviceReportUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"checkInfo" value:checkInfo];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取用户所在区域内所有的当前告警清单数据
-(void)getDKCurrentAlarmDataWithAccessToken:(NSString *)token
                              operationTime:(NSString *)operationTime
                                     regNum:(NSString *)regNum
                                 stationNum:(NSString *)stationNum
                                stationName:(NSString *)stationName
                              alarmLevelNum:(NSString *)alarmLevelNum
                                devClassNum:(NSString *)devClassNum
                              alarmDescript:(NSString *)alarmDescript
                                   wXFullNo:(NSString *)wXFullNo
                           fatalAlarmRuleID:(NSString *)fatalAlarmRuleID
                                  startTime:(NSString *)startTime
                                   stopTime:(NSString *)stopTime
                              completeBlock:(RequestCompleteBlock)block
                                loadingView:(UIView *)view
                                    showHUD:(BOOL)showHUD{
    requestType = GET_DK_CURRENT_ALARM_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDKCurrentAlarmDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"regNum" value:regNum];
    [requestData addParameter:@"stationNum" value:stationNum];
    [requestData addParameter:@"stationName" value:stationName];
    [requestData addParameter:@"alarmLevelNum" value:alarmLevelNum];
    [requestData addParameter:@"devClassNum" value:devClassNum];
    [requestData addParameter:@"alarmDescript" value:alarmDescript];
    [requestData addParameter:@"wXFullNo" value:wXFullNo];
    [requestData addParameter:@"fatalAlarmRuleID" value:fatalAlarmRuleID];
    [requestData addParameter:@"startTime" value:startTime];
    [requestData addParameter:@"stopTime" value:stopTime];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取历史告警清单数据
-(void)getHistoryAlarmDataWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                   regNum:(NSString *)regNum
                               stationNum:(NSString *)stationNum
                              stationName:(NSString *)stationName
                            alarmLevelNum:(NSString *)alarmLevelNum
                              devClassNum:(NSString *)devClassNum
                            alarmDescript:(NSString *)alarmDescript
                                 wXFullNo:(NSString *)wXFullNo
                                pageIndex:(NSString *)pageIndex
                                startTime:(NSString *)startTime
                                 stopTime:(NSString *)stopTime
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD {
    
    requestType = GET_HISTORY_ALARM_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getHistoryAlarmDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"regNum" value:regNum];
    [requestData addParameter:@"stationNum" value:stationNum];
    [requestData addParameter:@"stationName" value:stationName];
    [requestData addParameter:@"alarmLevelNum" value:alarmLevelNum];
    [requestData addParameter:@"devClassNum" value:devClassNum];
    [requestData addParameter:@"alarmDescript" value:alarmDescript];
    [requestData addParameter:@"wXFullNo" value:wXFullNo];
    [requestData addParameter:@"pageIndex" value:pageIndex];
    [requestData addParameter:@"startTime" value:startTime];
    [requestData addParameter:@"stopTime" value:stopTime];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取用户区域数据
-(void)getUserAreaDataWithAccessToken:(NSString *)token
                        operationTime:(NSString *)operationTime
                        completeBlock:(RequestCompleteBlock)block
                          loadingView:(UIView *)view
                              showHUD:(BOOL)showHUD {
    requestType = GET_USER_AREA_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getUserAreaDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取重大告警类型分组数据
-(void)getFatalAlarmGroupDataWithAccessToken:(NSString *)token
                               operationTime:(NSString *)operationTime
                               completeBlock:(RequestCompleteBlock)block
                                 loadingView:(UIView *)view
                                     showHUD:(BOOL)showHUD{
    requestType = GET_FATAL_ALARM_GROUP_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getFatalAlarmGroupDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取频繁告警列表
-(void)getPinfangaojingWithAccessToken:(NSString *)token
                         operationTime:(NSString *)operationTime
                                regNum:(NSString *)regNum
                           stationName:(NSString *)stationName
                               devName:(NSString *)devName
                             pointName:(NSString *)pointName
                            alarmCount:(NSString *)alarmCount
                             startTime:(NSString *)startTime
                              stopTime:(NSString *)stopTime
                         completeBlock:(RequestCompleteBlock)block
                           loadingView:(UIView *)view
                               showHUD:(BOOL)showHUD {
    requestType = GET_FREQUENT_ALARM_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getFrequentAlarmDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"regNum" value:regNum];
    [requestData addParameter:@"stationName" value:stationName];
    [requestData addParameter:@"devName" value:devName];
    [requestData addParameter:@"pointName" value:pointName];
    [requestData addParameter:@"alarmCount" value:alarmCount];
    [requestData addParameter:@"startTime" value:startTime];
    [requestData addParameter:@"stopTime" value:stopTime];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}


//获取故障清单数据
-(void)getDeviceFaultDataWithAccessToken:(NSString *)token
                           operationTime:(NSString *)operationTime
                                  regNum:(NSString *)regNum
                             stationName:(NSString *)stationName
                                 devName:(NSString *)devName
                             devClassNum:(NSString *)devClassNum
                           faultDescript:(NSString *)faultDescript
                           faultLevelNum:(NSString *)faultLevelNum
                           mendStatusNum:(NSString *)mendStatusNum
                              isAutoMend:(NSString *)isAutoMend
                               startTime:(NSString *)startTime
                                stopTime:(NSString *)stopTime
                           completeBlock:(RequestCompleteBlock)block
                             loadingView:(UIView *)view
                                 showHUD:(BOOL)showHUD {
    requestType = GET_DEVICE_FAULT_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceFaultDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"regNum" value:regNum];
    [requestData addParameter:@"stationName" value:stationName];
    [requestData addParameter:@"devName" value:devName];
    [requestData addParameter:@"devClassNum" value:devClassNum];
    [requestData addParameter:@"faultDescript" value:faultDescript];
    [requestData addParameter:@"faultLevelNum" value:faultLevelNum];
    [requestData addParameter:@"mendStatusNum" value:mendStatusNum];
    [requestData addParameter:@"isAutoMend" value:isAutoMend];
    [requestData addParameter:@"startTime" value:startTime];
    [requestData addParameter:@"stopTime" value:stopTime];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取指定故障的详情数据
-(void)getDeviceFaultDetailWithAccessToken:(NSString *)token
                             operationTime:(NSString *)operationTime
                                  WXFULLNO:(NSString *)WXFULLNO
                             completeBlock:(RequestCompleteBlock)block
                               loadingView:(UIView *)view
                                   showHUD:(BOOL)showHUD {
    requestType = GET_DEVICE_FAULT_DETAIL;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceFaultDetailUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"WXFULLNO" value:WXFULLNO];

    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取指定故障的流转信息
-(void)GetFaultTransferDataWithAccessToken:(NSString *)token
                             operationTime:(NSString *)operationTime
                                  WXFULLNO:(NSString *)WXFULLNO
                             completeBlock:(RequestCompleteBlock)block
                               loadingView:(UIView *)view
                                   showHUD:(BOOL)showHUD {
    requestType = GET_FAULT_TRANSFER_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceFaultTransferUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"WXFULLNO" value:WXFULLNO];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取重大告警列表数据
-(void)getCurrentAlarmDataWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                startTime:(NSString *)startTime
                                 stopTime:(NSString *)stopTime
                         fatalAlarmRuleID:(NSString *)fatalAlarmRuleID
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD {
    requestType = GET_CURRENT_ALARM_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getCurrentAlarmDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    [requestData addParameter:@"startTime" value:startTime];
    [requestData addParameter:@"stopTime" value:stopTime];
    [requestData addParameter:@"fatalAlarmRuleID" value:fatalAlarmRuleID];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}


//获取我的网管模块里的设备大类列表
-(void)getDeviceClassForWangguanWithAccessToken:(NSString *)token
                                  operationTime:(NSString *)operationTime
                                  completeBlock:(RequestCompleteBlock)block
                                    loadingView:(UIView *)view
                                        showHUD:(BOOL)showHUD {
    requestType = GET_FAULT_DEVICE_CLASS;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getDeviceClassDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取故障级别列表
-(void)getDeviceFaultLevelWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD {
    requestType = GET_DEVICE_FAULT_LEVEL;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:getFaultLevelDataUrl];
    [request setURL:[NSURL URLWithString:urlString]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"accessToken" value:token];
    [requestData addParameter:@"operationTime" value:operationTime];
    
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取各类维护等级统计数据接口
-(void)getPRServiceLevelDataWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime regNum:(NSString *)regNum ObjTypeNum:(NSString *)objTypeNum completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{
    requestType = GET_PR_SERVICE_LEVEL_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showNoData];
        });
        return;
    }
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHUD];
    });

    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:getPRServiceLevelDataUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"RegNum" value:regNum];
    [requestData addParameter:@"ObjTypeNum" value:objTypeNum];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取蓄电池测试清单数据
-(void)getPRBatteryTestDataWithAccessToken:(NSString *)token
                             operationTime:(NSString *)operationTime
                                    regNum:(NSString *)regNum
                               testTypeNum:(NSString *)testTypeNum

                                   staName:(NSString *)staName
                                   sysName:(NSString *)sysName
                                 assetsNum:(NSString *)assetsNum
                                articleNum:(NSString *)articleNum
                                 startTime:(NSString *)startTime
                                  stopTime:(NSString *)stopTime
                             completeBlock:(RequestCompleteBlock)block
                               loadingView:(UIView *)view
                                   showHUD:(BOOL)showHUD{
    requestType = GET_PR_BATTERY_TEST_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        [self showNoData];
        return;
    }
    [self showHUD];
    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:getPrBatteryTestDataUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"RegNum" value:regNum];
    [requestData addParameter:@"TestTypeNum" value:testTypeNum];
    [requestData addParameter:@"StaName" value:staName];
    [requestData addParameter:@"SysName" value:sysName];
    [requestData addParameter:@"AssetsNum" value:assetsNum];
    [requestData addParameter:@"ArticleNum" value:articleNum];
    [requestData addParameter:@"StartTime" value:startTime];
    [requestData addParameter:@"StopTime" value:stopTime];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}

//获取蓄电池放电测试详情数据
-(void)getPrBatteryDischargeTestDetailWithAccessToken:(NSString *)token
                                        operationTime:(NSString *)operationTime
                                               objNum:(NSString *)objNum
                                        completeBlock:(RequestCompleteBlock)block
                                          loadingView:(UIView *)view
                                              showHUD:(BOOL)showHUD{
    
    requestType = GET_PR_BATTERY_DISCHARGE_TEST_DETAIL;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        [self showNoData];
        return;
    }
    [self showHUD];
    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:getPrBatteryDischargeTestDetailUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"ObjNum" value:objNum];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;

}

//获取蓄电池内阻测试详情数据
-(void)getPrBatteryInnerResistanceTestDetailWithAccessToken:(NSString *)token
                                              operationTime:(NSString *)operationTime
                                                     objNum:(NSString *)objNum
                                              completeBlock:(RequestCompleteBlock)block
                                                loadingView:(UIView *)view
                                                    showHUD:(BOOL)showHUD{
    requestType = GET_PR_BATTERY_INNER_RESISTANCE_TEST_DETAIL;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        [self showNoData];
        return;
    }
    [self showHUD];
    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:getPrBatteryInnerResistanceTestDetailUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"ObjNum" value:objNum];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}


//获取指定状态的核查计划数据
-(void)getPrCheckPlanDataWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime checkStatusNum:(NSString *)checkStatusNum completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{
    requestType = GET_PR_CHECK_PLAN_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        [self showNoData];
        return;
    }
    [self showHUD];
    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:getPrCheckPlanDataUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"CheckStatusNum" value:checkStatusNum];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取指定巡查计划下指定状态的核查站点数据
-(void)getPrCheckStationDataWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime checkStatusNum:(NSString *)checkStatusNum planNum:(NSString *)planNum completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{
    requestType = GET_PR_CHECK_STATION_DATA;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        [self showNoData];
        return;
    }
    [self showHUD];
    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:getPrCheckStationDataUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"CheckStatusNum" value:checkStatusNum];
    [requestData addParameter:@"PlanNum" value:planNum];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//认领/开始执行指定的核查任务
-(void)excutePrCheckStationWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime operStatusNum:(NSString *)operStatusNum recordNumList:(NSString *)recordNumList completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{
    requestType = EXCUTE_PR_CHECK_STATION;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        [self showNoData];
        return;
    }
    [self showHUD];
    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:excutePrCheckStationUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"OperStatusNum" value:operStatusNum];
    [requestData addParameter:@"RecordNumList" value:recordNumList];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

//获取指定核查站点的详情数据
-(void)getPrCheckStationDetailWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime recordNum:(NSString *)recordNum isEdit:(NSString *)isEdit completeBlock:(RequestCompleteBlock)completeBlock loadingView:(UIView *)view showHUD:(BOOL)showHUD{
    requestType = GET_PR_CHECK_STATION_DETAIL;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        [self showNoData];
        return;
    }
    [self showHUD];
    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:getPrCheckStationDetailUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"RecordNum" value:recordNum];
    [requestData addParameter:@"IS_EDIT" value:isEdit];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = completeBlock;
}

//提交指定核查站点的核查结果数据
-(void)savePrCheckResultWithAccessToken:(NSString *)token operationTime:(NSString *)operationTime recordNum:(NSString *)recordNum commonInfoDic:(NSDictionary *)commonInfoDic extendDic:(NSDictionary *)extendDic completeBlock:(RequestCompleteBlock)completeBlock loadingView:(UIView *)view showHUD:(BOOL)showHUD{
    requestType = SAVE_PR_CHECK_RESULT;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil){
        [self showNoData];
        return;
    }
    [self showHUD];
    
    //url
    NSString *urlString = [BaseUrl stringByAppendingString:savePrCheckResultUrl];
    NSString *parameterStr = [NSString stringWithFormat:@"?accessToken=%@&operationTime=%@",token,operationTime];
    urlString = [urlString stringByAppendingString:parameterStr];
    [request setURL:[NSURL URLWithString:urlString]];
    //设置请求体
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"RecordNum" value:recordNum];
    [requestData addParameter:@"CommonInfo" value:commonInfoDic];
    [requestData addParameter:@"ExtenderInfo" value:extendDic];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = completeBlock;
}


#pragma mark -- dinglangping 请求方法封装

//1.获取模块清单类型数据

-(void)getMangmentIconList:(NSString *)token Type:(NSString*)mangmentType
                                  operationTime:(NSString *)operationTime
                                  completeBlock:(RequestCompleteBlock)block
                                    loadingView:(UIView *)view
                                        showHUD:(BOOL)showHUD {
    requestType = IPOWER_PR_ICON_LIST;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:GETDKREPORTTYPELISTDATA];
    NSString *parameterStr = [NSString stringWithFormat:@"%@?accessToken=%@&operationTime=%@",urlString,token,operationTime];

    [request setURL:[NSURL URLWithString:parameterStr]];
    NSMutableData *postBody = [NSMutableData data];
    
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"RptModuleTypeNum" value:mangmentType];
    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}






//3.9.1.2.获取指定报表类型的查询条件的数据
-(void)getQueryReportDetail:(NSString *)token Type:(NSString *)Mothed operationTime:(NSString *)operationTime completeBlock:(RequestCompleteBlock)block loadingView:(UIView *)view showHUD:(BOOL)showHUD{

    requestType = IPOWER_PR_QUERYINFO;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
        [self showNoData];
        return;
    }
    [self showHUD];
    
    NSString *urlString = [BaseUrl stringByAppendingString:GETDKQUERYREPORTTYPEDATA];
    NSString *parameterStr = [NSString stringWithFormat:@"%@?accessToken=%@&operationTime=%@",urlString,token,operationTime];
    [request setURL:[NSURL URLWithString:parameterStr]];
    NSMutableData *postBody = [NSMutableData data];
    RequestData *requestData = [[RequestData alloc]init];
    [requestData addParameter:@"METHOD_NAME" value:Mothed];

    [postBody appendData:[[requestData toString] dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:requestData.toDictionary options:0 error:nil];
    [request setHTTPBody:nsData];
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}



//3.获取指定报表类型的
//3.9.1.3.

-(void)getData:(NSString *)token Type:(NSString*)NameString EnNamedic:(NSDictionary*)EnNamedicinfo
         operationTime:(NSString *)operationTime
         completeBlock:(RequestCompleteBlock)block
           loadingView:(UIView *)view
               showHUD:(BOOL)showHUD {
    requestType = IPOWER_PR_DETAIL;
    selfShowHUD = showHUD;
    loadingView = view;
    if(token == nil) {
//        [self showNoData];
        return;
    }
    [self showHUD];
    
    
    NSString *urlString = [BaseUrl stringByAppendingString:GETDKREPORTLISTDATA];
    NSString *parameterStr = [NSString stringWithFormat:@"%@?accessToken=%@&operationTime=%@",urlString,token,operationTime];
    [request setURL:[NSURL URLWithString:parameterStr]];
    
    NSDictionary *dic = @{@"METHOD_NAME":NameString,@"QueryListData":EnNamedicinfo?EnNamedicinfo:@""};
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:@{@"JsonParaList":dic} options:0 error:nil];

    
   [request setHTTPBody:nsData];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self startImmediately:YES];
    selfBlock = block;
}

#pragma mark -- connection delegete
//接受服务器返回数据回调函数
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}
//接收服务器返回数据回调函数
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [selfData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSString *str = [[NSString alloc]initWithData:selfData encoding:NSUTF8StringEncoding];
    
    id dic = [NSJSONSerialization JSONObjectWithData:selfData options:NSJSONReadingAllowFragments error:&error];
     NSLog(@"dictionary %@", [[dic allValues] componentsJoinedByString:@","]);
    [self hideHUD];

    if (dic != nil && error == nil)
    {
       if ([dic isKindOfClass:[NSDictionary class]]){
           if([dic objectForKey:@"OperStatus"]!=nil){
               [self parseResponseResultV2:dic];
           }else{
               [self parseResponseResult:dic];
           }
        }
    }else {
        
        [self showAlertView:@"错误!" message:@"请联系系统管理员"];
    }
   
}


-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


//请求错误回调函数
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //关闭指示器
    [self hideHUD];
    //提示没有数据
    [self showNoData];
}

//解析返回结果
-(void)parseResponseResultV2:(NSDictionary *)dic{
    //关闭指示器
    [self hideHUD];
    NSString *errorStr = [dic objectForKey:@"OperStatus"];
    //如果没有错误
    if([errorStr isEqualToString:@""]){
        //获取各类维护等级统计数据接口
        if(requestType == GET_PR_SERVICE_LEVEL_DATA ){
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取蓄电池测试清单数据
        if(requestType == GET_PR_BATTERY_TEST_DATA){
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取蓄电池放电测试详情数据
        if(requestType == GET_PR_BATTERY_DISCHARGE_TEST_DETAIL){
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取蓄电池内阻测试详情数据
        if(requestType == GET_PR_BATTERY_INNER_RESISTANCE_TEST_DETAIL){
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取指定状态的核查计划数据
        if(requestType == GET_PR_CHECK_PLAN_DATA ){
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取指定巡查计划下指定状态的核查站点数据
        if(requestType == GET_PR_CHECK_STATION_DATA ){
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //认领/开始执行指定的核查任务
        if(requestType == EXCUTE_PR_CHECK_STATION ){
            if(selfBlock!=nil) {
                selfBlock(@"1");
            }
        }
        //获取指定核查站点的详情数据
        if(requestType == GET_PR_CHECK_STATION_DETAIL ){
            NSDictionary *resultDic = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultDic);
            }
        }
        //提交指定核查站点的核查结果数据
        if(requestType == SAVE_PR_CHECK_RESULT ){
            if(selfBlock!=nil) {
                selfBlock(@"1");
            }
        }
        
        
#pragma mark -------- dlp
        if(requestType == IPOWER_PR_ICON_LIST){
            
            
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }

        }
        
        if(requestType == IPOWER_PR_DETAIL){
            
            NSDictionary *resultDic = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultDic);
            }

        }
        
        
        
        if(requestType == IPOWER_PR_QUERYINFO){
            
//            NSDictionary *resultDic = [dic objectForKey:@"ResultData"];
//            if(selfBlock!=nil) {
//                selfBlock(resultDic);
//                
//            }
            
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }

        }
        
        
        
        
        
    }else{
        //获取各类维护等级统计数据接口
        if(requestType == GET_PR_SERVICE_LEVEL_DATA ) {
            if(selfBlock!=nil) {
                selfBlock(nil);
                [self showNoData];
            }
        }
        //获取蓄电池测试清单数据
        if(requestType == GET_PR_BATTERY_TEST_DATA){
            if(selfBlock!=nil) {
                selfBlock(nil);
                [self showNoData];
            }
        }
        //获取蓄电池放电测试详情数据
        if(requestType == GET_PR_BATTERY_DISCHARGE_TEST_DETAIL){
            if(selfBlock!=nil) {
                selfBlock(nil);
                [self showNoData];
            }
        }
        //获取蓄电池内阻测试详情数据
        if(requestType == GET_PR_BATTERY_INNER_RESISTANCE_TEST_DETAIL){
            if(selfBlock!=nil) {
                selfBlock(nil);
                [self showNoData];
            }
        }
 
        
        

        
        
        
        
        
        
        
    }
    
}

-(void)parseResponseResult:(NSDictionary *)dic{
    //关闭指示器
    [self hideHUD];
    NSString *resultCode = [dic objectForKey:@"result"];
    NSString *errorStr = [dic objectForKey:@"error"];
    //获取数据成功
    if([resultCode isEqualToString:@"0000000"]) {
        //获取我的待处理任务数量
        if(requestType == GET_MY_TASK_AMOUNT) {
            NSMutableDictionary *resultDic = [dic objectForKey:@"detail"];
            NSString *amount = [resultDic objectForKey:@"amount"];
            if(selfBlock!=nil) {
                selfBlock(amount);
            }
        }
        //获取组任务数量
        if(requestType == GET_GROUP_TASK_AMOUNT) {
            NSMutableDictionary *resultDic = [dic objectForKey:@"detail"];
            NSString *amount = [resultDic objectForKey:@"amount"];
            if(selfBlock!=nil) {
                selfBlock(amount);
            }
        }
        //获取指定坐标附近的站点信息
        if(requestType == GET_SITE_INFO_WITH_LOCATION || requestType== GET_SITE_INFO_WITH_RES_NO) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取我的任务列表
        if(requestType == GET_MY_TASK_LIST ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取全组任务列表
        if(requestType == GET_GROUP_TASK_LIST) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取二级任务列表
        if(requestType == GET_SUB_TASK_LIST ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取进行中的任务列表
        if(requestType == GET_PROCESSING_TASK_LIST ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取未完成的任务清单信息
        if(requestType == GET_UNFINISHING_TASK_DETAIL ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取进行中的任务清单信息
        if(requestType == GET_PROCESSING_TASK_DETAIL ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取已完成的任务清单信息
        if(requestType == GET_FINISHED_TASK_DETAIL ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //开始维护
        if(requestType == START_PROCESS_TASK ) {
            if(selfBlock!=nil) {
                selfBlock(nil);
            }
        }
        //结束维护
        if(requestType == STOP_PROCESS_TASK ) {
            if( selfBlock!=nil ) {
                selfBlock(nil);
            }
        }
        //获取告警列表
        if(requestType == GET_ALARM_LIST ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            //按时间排序
            NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"ALARM_TIME" ascending:NO];
            NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
            NSArray *sortArray=[resultArray sortedArrayUsingDescriptors:sortDescriptors];
            if(selfBlock!=nil) {
                selfBlock(sortArray);
                
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取告警实时信息
        if(requestType == GET_ALARM_RUNTIME_INFO ) {
            NSDictionary *warningDic = [dic objectForKey:@"detail"];
            if(selfBlock != nil ) {
                selfBlock(warningDic);
                
                if(warningDic != nil ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
            
        }
        //获取实时告警数据
        if(requestType == GET_ALARM_RUNTIME_DATA ) {
            NSDictionary *runtimeInfo = [dic objectForKey:@"list2"];
            NSString *waitTime = [dic objectForKey:@"waittime"];
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
            [newDic setValue:runtimeInfo forKey:@"runtimeInfo"];
            [newDic setValue:waitTime forKey:@"waittime"];
            if(selfBlock != nil ) {
                selfBlock(newDic);
            }
            if(runtimeInfo != nil ){
                [self showNoData];
            }else {
                [self hideNoData];
            }
        }
        //获取用户所能访问的区局信息
        if(requestType == GET_USER_REGION_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取用户所能访问的站点信息
        if(requestType == GET_USER_STATION_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取设备清单数据
        if(requestType == GET_USER_DEVICE_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取指定设备大类下的设备子类列表
        if(requestType == GET_DEVICE_SUBCLASS_LIST ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取指定站点下的动力系统数据
        if(requestType == GET_USER_POWER_SYSTEM_LIST ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取指定站点下的机房数据
        if(requestType == GET_USER_ROOM_LIST ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取与设备有关的公共信息
        if(requestType == GET_DEVICE_COMMON_INFO ) {
            NSDictionary *detailDic = [dic objectForKey:@"detail"];
            NSArray *detailList = [detailDic objectForKey:@"detailList"];
            if(selfBlock!=nil) {
                selfBlock(detailList);
                if(detailList.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取设备状态数据
        if(requestType == GET_DEVICE_STATUS_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取设备的扩展信息
        if(requestType == GET_DEVICE_EXTEND_INFO ) {
            NSDictionary *detailDic = [dic objectForKey:@"detail"];
            NSArray *detailList = [detailDic objectForKey:@"detailList"];
            if(selfBlock!=nil) {
                selfBlock(detailList);
            }
        }
        //获取设备端子信息
        if(requestType == GET_DEVICE_CONNECTOR_INFO ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取指定设备大类下的设备类型数据
        if(requestType == GET_DEVICE_TYPE_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取某类设备的前十位厂家数据
        if(requestType == GET_DEVICE_BF_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //保存设备相关数据
        if(requestType == SAVE_DEVICE_PROPERTY ) {
            selfBlock(@"提交数据成功!");
        }
        //提交巡检结果
        if(requestType == SAVE_DEVICE_REPORT ) {
            selfBlock(@"提交数据成功!");
        }
        //获取用户所在区域内所有的当前告警清单数据
        if(requestType == GET_DK_CURRENT_ALARM_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取历史告警清单数据
        if(requestType == GET_HISTORY_ALARM_DATA ) {
            NSDictionary *resultDic = [dic objectForKey:@"detail"];
            if(selfBlock!=nil) {
                selfBlock(resultDic);
                if([[resultDic objectForKey:@"ROWCOUNT"] isEqualToString:@"0"]){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取用户区局数据
        if(requestType == GET_USER_AREA_DATA) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取重大告警类型分组数据
        if(requestType == GET_FATAL_ALARM_GROUP_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取频繁告警数据
        if(requestType == GET_FREQUENT_ALARM_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取重大告警数据列表
        if(requestType == GET_CURRENT_ALARM_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取故障派修列表
        if(requestType == GET_DEVICE_FAULT_DATA) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取故障详情
        if(requestType == GET_DEVICE_FAULT_DETAIL ) {
            NSDictionary *infoDic = [dic objectForKey:@"detail"];
            if(selfBlock!=nil) {
                selfBlock(infoDic);
            }
        }
        //获取故障流转
        if(requestType == GET_FAULT_TRANSFER_DATA ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取设备大类
        if(requestType == GET_FAULT_DEVICE_CLASS ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        //获取故障级别
        if(requestType == GET_DEVICE_FAULT_LEVEL ) {
            NSMutableArray *resultArray = [dic objectForKey:@"list"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        
        
        //ICON LIST
        if(requestType == IPOWER_PR_ICON_LIST ) {
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        
        
        
        
        if(requestType == IPOWER_PR_QUERYINFO ) {
            
            NSMutableArray *resultArray = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(resultArray);
                if(resultArray.count == 0 ){
                    [self showNoData];
                }else {
                    [self hideNoData];
                }
            }
        }
        
        if(requestType == IPOWER_PR_DETAIL ) {
            
            NSDictionary *infoDic = [dic objectForKey:@"ResultData"];
            if(selfBlock!=nil) {
                selfBlock(infoDic);
            }
            
        }
        
 
        
        
        
    }
  



    

    //获取数据失败
    else {
        //获取设备数据和设备端子，由于返回的格式不同，需要特殊处理
        if(requestType == GET_USER_DEVICE_DATA ) {
            if(selfBlock!=nil) {
                selfBlock(nil);
                [self showNoData];
            }
        }else
        //获取当前告警数据
        if(requestType == GET_DK_CURRENT_ALARM_DATA ) {
            if(selfBlock!=nil){
                selfBlock(nil);
                [self showNoData];
            }
        }
        else if(requestType==GET_USER_REGION_DATA){
            if(selfBlock!=nil){
                selfBlock(nil);
                [self showNoData];
            }
        }
        else if(requestType == GET_HISTORY_ALARM_DATA ) {
            if(selfBlock!=nil){
                selfBlock(nil);
                [self showNoData];
            }
        }
        else if(requestType == GET_FREQUENT_ALARM_DATA ) {
            if(selfBlock!=nil){
                selfBlock(nil);
                [self showNoData];
            }
        }
        else if(requestType == GET_DEVICE_FAULT_DATA ) {
            if(selfBlock!=nil){
                selfBlock(nil);
                [self showNoData];
            }
        }
        else {
            [self showNoData];
        }
//        if(requestType == GET_DEVICE_CONNECTOR_INFO) {
//            [self showNoData];
//            return;
//        }else
//        if(requestType == GET_FAULT_TRANSFER_DATA ) {
//            [self showNoData];
//            return;
//        }else {
//            
//        }
//        
//        [self showAlertView:@"" message:errorStr];
        

    }
}

//显示加载提示
-(void)showHUD {
    if(selfShowHUD == YES ) {
        UIApplication *app =[UIApplication sharedApplication];
        AppDelegate *delegate = app.delegate;
        [delegate showHUD];
    }
}

//隐藏加载提示
-(void)hideHUD {
    if(selfShowHUD == YES) {
        UIApplication *app =[UIApplication sharedApplication];
        AppDelegate *delegate = app.delegate;
        [delegate hideHUD];
    }
}

//有数据时隐藏
-(void)hideNoData {
    if(loadingView !=nil ) {
        UIView *noDataView = [loadingView viewWithTag:noDataTag];
        if(noDataView != nil ) {
            [noDataView removeFromSuperview];
        }
    }
}

//没有数据时显示暂无数据
-(void)showNoData {
    if(loadingView !=nil ) {
        UIView *noDataView = [loadingView viewWithTag:noDataTag];
        if(noDataView == nil ) {
            noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,100,50)];
            noDataView.backgroundColor = [UIColor clearColor];
            noDataView.tag = noDataTag;
            noDataView.center = CGPointMake(loadingView.width/2,loadingView.height/2);
            UILabel *noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
            noDataLabel.textAlignment = NSTextAlignmentCenter;
            noDataLabel.text = @"";
            noDataLabel.backgroundColor = [UIColor clearColor];
            
            [noDataView addSubview:noDataLabel];
            [loadingView addSubview:noDataView];
        }
        [loadingView bringSubviewToFront:noDataView];
    }
}

-(void)showAlertView:(NSString *)title
             message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}
@end
