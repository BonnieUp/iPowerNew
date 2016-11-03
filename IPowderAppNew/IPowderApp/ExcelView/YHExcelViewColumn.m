//
//  YHExcelViewColumn.m
//
//  Created by Yahui on 16/3/4.
//  Copyright © 2016年 Yahui. All rights reserved.
//  column

#import "YHExcelViewColumn.h"
#import "UIView+YHCategory.h"

@interface YHExcelViewColumn()

@end

@implementation YHExcelViewColumn

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:@"default"];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:CGRectZero]) {
        _reuseIdentifier = [reuseIdentifier copy];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    _textLabel = [UILabel new];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
    _contentView = [UIView new];
    [self addSubview:_contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
    _contentView.frame = self.bounds;
}

@end
