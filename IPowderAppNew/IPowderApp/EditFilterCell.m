//
//  EditFilterCell.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-25.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "EditFilterCell.h"

@implementation EditFilterCell {
    //控件类型
    EditFilterCellTypeEnum cellType;
    //控件显示名称
    NSString *title;
    //控件的原始值(字典)
    NSMutableDictionary *oriValueDic;
    //控件的当前值(字典)
    NSMutableDictionary *currentValueDic;
    NSString *tailStr;
    //是否必填
    BOOL isRequired;
    float labelWidth;
    //----view
    //显示名称的label
    UILabel *titleLabel;
    //是否必填的标志
    UILabel *isNeedLabel;
    //主控件，有枚举的类型
    id mainController;
    
    
    //skin
    UIImage *onImage;
    UIImage *offImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(filterCellTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame required:(BOOL)required labelTitle:(NSString *)labelTitle oriValue:(NSDictionary *)oriValue type:(EditFilterCellTypeEnum)type{
    //大小是固定的
    self = [self initWithFrame:frame];
    if(self) {
        cellType = type;
        title = labelTitle;
        if(oriValue==nil){
            currentValueDic = [[NSMutableDictionary alloc]init];
            oriValueDic = [[NSMutableDictionary alloc]init];
        }else{
            currentValueDic = [NSMutableDictionary dictionaryWithDictionary:oriValue];
            oriValueDic = [NSMutableDictionary dictionaryWithDictionary:oriValue];
        }
        isRequired = required;
        _isEdited = NO;
        labelWidth = 80.0f;
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    //显示名称的label
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, labelWidth-5, 39)];
    titleLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    
    //是否必填
    isNeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 10,39)];
    isNeedLabel.text = @"*";
    isNeedLabel.font = [UIFont systemFontOfSize:14];
    isNeedLabel.textAlignment = NSTextAlignmentCenter;
    isNeedLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    isNeedLabel.textColor = [UIColor redColor];
    if(isRequired == YES ) {
        isNeedLabel.text = @"*";
    }else {
        isNeedLabel.text = @"";
    }
    [self addSubview:isNeedLabel];
    
    //主控件
    mainController = [self createControllWithType:cellType];
    [self setMainControllerValue];
    [self addSubview:mainController];
    
    
    //添加下划线
    UIView *horizontalLineUp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    horizontalLineUp.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
    [self addSubview:horizontalLineUp];
    
    //添加下划线
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, self.width, 0.5)];
    horizontalLine.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
    [self addSubview:horizontalLine];
    
    if(cellType==EDITCELL_INPUT_NUM && tailStr!=nil){
        ((UITextField *)mainController).frame = CGRectMake(labelWidth+10, 3, ScreenWidth-labelWidth-55, 33);
        //tail label;
        UILabel *tailLabel = [[UILabel alloc]init];
        tailLabel.textAlignment = NSTextAlignmentCenter;
        tailLabel.font = [UIFont systemFontOfSize:14];
        tailLabel.text = tailStr;
        tailLabel.frame = CGRectMake(self.width-55, 0, 55, 39);
        [self addSubview:tailLabel];
    }
}

//给创建的控件赋值
-(void)setMainControllerValue {
    switch (cellType) {
        case EDITCELL_LABEL:
            ((UILabel *)mainController).text = [currentValueDic objectForKey:@"name"];
            break;
        case EDITCELL_INPUT:
        case EDITCELL_INPUT_NUM:
            ((UITextField *)mainController).text = [currentValueDic objectForKey:@"name"];
            break;
        case EDITCELL_DATE:
        case EDITCELL_COMBOBOX:
        case EDITCELL_COMBOBOX_WITH_SERVICE:
            [((UIButton *)mainController) setTitle:[currentValueDic objectForKey:@"name"] forState:UIControlStateNormal];
            break;
        case EDITCELL_INPUT_COMBOBOX:
            if([mainController respondsToSelector:@selector(viewWithTag:)]) {
                UITextField *leftView = (UITextField *)[mainController viewWithTag:100];
                leftView.text = [currentValueDic objectForKey:@"name"];
            }
            break;
        case EDITCELL_WITCH_CON:
            if(onImage!=nil && offImage != nil) {
                [((CustomSwitch *)mainController) setSwitchOnImage:onImage offImage:offImage];
            }else {
                CGRect frame = ((CustomSwitch *)mainController).frame;
                frame.size.width = 60;
                ((CustomSwitch *)mainController).frame = frame;
            }
            if([[currentValueDic objectForKey:@"value"] isEqualToString:@"1"]) {
                ((CustomSwitch *)mainController).on = YES;
            }else {
                ((CustomSwitch *)mainController).on = NO;
            }
            break;
        default:
            break;
    }
}

