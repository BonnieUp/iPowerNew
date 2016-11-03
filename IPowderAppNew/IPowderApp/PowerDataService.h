//
//  PowerDataService.h
//  IPowderApp
//
//  Created by 王敏 on 14-6-11.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void(^RequestCompleteBlock) (id);

//服务类型枚举
typedef NS_ENUM(NSInteger, ServiceTypeEnum) {
    GET_MY_TASK_AMOUNT=0, //获取我的待处理任务数量
    GET_GROUP_TASK_AMOUNT = 1 ,//获取组任务数量
    GET_SITE_INFO_WITH_LOCATION = 2, //获取指定地理位置附近的站点信息
    GET_SITE_INFO_WITH_RES_NO = 3, //获取指定设备号附近的站点信息
    GET_MY_TASK_LIST = 4, //获取我的任务列表
    GET_GROUP_TASK_LIST = 5, //获取组任务列表
    GET_SUB_TASK_LIST = 6,  //获取二级任务列表
    GET_PROCESSING_TASK_LIST = 7, //获取进行中的任务列表
    GET_UNFINISHING_TASK_DETAIL = 8, //获取未完成的任务清单信息
    GET_PROCESSING_TASK_DETAIL = 9,  //获取进行中的任务清单信息
    GET_FINISHED_TASK_DETAIL = 10, //获取已完成的任务清单信息
    START_PROCESS_TASK = 11, //开始维护
    STOP_PROCESS_TASK = 12, //提交维护数据(结束维护)
    GET_ALARM_LIST = 13, //获取告警信息
    GET_ALARM_RUNTIME_INFO = 14, //获取实时告警信息
    GET_ALARM_RUNTIME_DATA = 15, //获取实时告警数据
    GET_USER_REGION_DATA = 16, //获取用户所能访问的区局信息
    GET_USER_STATION_DATA = 17, //获取指定区局下的相关站点数据
    GET_USER_DEVICE_DATA = 18, //获取设备清单数据
    GET_DEVICE_SUBCLASS_LIST = 19, //获取指定设备大类下的设备子类列表
    GET_USER_POWER_SYSTEM_LIST = 20,//获取指定站点下的动力系统数据
    GET_USER_ROOM_LIST = 21, //获取指定站点下的机房数据
    GET_DEVICE_COMMON_INFO = 22, //获取设备的公共信息
    GET_DEVICE_EXTEND_INFO = 23, //获取设备的扩展信息
    GET_DEVICE_CONNECTOR_INFO = 24, //获取设备的端子信息
    GET_DEVICE_STATUS_DATA = 25,//获取设备状态数据
    GET_DEVICE_TYPE_DATA = 26, //获取指定设备大类下的设备类型数据
    GET_DEVICE_BF_DATA = 27,//获取某类设备的前十位厂家数据(PR)
    SAVE_DEVICE_PROPERTY = 28,//保存设备相关数据
    SAVE_DEVICE_REPORT = 29, //提交巡检报告数据
    GET_DK_CURRENT_ALARM_DATA = 30, //获取用户所在区域内所有的当前告警清单数据
    GET_HISTORY_ALARM_DATA = 31,//获取历史告警清单数据
    GET_USER_AREA_DATA = 32,//获取用户区域数据
    GET_FATAL_ALARM_GROUP_DATA = 33, //获取重大告警类型分组数据
    GET_FREQUENT_ALARM_DATA = 34, //获取频繁告警列表
    GET_DEVICE_FAULT_DATA = 35,//获取故障清单数据
    GET_DEVICE_FAULT_DETAIL = 36, //获取指定故障的详情数据
    GET_FAULT_TRANSFER_DATA = 37,//获取指定故障的流转信息
    GET_CURRENT_ALARM_DATA = 38, //获取重大告警列表数据
    GET_FAULT_DEVICE_CLASS = 39,//获取我的网管模块里的设备大类列表
    GET_DEVICE_FAULT_LEVEL = 40, //获取故障级别列表
    GET_PR_SERVICE_LEVEL_DATA = 41, //获取各类维护等级统计数据接口
    GET_PR_BATTERY_TEST_DATA = 42,    //获取蓄电池测试清单数据
    GET_PR_BATTERY_DISCHARGE_TEST_DETAIL = 43,//获取蓄电池放电测试详情数据。
    GET_PR_BATTERY_INNER_RESISTANCE_TEST_DETAIL = 44, //获取蓄电池内阻测试详情数据接口
    GET_PR_CHECK_PLAN_DATA = 45,  //获取指定状态的核查计划数据
    GET_PR_CHECK_STATION_DATA = 46,//获取指定计划下指定状态的核查站点数据接口
    EXCUTE_PR_CHECK_STATION = 47,//认领/开始执行指定的核查任务
    GET_PR_CHECK_STATION_DETAIL = 48,//获取指定核查站点的详情数据
    SAVE_PR_CHECK_RESULT = 49,//提交指定核查站点的核查结果数据
    
    
    IPOWER_PR_ICON_LIST = 50,//ICON LIST
    IPOWER_PR_QUERYINFO = 51,//查找
    
    IPOWER_PR_DETAIL = 52//详情

};

