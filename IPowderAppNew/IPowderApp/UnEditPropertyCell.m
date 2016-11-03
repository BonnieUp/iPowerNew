//
//  UnEditPropertyCell.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-24.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "UnEditPropertyCell.h"

@implementation UnEditPropertyCell {
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    int _leftWidth;
    NSString *_propertyName;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithPropertyName:(NSString *)propertyName leftWidth:(int)leftWidth frame:(CGRect)frame{
    self = [self initWithFrame:frame];
    if(self) {
        _propertyName = propertyName;
        _leftWidth = leftWidth;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _leftWidth, self.height-1)];
    _leftLabel.font = [UIFont systemFontOfSize:13];
    _leftLabel.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    _leftLabel.text = _propertyName;
    [self addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(_leftWidth+5, 0, self.width-_leftWidth-5, self.height-1)];
    _rightLabel.numberOfLines = 2;
    _rightLabel.font = [UIFont systemFontOfSize:13];
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_rightLabel];
    
    UIView *seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 0.5)];
    seperateView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self addSubview:seperateView];
    
}

-(void)setPropertyValue:(NSString *)value {
    _rightLabel.text = value;
}
@end
