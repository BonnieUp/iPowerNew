//
//  EditPropertyCell.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "EditPropertyCell.h"

@implementation EditPropertyCell {
    //控件类型
    EditCellTypeEnum cellType;
    //控件显示名称
    NSString *title;
    //控件的原始值(字典)
    NSMutableDictionary *oriValueDic;
    //控件的当前值(字典)
    NSMutableDictionary *currentValueDic;
    //是否必填
    BOOL isRequired;
    float labelWidth;
    //----view
    //icon
    UIButton *iconBtn;
    //显示名称的label
    UILabel *titleLabel;
    //是否必填的标志
    UILabel *isNeedLabel;
    //主控件，有枚举的类型
    id mainController;
    
    
    //skin
    UIImage *onImage;
    UIImage *offImage;
    
    //最大值最小值
    int minValue;
    int maxValue;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cellTextDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame required:(BOOL)required labelTitle:(NSString *)labelTitle oriValue:(NSDictionary *)oriValue type:(EditCellTypeEnum)type{
    //大小是固定的
    self = [self initWithFrame:frame];
    if(self) {
        cellType = type;
        title = labelTitle;
        currentValueDic = [NSMutableDictionary dictionaryWithDictionary:oriValue];
        oriValueDic = [NSMutableDictionary dictionaryWithDictionary:oriValue];;
        isRequired = required;
        _isEdited = NO;
        labelWidth = 90.0f;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //添加icon
    iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(0, 0, 30, 39);
    [iconBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"ic_edited.png"] scaleToSize:CGSizeMake(20,20)] forState:UIControlStateNormal];
    [iconBtn setBackgroundColor:[UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1]];
    [self addSubview:iconBtn];
    
    //竖线
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(30, 0, 1, self.height)];
    verticalLine.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
    [self addSubview:verticalLine];
    
    //显示名称的label
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(41, 0, labelWidth-5, 39)];
    titleLabel.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    
    //是否必填
    isNeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, 0, 10,39)];
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
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 39, self.width, 1)];
    horizontalLine.backgroundColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1];
    [self addSubview:horizontalLine];
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
            if([[currentValueDic objectForKey:@"value"] isEqualToString:@"0"]) {
                ((CustomSwitch *)mainController).on = NO;
            }else {
                ((CustomSwitch *)mainController).on = YES;
            }
            break;
        case EDIT_PROPERTY_CELL_NUMBERIC:
            if([mainController respondsToSelector:@selector(viewWithTag:)]) {
                UITextField *inputView = (UITextField *)[mainController viewWithTag:101];
                inputView.text = [currentValueDic objectForKey:@"name"];
                [self numbericValidate];
            }
        default:
            break;
    }
}