@interface PowerDataService : NSObject<NSURLConnectionDelegate> {
    RequestCompleteBlock selfBlock;
    UIView * loadingView;
    NSMutableURLRequest *request;
    NSURLConnection *connection;
    NSMutableData *selfData;
    ServiceTypeEnum requestType;
    BOOL selfShowHUD;
    
}

-(id)initUserJsonHead;

//获取任务数量
-(void)getTaskAmountWithAccessToken:(NSString *)token
                operationTime:(NSString *)operationTime
                    taskScope:(NSString *)taskScope
                         taskStatus:(NSString *)taskStatus
                    startDate:(NSString *)startDate
                    endDate:(NSString *)endDate
                    completeBlock:(RequestCompleteBlock)block
                    loadingView:(UIView *)view
                    showHUD:(BOOL)showHUD;



//获取地理位置附近的站点信息
-(void)getSiteInfoWithAccessToken:(NSString *)token
                    operationTime:(NSString *)operationTime
                              lng:(NSString *)lng //经度
                              lat:(NSString *)lat //纬度
                            resNo:(NSString *)resNo //实物编号
                            completeBlock:(RequestCompleteBlock)block
                            loadingView:(UIView *)view
                            showHUD:(BOOL)showHUD;

//获取任务列表（一级）
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
                   showHUD:(BOOL)showHUD;

//获取任务数据（二级）
-(void)getTaskWithAccessToken:(NSString *)token
                operationTime:(NSString *)operationTime
                       siteId:(NSString *)siteId
                   taskTypeId:(NSString *)taskTypeId
                     taskStat:(NSString *)taskStat
                        resNo:(NSString *)resNo
                    startDate:(NSString *)startDate
                      endDate:(NSString *)endDate
                completeBlock:(RequestCompleteBlock)block
                  loadingView:(UIView *)view
                      showHUD:(BOOL)showHUD;

//获取进行中的任务列表
-(void)getProcessingTaskWithAccessToken:(NSString *)token
                          operationTime:(NSString *)operationTime
                                 siteId:(NSString *)siteId
                             subTaskStat:(NSString *)subTaskStat
                               taskStat:(NSString *)taskStat
                              startDate:(NSString *)startDate
                                endDate:(NSString *)endDate
                          completeBlock:(RequestCompleteBlock)block
                            loadingView:(UIView *)view
                                showHUD:(BOOL)showHUD;

//获取任务中的任务清单信息
-(void)getTaskDetailInfoWithAccessToken:(NSString *)token
                          operationTime:(NSString *)operationTime
                                 taskId:(NSString *)taskId
                            subTaskStat:(NSString *)subTaskStat
                          completeBlock:(RequestCompleteBlock)block
                            loadingView:(UIView *)view
                                showHUD:(BOOL)showHUD;

