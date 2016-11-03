//
//  ResourcesCheckViewController.m
//  i动力
//
//  Created by Bonnie on 16/10/28.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "ResourcesCheckViewController.h"
#import "SearchJuZhanViewController.h"
#define kCellHeight_kind1    60
#define kCellHeight_kind2    140
#define kCellHeight_kind3    100
#define kControlWidth        180
@interface ResourcesCheckViewController () <UITableViewDelegate , UITableViewDataSource , UITextViewDelegate , UIPickerViewDelegate ,UIPickerViewDataSource>
{
    UIView *_choosePickView;
    UIView *_chooseDateView;
    NSString *_choosePickString;
    UIButton *_submitBtn;
}
@property (nonatomic, weak) UITableView *foldingTableView;
@property (nonatomic, strong)UIPickerView * pickerView;//自定义pickerview
@property (nonatomic, strong)NSMutableArray *pickerDataArray;
@property (nonatomic, strong)UIDatePicker *datePicker;

@end

@implementation ResourcesCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.navTitle;
    
    //设置navigationbar左按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backActionToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=backBarBtn;
    // 创建tableView
    [self setupFoldingTableView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Hide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    _pickerDataArray = [[NSMutableArray alloc] init];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"*标题", @"*工单内容",@"*系统情况",@"*现场情况",@"*变更类型",@"难度等级",@"*紧急程度",@"*工单来源",@"技能要求",@"需要人数",@"*局站",@"*接收人",@"*错误类别",@"细化任务",@"*计划开始时间",nil];
    [_pickerDataArray setArray:titleArr];
    
    
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 64  - 60, kScreenWidth - 40, 40)];
    [_submitBtn setBackgroundColor:kColor_blue];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_submitBtn];
    [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initPickView];
    [self initDateView];

}

-(void)submitBtnClick:(UIButton *)sender
{
    NSLog(@"提交");
}

-(void)Hide:(UITapGestureRecognizer*)tap
{
    [_chooseDateView setHidden:YES];
    [_choosePickView setHidden:YES];
}

-(void)initDateView
{
    _chooseDateView =[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 -244 , self.view.bounds.size.width, 244)];
    [_chooseDateView setBackgroundColor:[UIColor whiteColor]];
    _chooseDateView.layer.borderWidth = 1.0f;
    _chooseDateView.layer.borderColor = kColor_GrayLight.CGColor;
    [self.view addSubview:_chooseDateView];
    [self.view bringSubviewToFront:_chooseDateView];
    [_chooseDateView setHidden:YES];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
    [line setBackgroundColor:kColor_GrayLight];
    [_chooseDateView addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(kScreenWidth-60, 0, 60, 44)];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:kColor_blue forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_chooseDateView addSubview:btn];
    
    
    self.datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0, 44 , self.view.bounds.size.width, 200)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.locale = locale;
    [self.datePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    [_chooseDateView addSubview:self.datePicker];
    [_chooseDateView bringSubviewToFront:self.datePicker];
    [_chooseDateView setHidden:YES];
    
}

-(void)initPickView
{
    _choosePickView =[[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 -244 , self.view.bounds.size.width, 244)];
    [_choosePickView setBackgroundColor:[UIColor whiteColor]];
    _choosePickView.layer.borderWidth = 1.0f;
    _choosePickView.layer.borderColor = kColor_GrayLight.CGColor;
    [self.view addSubview:_choosePickView];
    [self.view bringSubviewToFront:_choosePickView];
    [_choosePickView setHidden:YES];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
    [line setBackgroundColor:kColor_GrayLight];
    [_choosePickView addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(kScreenWidth-60, 0, 60, 44)];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:kColor_blue forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_choosePickView addSubview:btn];
    
    // 初始化pickerView
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 200)];
    //    self.pickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [_choosePickView addSubview:self.pickerView];
    
    
    //指定数据源和委托
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
}


-(void)doneBtnClick:(UIButton *)sender
{
    [_choosePickView setHidden:YES];
    [_chooseDateView setHidden:YES];
}