//根据类型创建控件
-(id)createControllWithType:(EditFilterCellTypeEnum )type {
    id controller;
    switch (type) {
            //label
        case EDITCELL_LABEL:
            controller = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+10, 3, ScreenWidth-labelWidth-15, 33)];
            ((UILabel *)controller).font = [UIFont systemFontOfSize:14];
            ((UILabel *)controller).textAlignment = NSTextAlignmentLeft;
            break;
            //input
        case EDITCELL_INPUT:
            controller = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+10, 3, ScreenWidth-labelWidth-15, 33)];
            ((UITextField *)controller).font = [UIFont systemFontOfSize:14];
            ((UITextField *)controller).contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            ((UITextField *)controller).textAlignment = NSTextAlignmentLeft;
            ((UITextField *)controller).layer.borderWidth = 0.5;
            ((UITextField *)controller).layer.borderColor = [UIColor grayColor].CGColor;
            ((UITextField *)controller).delegate = self;
            break;
            //input with num
        case EDITCELL_INPUT_NUM:
            controller = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+10, 3, ScreenWidth-labelWidth-15, 33)];
            ((UITextField *)controller).font = [UIFont systemFontOfSize:14];
            ((UITextField *)controller).contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            ((UITextField *)controller).textAlignment = NSTextAlignmentLeft;
            ((UITextField *)controller).keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            ((UITextField *)controller).layer.borderWidth = 0.5;
            ((UITextField *)controller).layer.borderColor = [UIColor grayColor].CGColor;
            ((UITextField *)controller).delegate = self;
            break;
        case EDITCELL_DATE:
        case EDITCELL_COMBOBOX:
        case EDITCELL_COMBOBOX_WITH_SERVICE:
            controller = [UIButton buttonWithType:UIButtonTypeCustom];
            ((UIButton *)controller).frame = CGRectMake(labelWidth+10, 3, ScreenWidth-labelWidth-15, 33);
            ((UIButton *)controller).titleLabel.font = [UIFont systemFontOfSize:14];
            [((UIButton *)controller) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            ((UIButton *)controller).contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            ((UIButton *)controller).backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
            [((UIButton *)controller) setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"arrow_right_normal.png"] scaleToSize:CGSizeMake(15,15)] forState:UIControlStateNormal];
            ((UIButton *)controller).imageEdgeInsets = UIEdgeInsetsMake(0, ScreenWidth-labelWidth-30, 0,5);
            ((UIButton *)controller).titleEdgeInsets = UIEdgeInsetsMake(0, -12,0,20);
            ((UIButton *)controller).layer.borderWidth = 0.5;
            ((UIButton *)controller).layer.borderColor = [UIColor grayColor].CGColor;
            [((UIButton *)controller) addTarget:self action:@selector(buttonOnClick) forControlEvents:(UIControlEventTouchUpInside)];
            break;
        case EDITCELL_WITCH_CON:
            controller = [[CustomSwitch alloc]initWithFrame:CGRectMake(labelWidth+10, 3, 100, 33)];
            ((CustomSwitch *)controller).delegate = self;
            break;
        case EDITCELL_INPUT_COMBOBOX:
            controller = [[UIView alloc]initWithFrame:CGRectMake(labelWidth+10, 3, ScreenWidth-labelWidth-15, 33)];
            UITextField *leftView = [[UITextField alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth-labelWidth-15-32 , 33)];
            leftView.font = [UIFont systemFontOfSize:14];
            leftView.textAlignment = NSTextAlignmentLeft;
            leftView.tag = 100;
            leftView.layer.borderColor = [UIColor grayColor].CGColor;
            leftView.layer.borderWidth = 0.5;
            leftView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            leftView.delegate = self;
            [((UIView *)controller) addSubview:leftView];
            
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            rightView.frame = CGRectMake(leftView.right-1, 0, 33, 33);
            rightView.layer.borderColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1].CGColor;
            rightView.layer.borderWidth = 0.5;
            [rightView setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"arrow_right_normal.png"] scaleToSize:CGSizeMake(15,15)] forState:UIControlStateNormal];
            rightView.tag = 101;
            [rightView addTarget:self action:@selector(buttonOnClick) forControlEvents:(UIControlEventTouchUpInside)];
            [((UIView *)controller) addSubview:rightView];
            
            //            UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(rightView.left, 0, 1, 33)];
            //            verticalLine.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
            //            [((UIView *)controller) addSubview:verticalLine];
            break;
    }
    return controller;
}
//如果是switch类型的控件，自定义皮肤
-(void)setSwitchOnImage:(UIImage *)onImageP
               offImage:(UIImage *)offImageP {
    onImage = onImageP;
    offImage = offImageP;
}