//开始维护
-(void)startProcessTaskWithAccessToken:(NSString *)token
                         operationTime:(NSString *)operationTime
                         subTaskIdList:(NSString *)subTaskIdList
                                isAuto:(NSString *)isAuto
                         completeBlock:(RequestCompleteBlock)block
                           loadingView:(UIView *)view
                               showHUD:(BOOL)showHUD;

//结束维护
-(void)stopProcessTaskWithAccessToken:(NSString *)token
                        operationTime:(NSString *)operationTime
                            subTaskId:(NSString *)subTaskId
                           isFinished:(NSString *)isFinished
                               remark:(NSString *)remark
                          taskContent:(NSString *)taskContent
                              faultNO:(NSString *)faultNO
                        completeBlock:(RequestCompleteBlock)block
                          loadingView:(UIView *)view
                              showHUD:(BOOL)showHUD;


//获取告警信息
-(void)getAlarmListWithAccessToken:(NSString *)token
                     operationTime:(NSString *)operationTime
                            siteId:(NSString *)siteId
                         startDate:(NSString *)startDate
                           endDate:(NSString *)endDate
                         alarmType:(NSString *)alarmType
                     completeBlock:(RequestCompleteBlock)block
                       loadingView:(UIView *)view
                           showHUD:(BOOL)showHUD;


//获取实时告警信息
-(void)getRunTimeAlarmInfoWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                 alarmNum:(NSString *)alarmNum
                                alarmType:(NSString *)alarmType
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD;


//获取实时告警数据
-(void)getRunTimeAlarmDataWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                 nuId:(NSString *)nuId
                                dataType:(NSString *)dataType
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD;

//获取用户所能访问的区局信息
-(void)getUserRegionDataWithAccessToken:(NSString *)token
                          operationTime:(NSString *)operationTime
                          completeBlock:(RequestCompleteBlock)block
                            loadingView:(UIView *)view
                                showHUD:(BOOL)showHUD;

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
                                 showHUD:(BOOL)showHUD;


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
                                showHUD:(BOOL)showHUD;


//获取指定设备大类下的设备子类列表
-(void)getSubDeviceWithAccessToken:(NSString *)token
                     operationTime:(NSString *)operationTime
                       devClassNum:(NSString *)devClassNum
                    devSubClassNum:(NSString *)devSubClassNum
                   devSubClassName:(NSString *)devSubClassName
                       devTypeName:(NSString *)devTypeName
                     completeBlock:(RequestCompleteBlock)block
                       loadingView:(UIView *)view
                           showHUD:(BOOL)showHUD;


//获取指定站点下的动力系统数据
-(void)getUserPowerSystemWithAccessToken:(NSString *)token
                           operationTime:(NSString *)operationTime
                             stationNum:(NSString *)stationNum
                          sysClassNum:(NSString *)sysClassNum
                           completeBlock:(RequestCompleteBlock)block
                             loadingView:(UIView *)view
                                 showHUD:(BOOL)showHUD;

//获取指定站点下的机房数据
-(void)GetUserRoomDataWithAccessToken:(NSString *)token
                        operationTime:(NSString *)operationTime
                           stationNum:(NSString *)stationNum
                             roomName:(NSString *)roomName
                        completeBlock:(RequestCompleteBlock)block
                          loadingView:(UIView *)view
                              showHUD:(BOOL)showHUD;

//获取与设备有关的信息
-(void)getDeviceCommonInfoWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                   devNum:(NSString *)devNum
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD;


//获取设备的扩展信息
-(void)getDeviceExtendInfoWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                   devNum:(NSString *)devNum
                               devTypeNum:(NSString *)devTypeNum
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD;

//获取设备的端子信息
-(void)getDeviceConnectorInfoWithAccessToken:(NSString *)token
                               operationTime:(NSString *)operationTime
                                      devNum:(NSString *)devNum
                               completeBlock:(RequestCompleteBlock)block
                                 loadingView:(UIView *)view
                                     showHUD:(BOOL)showHUD;