-(void)backActionToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 创建tableView
- (void)setupFoldingTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *foldingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 -80)];
    _foldingTableView = foldingTableView;
    [_foldingTableView setBackgroundColor:kColor_GrayLight];
    [self.view addSubview:foldingTableView];
    foldingTableView.delegate = self;
    foldingTableView.dataSource = self;
    foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5) {
        return kCellHeight_kind2;
    }else
        return kCellHeight_kind1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = NULL;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,20, 100, 12)];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:kSystemFont(12)];
        [label setTag:100 + indexPath.row];
        [label setText:NSTextAlignmentLeft];
        [cell.contentView addSubview:label];
        
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5) {
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - kControlWidth, 10, kControlWidth, kCellHeight_kind2 - 20)];
            [textView setDelegate:self];
            textView.layer.cornerRadius = 2.0f;
            textView.layer.borderColor = kColor_blue.CGColor;
            textView.layer.borderWidth = 2.0f;
            [cell.contentView addSubview:textView];
            [textView setTag:200 + indexPath.row];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight_kind2 - 1, kScreenWidth, 1)];
            [line setBackgroundColor:kColor_GrayLight];
            [cell.contentView addSubview:line];
            
            if (indexPath.row == 3) {
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(kControlWidth - 24, (textView.frame.size.height - 24)/2, 24, 24)];

                [imgV setImage:[UIImage imageNamed:@"arrow_down"]];
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kControlWidth - 24 - 1, 0, 1, kCellHeight_kind2)];
                [lineView setBackgroundColor:kColor_GrayLight];
                [textView addSubview:lineView];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(textView.frame.size.width - 25, 0, 25, kCellHeight_kind2)];
                btn.layer.cornerRadius = 2.0f;
                btn.layer.borderColor = kColor_GrayLight.CGColor;
                btn.layer.borderWidth = 2.0f;
                [btn.titleLabel setFont:kSystemFont(13.0f)];
                [cell.contentView addSubview:btn];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTag:300 + indexPath.row];
                [btn addTarget:self action:@selector(searchJuzhan:) forControlEvents:UIControlEventTouchUpInside];
                
                
            }
            
            
        }else{
            if (indexPath.row == 0 ) {
                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - kControlWidth, 10, indexPath.row == 9?100:kControlWidth, kCellHeight_kind1 - 20)];
                [textView setDelegate:self];
                textView.layer.cornerRadius = 2.0f;
                textView.layer.borderColor = kColor_blue.CGColor;
                textView.layer.borderWidth = 2.0f;
                [cell.contentView addSubview:textView];
                [textView setTag:200 + indexPath.row];
                
            }else
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(kScreenWidth - 10 - kControlWidth, 10, kControlWidth, kCellHeight_kind1 - 20)];
                btn.layer.cornerRadius = 2.0f;
                btn.layer.borderColor = kColor_GrayLight.CGColor;
                btn.layer.borderWidth = 2.0f;
                [btn.titleLabel setFont:kSystemFont(13.0f)];
                [cell.contentView addSubview:btn];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTag:300 + indexPath.row];
                [btn addTarget:self action:@selector(downMenuClick:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(kControlWidth - 24, (btn.frame.size.height - 24)/2, 24, 24)];
                if (indexPath.row == 6 || indexPath.row == 7) {
                    [imgV setImage:[UIImage imageNamed:@"Arrow"]];
                }else{
                    [imgV setImage:[UIImage imageNamed:@"arrow_down"]];
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kControlWidth - 24 - 1, 2, 1, btn.frame.size.height - 4)];
                    [lineView setBackgroundColor:kColor_GrayLight];
                    [btn addSubview:lineView];
                    
                }
                [btn addSubview:imgV];
                
                
            }
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight_kind1 - 1, kScreenWidth, 1)];
            [line setBackgroundColor:kColor_GrayLight];
            [cell.contentView addSubview:line];
        }
        
    }
    NSArray *titleArr = [NSArray arrayWithObjects:@"*标题", @"*巡检内容",@"*巡检站点",@"难度等级",@"*接收人",@"备注",@"计划开始时间：",@"计划结束时间：",nil];
    
    NSString *titleStr = [titleArr objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100+indexPath.row];
    [label setText:titleStr];
    
    if ([titleStr hasPrefix:@"*"]) {
        [label setTextColor:kColor_Red];
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)searchJuzhan:(UIButton *)sender
{
    SearchJuZhanViewController *vc = [[SearchJuZhanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)downMenuClick:(UIButton *)sender
{
    UITableViewCell *cell = (UITableViewCell *)[_foldingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 300 inSection:0]];
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:sender.tag - 200];
    NSLog(@"下拉按钮====%@",lab.text);
    [self.pickerView setTag:sender.tag+1000];
    if (sender.tag == 300+6 || sender.tag == 300+7) {
        _chooseDateView.hidden = !_chooseDateView.hidden;
        
    }else{
        _choosePickView.hidden = !_choosePickView.hidden;
    }
}

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;//第一个展示字母、第二个展示数字
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.pickerDataArray.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [pickerLabel setTextColor:kColor_blue];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickerDataArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITableViewCell *cell = (UITableViewCell *)[_foldingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:pickerView.tag-1000-300 inSection:0]];
    UIButton *btn= (UIButton *)[cell.contentView viewWithTag:pickerView.tag-1000];
    [btn setTitle:_pickerDataArray[row] forState:UIControlStateNormal];
}

#pragma mark - 实现oneDatePicker的监听方法

- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    
    
    
    NSDate *select = [sender date]; // 获取被选中的时间
    
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    
    selectDateFormatter.dateFormat = @"yy-MM-dd"; // 设置时间和日期的格式
    
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
    
    UITableViewCell *cell = (UITableViewCell *)[_foldingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:14 inSection:0]];
    UIButton *btn= (UIButton *)[cell.contentView viewWithTag:314];
    [btn setTitle:dateAndTime forState:UIControlStateNormal];
    
    
    
    // 在控制台打印消息
    
    NSLog(@"%@", [sender date]);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
