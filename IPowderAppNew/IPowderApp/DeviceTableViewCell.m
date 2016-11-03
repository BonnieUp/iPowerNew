//
//  DeviceTableViewCell.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-5.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "CustomSwitch.h"

@implementation DeviceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //设备名称label
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5,230, 30)];
    nameLabel.numberOfLines = 3;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.tag = 100;
    [self.contentView addSubview:nameLabel];
    
    //设备类型label
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, nameLabel.bottom, 230, 30)];
    typeLabel.numberOfLines = 3;
    typeLabel.font = [UIFont systemFontOfSize:13];
    typeLabel.tag = 101;
    [self.contentView addSubview:typeLabel];
    
    //所属房间label
    UILabel *roomLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, typeLabel.bottom, 230, 30)];
    roomLabel.numberOfLines = 3;
    roomLabel.font = [UIFont systemFontOfSize:13];
    roomLabel.tag = 102;
    [self.contentView addSubview:roomLabel];
    
    //资产编号label
    UILabel *zichanLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, roomLabel.bottom, 230, 30)];
    zichanLabel.numberOfLines = 3;
    zichanLabel.font = [UIFont systemFontOfSize:13];
    zichanLabel.tag = 103;
    [self.contentView addSubview:zichanLabel];
    
    //实物编号label
    UILabel *shiwuLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, zichanLabel.bottom, 230, 30)];
    shiwuLabel.numberOfLines = 3;
    shiwuLabel.font = [UIFont systemFontOfSize:13];
    shiwuLabel.tag = 104;
    [self.contentView addSubview:shiwuLabel];
    
    //投产日期label
    UILabel *touchanLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, shiwuLabel.bottom, 190, 30)];
    touchanLabel.numberOfLines = 3;
    touchanLabel.font = [UIFont systemFontOfSize:13];
    touchanLabel.tag = 105;
    [self.contentView addSubview:touchanLabel];
    
    //是否选中btn
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(5,15, 30,30 );
    selectBtn.tag = 106;
    [self.contentView addSubview:selectBtn];
    
    
    //添加分割线
    UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
    seperateView.tag  = 200;
    seperateView.alpha = 0.8;
    seperateView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:seperateView];
    
    //查看模式或者编辑模式
    CustomSwitch *modeSwitch = [[CustomSwitch alloc]initWithFrame:CGRectMake(ScreenWidth-130, seperateView.bottom-35, 100, 30)];
    [modeSwitch setSwitchOnImage:[UIImage imageNamed:@"btn_switcher_on_read.png"] offImage:[UIImage imageNamed:@"btn_switcher_off_read.png"]];
    [modeSwitch setTag:109];
    [modeSwitch addTarget:self action:@selector(modeSwitchOnChangeHandler:) forControlEvents:UIControlEventTouchUpInside];
    if([[_dic objectForKey:@"canEdit"] isEqualToString:@"YES"]){
        [modeSwitch setOn:YES];
    }else{
        [modeSwitch setOn:NO];
    }
    [self.contentView addSubview:modeSwitch];
    
    //设置名称
    nameLabel.text = [_dic objectForKey:@"DEV_NAME"];
    
    //设备类型label
    typeLabel.text = [_dic objectForKey:@"DEV_TYPE_NAME"];
    
    //所属房间
    roomLabel.text = [NSString stringWithFormat:@"所属房间:%@",[_dic objectForKey:@"ROOM_NAME"]];
    
    //资产编号
    zichanLabel.text = [NSString stringWithFormat:@"资产编号:%@",[_dic objectForKey:@"ASSETS_NUM"]];
    
    //实物编号
    shiwuLabel.text = [NSString stringWithFormat:@"实物编号:%@",[_dic objectForKey:@"ARTICLE_NUM"]];
    
    //投产日期
    touchanLabel.text = [NSString stringWithFormat:@"投产日期:%@",[_dic objectForKey:@"START_USE_DATE"]];
    
    //设置checkbox样式
    if([[_dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_on_normal.png"] forState:UIControlStateNormal];
    }
    else {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_check_off_disable.png"] forState:UIControlStateNormal];
    }
    [selectBtn addTarget:self action:@selector(onSelectChangeHandler) forControlEvents:UIControlEventTouchUpInside];
    
    //是否显示checkbox
    if([[_dic objectForKey:@"enabled"] isEqualToString:@"YES"]) {
        [selectBtn setHidden:NO];
    }else {
        [selectBtn setHidden:YES];
    }
    
    //如果没有数据，隐藏分割线
    if(_dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    //重置位置
    CGSize nameSize = [PowerUtils getLabelSizeWithText:nameLabel.text width:230 font:[UIFont systemFontOfSize:15]];
    nameLabel.frame = CGRectMake(40, 5, 230, nameSize.height);
    
    CGSize typeSize = [PowerUtils getLabelSizeWithText:typeLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    typeLabel.frame = CGRectMake(40,nameLabel.bottom, 230, typeSize.height);
    
    CGSize roomSize = [PowerUtils getLabelSizeWithText:roomLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    roomLabel.frame = CGRectMake(40,typeLabel.bottom, 230, roomSize.height);
    
    CGSize zichanSize = [PowerUtils getLabelSizeWithText:zichanLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    zichanLabel.frame = CGRectMake(40,roomLabel.bottom, 230, zichanSize.height);
    
    CGSize shiwuSize = [PowerUtils getLabelSizeWithText:shiwuLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    shiwuLabel.frame = CGRectMake(40,zichanLabel.bottom, 230, shiwuSize.height);
    
    CGSize touchanSize = [PowerUtils getLabelSizeWithText:touchanLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    touchanLabel.frame = CGRectMake(40, shiwuLabel.bottom, 230,touchanSize.height);
    
    seperateView.frame = CGRectMake(0, touchanLabel.bottom+4, ScreenWidth, 0.5);
    modeSwitch.frame = CGRectMake(ScreenWidth-130, seperateView.bottom-35, 100, 30);
    selectBtn.frame = CGRectMake(5, (seperateView.bottom-30)/2, 30, 30);
}

-(void)modeSwitchOnChangeHandler:(CustomSwitch *)sender{
    if(sender.on == YES){
        [_dic setValue:@"YES" forKey:@"canEdit"];
    }else{
        [_dic setValue:@"NO" forKey:@"canEdit"];
        [_dic setValue:@"NO" forKey:@"selected"];
        [self setNeedsLayout];
    }
}

+(float)caculateCellHeight:(NSDictionary *)deviceDic {
    float hei=10;
    CGSize nameSize = [PowerUtils getLabelSizeWithText:[deviceDic objectForKey:@"DEV_NAME"] width:230 font:[UIFont systemFontOfSize:15]];
    hei+=nameSize.height;
    
    CGSize typeSize = [PowerUtils getLabelSizeWithText:[deviceDic objectForKey:@"DEV_TYPE_NAME"] width:230 font:[UIFont systemFontOfSize:13]];
    hei+=typeSize.height;
    
    CGSize roomSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"所属房间:%@",[deviceDic objectForKey:@"ROOM_NAME"]] width:230 font:[UIFont systemFontOfSize:13]];
    hei+=roomSize.height;
    
    CGSize zichanSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"实物编号:%@",[deviceDic objectForKey:@"ARTICLE_NUM"]] width:230 font:[UIFont systemFontOfSize:13]];
    hei+=zichanSize.height;
    
    CGSize shiwuSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"实物编号:%@",[deviceDic objectForKey:@"ASSETS_NUM"]] width:230 font:[UIFont systemFontOfSize:13]];
    hei+=shiwuSize.height;
    
    CGSize touchanSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"投产日期:%@",[deviceDic objectForKey:@"START_USE_DATE"]] width:230 font:[UIFont systemFontOfSize:13]];
    hei+=touchanSize.height;
    return hei;
}


-(void)setDic:(NSDictionary *)dic {
    if(![_dic isEqual:dic]) {
        _dic = dic;
        [self setNeedsLayout];
    }
}

-(void)onSelectChangeHandler {
    if([[_dic objectForKey:@"canEdit"] isEqualToString:@"NO"])
        return;
    if([[_dic objectForKey:@"selected"] isEqualToString:@"YES"]) {
         [_dic setValue:@"NO" forKey:@"selected"];
    }
    else {
        [_dic setValue:@"YES" forKey:@"selected"];
    }
    [self setNeedsLayout];
    if(_delegate && [_delegate respondsToSelector:@selector(refreshData)]) {
        [_delegate refreshData];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