//获取设备状态数据
-(void)getDeviceStatusInfoWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD;

//获取指定设备大类下的设备类型数据
-(void)GetDeviceTypeDataWithAccessToken:(NSString *)token
                          operationTime:(NSString *)operationTime
                            devClassNum:(NSString *)devClassNum
                         devSubClassNum:(NSString *)devSubClassNum
                        devSubClassName:(NSString *)devSubClassName
                            devTypeName:(NSString *)devTypeName
                          completeBlock:(RequestCompleteBlock)block
                            loadingView:(UIView *)view
                                showHUD:(BOOL)showHUD;

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
                                showHUD:(BOOL)showHUD;

//保存设备相关数据
-(void)saveDevicePropertyWithAccessToken:(NSString *)token
                           operationTime:(NSString *)operationTime
                                  devInfo:(NSString *)devInfo
                           completeBlock:(RequestCompleteBlock)block
                             loadingView:(UIView *)view
                                 showHUD:(BOOL)showHUD;

//提交巡检报告数据
-(void)saveDeviceReportWithAccessToken:(NSString *)token
                         operationTime:(NSString *)operationTime
                               checkInfo:(NSString *)checkInfo
                         completeBlock:(RequestCompleteBlock)block
                           loadingView:(UIView *)view
                               showHUD:(BOOL)showHUD;

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
                                    showHUD:(BOOL)showHUD;

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
                                  showHUD:(BOOL)showHUD;

//获取用户区域数据
-(void)getUserAreaDataWithAccessToken:(NSString *)token
                        operationTime:(NSString *)operationTime
                        completeBlock:(RequestCompleteBlock)block
                          loadingView:(UIView *)view
                              showHUD:(BOOL)showHUD;

//获取重大告警类型分组数据
-(void)getFatalAlarmGroupDataWithAccessToken:(NSString *)token
                               operationTime:(NSString *)operationTime
                               completeBlock:(RequestCompleteBlock)block
                                 loadingView:(UIView *)view
                                     showHUD:(BOOL)showHUD;

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
                               showHUD:(BOOL)showHUD;

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
                                 showHUD:(BOOL)showHUD;

//获取指定故障的详情数据
-(void)getDeviceFaultDetailWithAccessToken:(NSString *)token
                             operationTime:(NSString *)operationTime
                                  WXFULLNO:(NSString *)WXFULLNO
                             completeBlock:(RequestCompleteBlock)block
                               loadingView:(UIView *)view
                                   showHUD:(BOOL)showHUD;

//获取指定故障的流转信息
-(void)GetFaultTransferDataWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                 WXFULLNO:(NSString *)WXFULLNO
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD;

//获取重大告警列表数据
-(void)getCurrentAlarmDataWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                                startTime:(NSString *)startTime
                                 stopTime:(NSString *)stopTime
                         fatalAlarmRuleID:(NSString *)fatalAlarmRuleID
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD;

//获取我的网管模块里的设备大类列表
-(void)getDeviceClassForWangguanWithAccessToken:(NSString *)token
                                  operationTime:(NSString *)operationTime
                                  completeBlock:(RequestCompleteBlock)block
                                    loadingView:(UIView *)view
                                        showHUD:(BOOL)showHUD;

//获取故障级别列表
-(void)getDeviceFaultLevelWithAccessToken:(NSString *)token
                            operationTime:(NSString *)operationTime
                            completeBlock:(RequestCompleteBlock)block
                              loadingView:(UIView *)view
                                  showHUD:(BOOL)showHUD;

//获取各类维护等级统计数据接口
-(void)getPRServiceLevelDataWithAccessToken:(NSString *)token
                              operationTime:(NSString *)operationTime
                                     regNum:(NSString *)regNum
                                 ObjTypeNum:(NSString *)objTypeNum
                              completeBlock:(RequestCompleteBlock)block
                                loadingView:(UIView *)view
                                    showHUD:(BOOL)showHUD;

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
                                       showHUD:(BOOL)showHUD;