//
-(void)buttonOnClick {
    if( _selfBlock ) {
        _selfBlock(currentValueDic);
    }
    //
    else {
        
        //如果是日期控件，弹出日期
        if(cellType == EDITCELL_DATE ) {
            //            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"
            //                                                                     delegate:self
            //                                                            cancelButtonTitle:nil
            //                                                       destructiveButtonTitle:nil
            //                                                            otherButtonTitles:@"请选择日期", nil];
            //            [actionsheet showInView:self.superview];
            //            UIDatePicker *datepicker = [[UIDatePicker alloc] init];
            //            datepicker.tag = 101;
            //            datepicker.datePickerMode = UIDatePickerModeDate;
            //            [actionsheet addSubview:datepicker];
            CGRect frame = CGRectMake(0, 0, ScreenWidth, 260);
            YXPActionSheet *actionsheet = [YXPActionSheet actionSheetWithFrame: frame CancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
            [actionsheet showInWindow];
            actionsheet.delegate = self;
            UIDatePicker *datepicker = [[UIDatePicker alloc] init];
            datepicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            NSDate *currentTime = [NSDate date];
            NSDate *earlerTime = [PowerUtils getLastYearay:@"yyyy-MM-dd"];
            //设定时间格式,这里可以设置成自己需要的格式
            datepicker.maximumDate = currentTime;
            datepicker.minimumDate = earlerTime;
            datepicker.tag = 101;
            datepicker.backgroundColor = [UIColor clearColor];
            datepicker.datePickerMode = UIDatePickerModeDate;
            [actionsheet addSubview:datepicker];
            
            if(_delegate && [_delegate respondsToSelector:@selector(popDatePickerActionSheet)]){
                [_delegate popDatePickerActionSheet];
            }
            
        }else {
            CommonPropertyModelViewController *propertyCtrl = [[CommonPropertyModelViewController alloc]init];
            propertyCtrl.delegate = self;
            propertyCtrl.titleStr = title;
            propertyCtrl.dataList = _enumDataSource;
            propertyCtrl.selectDic = currentValueDic;
            propertyCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:propertyCtrl animated:YES completion:nil];
//            
//            if(_delegate && [_delegate respondsToSelector:@selector(popDatePickerActionSheet)]){
//                [_delegate popDatePickerActionSheet];
//            }
        }
    }
}

#pragma mark ----comonProperty delegate
-(void)submitHandler:(NSMutableDictionary *)dic {
    currentValueDic = dic;
    [self setMainControllerValue];
    if(![[currentValueDic objectForKey:@"value"]isEqualToString:[oriValueDic objectForKey:@"value"]]) {
        self.isEdited = YES;
    }else {
        self.isEdited = NO;
    }
    
    if(_setValueBlock!=nil) {
        _setValueBlock(currentValueDic);
    }
}

