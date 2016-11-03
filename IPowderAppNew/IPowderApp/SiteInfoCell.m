//
//  SiteInfoCell.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-13.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "SiteInfoCell.h"

@implementation SiteInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        typeArray = [NSArray arrayWithObjects:@"A类",@"B类",@"C类",@"D类",@"E类",@"F类",@"G类", nil];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-60, 30)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:nameLabel];
    
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, ScreenWidth-60,20)];
    typeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:typeLabel];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.width-40, 20, 20,20);
    [btn setImage:[UIImage imageNamed:@"arrow_right_normal.png"] forState:UIControlStateNormal];
    [self addSubview:btn];
    
    NSInteger siteLevel = [[_infoDic objectForKey:@"siteLevelName"] integerValue];
    nameLabel.text = [NSString stringWithFormat:@"%@-%@",[_infoDic objectForKey:@"regName"],[_infoDic objectForKey:@"siteName"]];
    typeLabel.text = [NSString stringWithFormat:@"%@    %@",[typeArray objectAtIndex:siteLevel-1],[_infoDic objectForKey:@"siteTypeName"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfoDic:(NSDictionary *)infoDic {
    if(_infoDic != infoDic ) {
        _infoDic = infoDic;
        [self setNeedsLayout];
    }
    
}

@end