//根据类型创建控件
-(id)createControllWithType:(EditCellTypeEnum )type {
    id controller;
    switch (type) {
            //label
        case EDITCELL_LABEL:
            controller = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+40, 3, ScreenWidth-labelWidth-43, 33)];
            ((UILabel *)controller).font = [UIFont systemFontOfSize:14];
            ((UILabel *)controller).textAlignment = NSTextAlignmentLeft;
            break;
            //input
        case EDITCELL_INPUT:
            controller = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+40, 3, ScreenWidth-labelWidth-43, 33)];
            ((UITextField *)controller).font = [UIFont systemFontOfSize:14];
            ((UITextField *)controller).contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            ((UITextField *)controller).textAlignment = NSTextAlignmentLeft;
            ((UITextField *)controller).layer.borderWidth = 0.5;
            ((UITextField *)controller).layer.borderColor = [UIColor grayColor].CGColor;
            ((UITextField *)controller).delegate = self;
            break;
            //input with num
        case EDITCELL_INPUT_NUM:
            controller = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+40, 3, ScreenWidth-labelWidth-43, 33)];
            ((UITextField *)controller).font = [UIFont systemFontOfSize:14];
            ((UITextField *)controller).contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            ((UITextField *)controller).textAlignment = NSTextAlignmentLeft;
            ((UITextField *)controller).keyboardType = UIKeyboardTypeNumberPad;
            ((UITextField *)controller).layer.borderWidth = 0.5;
            ((UITextField *)controller).layer.borderColor = [UIColor grayColor].CGColor;
            ((UITextField *)controller).delegate = self;
            break;
        case EDITCELL_DATE:
        case EDITCELL_COMBOBOX:
        case EDITCELL_COMBOBOX_WITH_SERVICE:
            controller = [UIButton buttonWithType:UIButtonTypeCustom];
            ((UIButton *)controller).frame = CGRectMake(labelWidth+40, 3, ScreenWidth-labelWidth-43, 33);
            ((UIButton *)controller).titleLabel.font = [UIFont systemFontOfSize:14];
            [((UIButton *)controller) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            ((UIButton *)controller).contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            ((UIButton *)controller).backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
            [((UIButton *)controller) setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"arrow_right_normal.png"] scaleToSize:CGSizeMake(15,15)] forState:UIControlStateNormal];
            ((UIButton *)controller).imageEdgeInsets = UIEdgeInsetsMake(0, ScreenWidth-labelWidth-43-20, 0,5);
            ((UIButton *)controller).titleEdgeInsets = UIEdgeInsetsMake(0, -12,0,20);
            ((UIButton *)controller).layer.borderWidth = 0.5;
            ((UIButton *)controller).layer.borderColor = [UIColor grayColor].CGColor;
            [((UIButton *)controller) addTarget:self action:@selector(buttonOnClick) forControlEvents:(UIControlEventTouchUpInside)];
            break;
        case EDITCELL_WITCH_CON:
            controller = [[CustomSwitch alloc]initWithFrame:CGRectMake(labelWidth+40, 3, 100, 33)];
            ((CustomSwitch *)controller).delegate = self;
            break;
        case EDIT_PROPERTY_CELL_NUMBERIC:
        {
            controller = [[UIView alloc]initWithFrame:CGRectMake(labelWidth+40, 3, ScreenWidth-labelWidth-43, 33)];
            UIButton *plusBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3, 35, 25)];
            [plusBtn addTarget:self action:@selector(plusBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
            //            [plusBtn setBackgroundImage:[PowerUtils OriginImage:[UIImage imageNamed:@"plus.png"] scaleToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
            [plusBtn setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:107/255.0 green:173/255.0 blue:246/255.0 alpha:1] size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
            [plusBtn setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1] size:CGSizeMake(25, 25)] forState:UIControlStateDisabled];
            [plusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            plusBtn.tag = 100;
            [plusBtn setTitle:@" + " forState:UIControlStateNormal];
            [((UIView *)controller) addSubview:plusBtn];
            
            UITextField *inputView = [[UITextField alloc]initWithFrame:CGRectMake(plusBtn.right+5,3, ScreenWidth-labelWidth-43-80,25)];
            inputView.tag  = 101;
            [inputView setKeyboardType:UIKeyboardTypeNumberPad];
            inputView.textAlignment = NSTextAlignmentLeft;
            inputView.layer.borderColor = [UIColor grayColor].CGColor;
            inputView.layer.borderWidth = 0.5;
            inputView.font = [UIFont systemFontOfSize:11];
            inputView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            inputView.delegate = self;
            [((UIView *)controller) addSubview:inputView];
            
            UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(inputView.right+5, 3, 35, 25)];
            [reduceBtn addTarget:self action:@selector(reduceBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
            //            [reduceBtn setBackgroundImage:[PowerUtils OriginImage:[UIImage imageNamed:@"reduce.png"] scaleToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
            [reduceBtn setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:107/255.0 green:173/255.0 blue:246/255.0 alpha:1] size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
            [reduceBtn setBackgroundImage:[PowerUtils createImageWithColor:[UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1] size:CGSizeMake(25, 25)] forState:UIControlStateDisabled];
            reduceBtn.tag = 102;
            [reduceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [reduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [reduceBtn setTitle:@" - " forState:UIControlStateNormal];
            [((UIView *)controller) addSubview:reduceBtn];
            break;
        }
        case EDITCELL_INPUT_COMBOBOX:
            controller = [[UIView alloc]initWithFrame:CGRectMake(labelWidth+40, 3, ScreenWidth-labelWidth-43, 33)];
            UITextField *leftView = [[UITextField alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth-labelWidth-43-32 , 33)];
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

-(void)setIsEdited:(BOOL)isEdited {
    _isEdited = isEdited;
    if(_isEdited == YES ) {
        [iconBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"ic_error.png"] scaleToSize:CGSizeMake(20,20)] forState:UIControlStateNormal];
    }else {
        [iconBtn setImage:[PowerUtils OriginImage:[UIImage imageNamed:@"ic_edited.png"] scaleToSize:CGSizeMake(20,20)] forState:UIControlStateNormal];
    }
}

-(void)plusBtnOnClick{
    UITextField *localField = (UITextField *)[((UIView *)mainController) viewWithTag:101];
    NSString *str = localField.text;
    localField.text = [NSString stringWithFormat:@"%i",[str intValue]+1];
    [self numbericValidate];
    [self textFieldDidEndEditing:localField];
}

-(void)reduceBtnOnClick{
    UITextField *localField = (UITextField *)[((UIView *)mainController) viewWithTag:101];
    NSString *str = localField.text;
    localField.text = [NSString stringWithFormat:@"%i",[str intValue]-1];
    [self numbericValidate];
    [self textFieldDidEndEditing:localField];
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
            
            datepicker.tag = 101;
            datepicker.backgroundColor = [UIColor clearColor];
            datepicker.datePickerMode = UIDatePickerModeDate;
            [actionsheet addSubview:datepicker];
            
        }else {
            CommonPropertyModelViewController *propertyCtrl = [[CommonPropertyModelViewController alloc]init];
            propertyCtrl.delegate = self;
            propertyCtrl.titleStr = title;
            propertyCtrl.dataList = _enumDataSource;
            propertyCtrl.selectDic = currentValueDic;
            propertyCtrl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:propertyCtrl animated:YES completion:nil];
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
-(void)cellTextDidChange:(NSNotification *)notification {
    //设置当前值
    id controller = notification.object;
    if([mainController isEqual:controller]) {
        if(cellType == EDITCELL_INPUT || cellType == EDITCELL_INPUT_NUM ) {
            NSString *text = ((UITextField *)controller).text;
            [currentValueDic setValue:@"" forKey:@"name"];
            if (text.length>0) {
                [currentValueDic setValue:@"" forKey:@"name"];

                [currentValueDic setValue:text forKey:@"value"];

            }
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
        //数字控件
        if(cellType == EDIT_PROPERTY_CELL_NUMBERIC ){
            UITextField *localField = (UITextField *)[((UIView *)mainController) viewWithTag:101];
            if([localField isEqual:controller] ) {
                NSString *str = ((UITextField *)controller).text;
                if(str.length>1 && [[str substringToIndex:1] isEqualToString:@"0"]){
                    NSTimeInterval interval = 2;
                    [PowerUtils showMessage:[NSString stringWithFormat:@"%@必须是非0开始的数字",title] duration:interval];
                    return;
                }
                if(str.length==0){
                    ((UITextField *)controller).placeholder = [NSString stringWithFormat:@"大于等于%i小于等于%i",minValue,maxValue];;
                }
                [self numbericValidate];
            }
        }
        if(cellType == EDIT_PROPERTY_CELL_COMBOBOX ){
            UITextField *localField = (UITextField *)[((UIView *)mainController) viewWithTag:101];

            

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

#pragma mark - method of UIActionSheet
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
        if(_dateFormatString==nil){
            formattor.dateFormat = @"yyyy-MM-dd";
        }else{
            formattor.dateFormat = _dateFormatString;
        }
        
        NSString *timestamp = [formattor stringFromDate:datePicker.date];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
        [dic setValue:timestamp forKey:@"name"];
        [dic setValue:timestamp forKey:@"value"];
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

-(void)numbericValidate{
    UITextField *localField = (UITextField *)[((UIView *)mainController) viewWithTag:101];
    UIButton *plusBtn = (UIButton *)[((UIView *)mainController) viewWithTag:100];
    UIButton *reduceBtn = (UIButton *)[((UIView *)mainController) viewWithTag:102];
    NSString *str = localField.text;
    if([str intValue]==minValue){
        [reduceBtn setEnabled:NO];
    }else if([str intValue]>minValue){
        [reduceBtn setEnabled:YES];
    }
    if([str intValue]==maxValue){
        [plusBtn setEnabled:NO];
    }else if([str intValue]<maxValue){
        [plusBtn setEnabled:YES];
    }
    if([str intValue]<minValue){
        [PowerUtils showMessage:[NSString stringWithFormat:@"%@必须大于等于%i",title,minValue] duration:2];
        localField.text = [NSString stringWithFormat:@"%i",minValue];
    }else if([str intValue]>maxValue){
        [PowerUtils showMessage:[NSString stringWithFormat:@"%@必须小于等于%i",title,maxValue] duration:2];
        localField.text = [NSString stringWithFormat:@"%i",maxValue];
    }
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

//数字控件会用到最大值最小值
-(void)setNumbericMin:(int)min Max:(int)max{
    if(cellType == EDIT_PROPERTY_CELL_NUMBERIC){
        minValue = min;
        maxValue = max;
        if([mainController respondsToSelector:@selector(viewWithTag:)]) {
            UITextField *inputView = (UITextField *)[mainController viewWithTag:101];
            inputView.placeholder = [NSString stringWithFormat:@"大于等于%i小于等于%i",min,max];
        }
        
    }
}
@end