#pragma mark ----textfield delegate
-(void)filterCellTextDidChange:(NSNotification *)notification {
    //设置当前值
    id controller = notification.object;
    if([mainController isEqual:controller]) {
        if(cellType == EDITCELL_INPUT || cellType == EDITCELL_INPUT_NUM ) {
            NSString *text = ((UITextField *)controller).text;
            [currentValueDic setValue:text forKey:@"value"];
            if(![text isEqualToString:[oriValueDic objectForKey:@"value"]]) {
                self.isEdited = YES;
            }else {
                self.isEdited = NO;
            }
        }
    }else {
        if(cellType == EDITCELL_INPUT_COMBOBOX) {
            UITextField *localField = (UITextField *)[((UIView *)mainController) viewWithTag:100];
            if([localField isEqual:controller] ) {
                [currentValueDic setValue:((UITextField *)controller).text forKey:@"value"];
                if(![((UITextField *)controller).text isEqualToString:[oriValueDic objectForKey:@"value"]]) {
                    self.isEdited = YES;
                }else {
                    self.isEdited = NO;
                }
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //设置当前值
    [currentValueDic setValue:textField.text forKey:@"value"];
    if(![textField.text isEqualToString:[oriValueDic objectForKey:@"value"]]) {
        self.isEdited = YES;
    }else {
        self.isEdited = NO;
    }
}

#pragma mark ----customswitch delegate
-(void)switchOnChange:(id)sender {
    BOOL switchValue = ((CustomSwitch *)sender).on;
    //设置当前值
    if(switchValue == YES ) {
        [currentValueDic setValue:@"1" forKey:@"value"];
    }else {
        [currentValueDic setValue:@"0" forKey:@"value"];
    }
    if([[oriValueDic objectForKey:@"value"] isEqualToString:@"0"]) {
        if(switchValue != NO )
            self.isEdited = YES;
        else
            self.isEdited = NO;
    }else {
        if(switchValue != YES )
            self.isEdited = YES;
        else
            self.isEdited = NO;
    }
}

#pragma mark - UIActionSheet delegate
//-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
//    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
//    formattor.dateFormat = @"yyyy-MM-dd";
//    NSString *timestamp = [formattor stringFromDate:datePicker.date];
//    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
//    [dic setValue:timestamp forKey:@"name"];
//    [dic setValue:timestamp forKey:@"value"];
//    [self submitHandler:dic];
//
//}
- (void)actionSheet:(YXPActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex buttonTitle:(NSString *)titleStr {
    if([titleStr isEqualToString:@"确定"]) {
        UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
        NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
        formattor.dateFormat = @"yyyy-MM-dd";
        NSString *timestamp = [formattor stringFromDate:datePicker.date];
        
        NSDateFormatter *formattor2 = [[NSDateFormatter alloc] init];
        formattor2.dateFormat = @"yyyy-MM-dd-HH:mm:ss";
        NSString *timestamp2 = [formattor2 stringFromDate:datePicker.date];
        
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
        [dic setValue:timestamp forKey:@"name"];
        [dic setValue:timestamp2 forKey:@"value"];
        [self submitHandler:dic];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)setCurrentDic:(NSDictionary *)dic {
    [self submitHandler:dic];
}
-(NSDictionary *)getCurrentDic {
    return currentValueDic;
}

-(BOOL)validateReqiured {
    BOOL isValidated = YES;
    if(isRequired==YES) {
        if([currentValueDic objectForKey:@"value"]==nil || [[currentValueDic objectForKey:@"value"] isEqualToString:@""]) {
            isValidated = NO;
        }
    }
    return isValidated;
}

-(NSString *)getInvalidaString {
    NSString *str = [NSString stringWithFormat:@"%@不能为空!",title];
    return str;
}

-(void)setTitleLabelWidth:(float)width {
    labelWidth = width;
    [self setNeedsLayout];
}

//用指定的数据源弹出选择属性窗口
-(void)popWindowWithDataSource:(NSArray *)dataSource {
    CommonPropertyModelViewController *propertyCtrl = [[CommonPropertyModelViewController alloc]init];
    propertyCtrl.delegate = self;
    propertyCtrl.titleStr = title;
    propertyCtrl.dataList = dataSource;
    propertyCtrl.selectDic = currentValueDic;
    propertyCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:propertyCtrl animated:YES completion:nil];
}

//如果是时间类型，获取时间类型的值
-(NSDate *)getCurrentDicWithDate {
    if(cellType == EDITCELL_DATE ) {
        NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
        formattor.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [currentValueDic objectForKey:@"name"];
        NSDate *date = [formattor dateFromString:dateStr];
        return date;
    }
    return nil;
}

//设置后面的符号
-(void)setTailString:(NSString *)tail{
    tailStr = tail;
    [self setNeedsLayout];
}

@end
