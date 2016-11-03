//
//  EditPropertyCell.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"
#import "CommonPropertyModelViewController.h"
#import "YXPActionSheet.h"
//服务类型枚举
typedef NS_ENUM(NSInteger, EditCellTypeEnum) {
    EDIT_PROPERTY_CELL_LABEL=1, //只读取控件(标签控件)
    EDIT_PROPERTY_CELL_INPUT=2, //文本框控件(可输入任何字符)
    EDIT_PROPERTY_CELL_INPUT_NUM=3, //文本框控件(只能接收数值)
    EDIT_PROPERTY_CELL_DATE=4, //日期控件
    EDIT_PROPERTY_CELL_COMBOBOX=5, //下拉选择控件(无需联动）
    EDIT_PROPERTY_CELL_COMBOBOX_WITH_SERVICE=6, //下拉选择控件(需要联动)
    EDIT_PROPERTY_CELL_INPUT_COMBOBOX=7, //即可下拉选择又可输入控件
    EDIT_PROPERTY_CELL_WITCH_CON = 8, //
    EDIT_PROPERTY_CELL_NUMBERIC = 9 //数字控件
};

typedef  void(^EditPropertyPopWindowBlock) (NSMutableDictionary *);
typedef  void(^EditPropertySetCurrentValueBlock) (NSMutableDictionary *);

@interface EditPropertyCell : UIView<UITextFieldDelegate,CustomSwitchDelegate,CommonPropertyDelegate,YXPActionSheetDelegate>

-(id)initWithFrame:(CGRect)frame
          required:(BOOL)required
        labelTitle:(NSString *)labelTitle
          oriValue:(NSDictionary *)oriValue
              type:(EditCellTypeEnum )type;

//如果是switch类型的控件，自定义皮肤
-(void)setSwitchOnImage:(UIImage *)onImage
               offImage:(UIImage *)offImage;

@property (nonatomic,assign)BOOL isEdited;

@property (nonatomic,strong) EditPropertyPopWindowBlock selfBlock;

@property (nonatomic,strong) EditPropertySetCurrentValueBlock setValueBlock;

@property (nonatomic,strong) NSArray *enumDataSource;

-(void)setCurrentDic:(NSDictionary *)dic;
-(NSDictionary *)getCurrentDic;
//验证必填项是否符合要求
-(BOOL)validateReqiured;
//获取验证不通过时的提示信息
-(NSString *)getInvalidaString;

//设置label宽度
-(void)setTitleLabelWidth:(float)width;

//用指定的数据源弹出选择属性窗口
-(void)popWindowWithDataSource:(NSArray *)dataSource;

//可能用到的需要返回的参数，本身不做任何处理
@property (nonatomic,strong)NSDictionary *realationDic;


@property (nonatomic,strong)NSString *dateFormatString;

-(void)setNumbericMin:(int) min Max:(int) max;

@end
