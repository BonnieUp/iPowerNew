//
//  WeichaDeviceTableCell.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-16.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "YichaDeviceTableCell.h"

@implementation YichaDeviceTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //设备名称label
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,260, 30)];
    nameLabel.numberOfLines = 3;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.tag = 100;
    [self.contentView addSubview:nameLabel];
    
    //设备类型label
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLabel.bottom, 260, 30)];
    typeLabel.numberOfLines = 3;
    typeLabel.font = [UIFont systemFontOfSize:13];
    typeLabel.tag = 101;
    [self.contentView addSubview:typeLabel];
    
    //所属房间label
    UILabel *roomLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, typeLabel.bottom, 260, 30)];
    roomLabel.numberOfLines = 3;
    roomLabel.font = [UIFont systemFontOfSize:13];
    roomLabel.tag = 102;
    [self.contentView addSubview:roomLabel];
    
    //资产编号label
    UILabel *zichanLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, roomLabel.bottom, 260, 30)];
    zichanLabel.numberOfLines = 3;
    zichanLabel.font = [UIFont systemFontOfSize:13];
    zichanLabel.tag = 103;
    [self.contentView addSubview:zichanLabel];
    
    //实物编号label
    UILabel *shiwuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, zichanLabel.bottom, 260, 30)];
    shiwuLabel.numberOfLines = 3;
    shiwuLabel.font = [UIFont systemFontOfSize:13];
    shiwuLabel.tag = 104;
    [self.contentView addSubview:shiwuLabel];
    
    //投产日期label
    UILabel *touchanLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, shiwuLabel.bottom, 220, 30)];
    touchanLabel.numberOfLines = 3;
    touchanLabel.font = [UIFont systemFontOfSize:13];
    touchanLabel.tag = 105;
    [self.contentView addSubview:touchanLabel];
    
    //是否修改过的图标
    UIImageView *modifyIcon = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-30, 10, 15, 15)];
    if([[_dic objectForKey:@"modifyed"] isEqualToString:@"YES"]) {
        modifyIcon.image = [PowerUtils OriginImage:[UIImage imageNamed:@"ic_alarm.png"] scaleToSize:CGSizeMake(15, 15)];
    }else {
        modifyIcon.image = [PowerUtils OriginImage:[UIImage imageNamed:@"ic_ok.png"] scaleToSize:CGSizeMake(15, 15)];
    }
    [self.contentView addSubview:modifyIcon];
    
    //添加分割线
    UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5)];
    seperateView.tag  = 200;
    seperateView.alpha = 0.8;
    seperateView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:seperateView];
    
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

    
    //如果没有数据，隐藏分割线
    if(_dic == nil) {
        [seperateView setHidden:YES];
    }else {
        [seperateView setHidden:NO];
    }
    
    //重置位置
    CGSize nameSize = [PowerUtils getLabelSizeWithText:nameLabel.text width:230 font:[UIFont systemFontOfSize:15]];
    nameLabel.frame = CGRectMake(10, 5, 260, nameSize.height);
    
    CGSize typeSize = [PowerUtils getLabelSizeWithText:typeLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    typeLabel.frame = CGRectMake(10,nameLabel.bottom, 260, typeSize.height);
    
    CGSize roomSize = [PowerUtils getLabelSizeWithText:roomLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    roomLabel.frame = CGRectMake(10,typeLabel.bottom, 260, roomSize.height);
    
    CGSize zichanSize = [PowerUtils getLabelSizeWithText:zichanLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    zichanLabel.frame = CGRectMake(10,roomLabel.bottom, 260, zichanSize.height);
    
    CGSize shiwuSize = [PowerUtils getLabelSizeWithText:shiwuLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    shiwuLabel.frame = CGRectMake(10,zichanLabel.bottom, 260, shiwuSize.height);
    
    CGSize touchanSize = [PowerUtils getLabelSizeWithText:touchanLabel.text width:230 font:[UIFont systemFontOfSize:13]];
    touchanLabel.frame = CGRectMake(10, shiwuLabel.bottom, 260,touchanSize.height);
    
    seperateView.frame = CGRectMake(0, touchanLabel.bottom+4, ScreenWidth, 0.5);

}

+(float)caculateCellHeight:(NSDictionary *)deviceDic {
    float hei=10;
    CGSize nameSize = [PowerUtils getLabelSizeWithText:[deviceDic objectForKey:@"DEV_NAME"] width:260 font:[UIFont systemFontOfSize:15]];
    hei+=nameSize.height;
    
    CGSize typeSize = [PowerUtils getLabelSizeWithText:[deviceDic objectForKey:@"DEV_TYPE_NAME"] width:260 font:[UIFont systemFontOfSize:13]];
    hei+=typeSize.height;
    
    CGSize roomSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"所属房间:%@",[deviceDic objectForKey:@"ROOM_NAME"]] width:260 font:[UIFont systemFontOfSize:13]];
    hei+=roomSize.height;
    
    CGSize zichanSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"实物编号:%@",[deviceDic objectForKey:@"ARTICLE_NUM"]] width:260 font:[UIFont systemFontOfSize:13]];
    hei+=zichanSize.height;
    
    CGSize shiwuSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"实物编号:%@",[deviceDic objectForKey:@"ASSETS_NUM"]] width:260 font:[UIFont systemFontOfSize:13]];
    hei+=shiwuSize.height;
    
    CGSize touchanSize = [PowerUtils getLabelSizeWithText:[NSString stringWithFormat:@"投产日期:%@",[deviceDic objectForKey:@"START_USE_DATE"]] width:260 font:[UIFont systemFontOfSize:13]];
    hei+=touchanSize.height;
    return hei;
}


@end