//获取蓄电池放电测试详情数据
-(void)getPrBatteryDischargeTestDetailWithAccessToken:(NSString *)token
                                    operationTime:(NSString *)operationTime
                                           objNum:(NSString *)objNum
                                    completeBlock:(RequestCompleteBlock)block
                                      loadingView:(UIView *)view
                                          showHUD:(BOOL)showHUD;

//获取蓄电池内阻测试详情数据
-(void)getPrBatteryInnerResistanceTestDetailWithAccessToken:(NSString *)token
                                              operationTime:(NSString *)operationTime
                                                     objNum:(NSString *)objNum
                                              completeBlock:(RequestCompleteBlock)block
                                                loadingView:(UIView *)view
                                                    showHUD:(BOOL)showHUD;

//获取指定状态的核查计划数据
-(void)getPrCheckPlanDataWithAccessToken:(NSString *)token
                           operationTime:(NSString *)operationTime
                                  checkStatusNum:(NSString *)checkStatusNum
                           completeBlock:(RequestCompleteBlock)block
                             loadingView:(UIView *)view
                                 showHUD:(BOOL)showHUD;

//获取指定巡查计划下指定状态的核查站点数据
-(void)getPrCheckStationDataWithAccessToken:(NSString *)token
                              operationTime:(NSString *)operationTime
                             checkStatusNum:(NSString *)checkStatusNum
                                    planNum:(NSString *)planNum
                              completeBlock:(RequestCompleteBlock)block
                                loadingView:(UIView *)view
                                    showHUD:(BOOL)showHUD;

//认领/开始执行指定的核查任务
-(void)excutePrCheckStationWithAccessToken:(NSString *)token
                             operationTime:(NSString *)operationTime
                            operStatusNum:(NSString *)operStatusNum
                                   recordNumList:(NSString *)recordNumList
                             completeBlock:(RequestCompleteBlock)block
                               loadingView:(UIView *)view
                                   showHUD:(BOOL)showHUD;

//获取指定核查站点的详情数据
-(void)getPrCheckStationDetailWithAccessToken:(NSString *)token
                                operationTime:(NSString *)operationTime
                                recordNum:(NSString *)recordNum
                                isEdit:(NSString *)isEdit
                                completeBlock:(RequestCompleteBlock)completeBlock
                                  loadingView:(UIView *)view
                                      showHUD:(BOOL)showHUD;

//提交指定核查站点的核查结果数据
-(void)savePrCheckResultWithAccessToken:(NSString *)token
                          operationTime:(NSString *)operationTime
                          recordNum:(NSString *)recordNum
                              commonInfoDic:(NSDictionary *)commonInfoDic
                          extendDic:(NSDictionary *)extendDic
                                 completeBlock:(RequestCompleteBlock)completeBlock
                            loadingView:(UIView *)view
                                showHUD:(BOOL)showHUD;



#pragma mark -- dinglangping 请求方法封装

//1.获取模块清单类型数据

-(void)getMangmentIconList:(NSString *)token
             Type:(NSString*)mangmentType
             operationTime:(NSString *)operationTime
             completeBlock:(RequestCompleteBlock)block
               loadingView:(UIView *)view
                   showHUD:(BOOL)showHUD;
//2.获取报表数据，显示在报表

-(void)getQueryReportDetail:(NSString *)token Type:(NSString*)Mothed
         operationTime:(NSString *)operationTime
         completeBlock:(RequestCompleteBlock)block
           loadingView:(UIView *)view
               showHUD:(BOOL)showHUD;

//3.获取指定报表类型的查询条件

-(void)getData:(NSString *)token Type:(NSString*)NameString EnNamedic:(NSDictionary*)EnNamedicinfo
      operationTime:(NSString *)operationTime
      completeBlock:(RequestCompleteBlock)block
        loadingView:(UIView *)view
            showHUD:(BOOL)showHUD;

@end
