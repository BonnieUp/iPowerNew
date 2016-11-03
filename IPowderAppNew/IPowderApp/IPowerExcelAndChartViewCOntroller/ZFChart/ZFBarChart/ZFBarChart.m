//
//  ZFBarChart.m
//  ZFChartView
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFBarChart.h"
#import "ZFBar.h"
#import "ZFGenericAxis.h"
#import "ZFConst.h"
#import "ZFLabel.h"
#import "NSString+Zirkfied.h"
#import "ZFMethod.h"

@interface ZFBarChart()

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericAxis * genericAxis;
/** 主题Label */
@property (nonatomic, strong) UILabel * topicLabel;
/** 存储柱状条的数组 */
@property (nonatomic, strong) NSMutableArray * barArray;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray * colorArray;
/** 存储value文本颜色的数组 */
@property (nonatomic, strong) NSMutableArray * valueTextColorArray;
/** bar宽度 */
@property (nonatomic, assign) CGFloat barWidth;
/** bar与bar之间的间距 */
@property (nonatomic, assign) CGFloat barPadding;
/** value文本颜色 */
@property (nonatomic, strong) UIColor * valueTextColor;

@end

@implementation ZFBarChart

- (NSMutableArray *)barArray{
    if (!_barArray) {
        _barArray = [NSMutableArray array];
    }
    return _barArray;
}

- (NSMutableArray *)valueTextColorArray{
    if (!_valueTextColorArray) {
        _valueTextColorArray = [NSMutableArray array];
    }
    return _valueTextColorArray;
}

- (void)commonInit{
    _valueOnChartFontSize = 10.f;
    _overMaxValueBarColor = ZFRed;
    _isShadow = YES;
    _barWidth = XLineItemWidth;
    _barPadding = XLinePaddingForBarLength;
    _valueTextColor = ZFBlack;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self drawGenericChart];
        
        //标题Label
        self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        self.topicLabel.font = [UIFont boldSystemFontOfSize:18.f];
        self.topicLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topicLabel];
    }
    
    return self;
}

#pragma mark - 坐标轴

/**
 *  画坐标轴
 */
- (void)drawGenericChart{
    self.genericAxis = [[ZFGenericAxis alloc] initWithFrame:self.bounds];
    [self addSubview:self.genericAxis];
}

#pragma mark - 柱状条

/**
 *  画柱状条
 */
- (void)drawBar:(NSMutableArray *)valueArray{
    NSArray* subObject = valueArray.firstObject;
    if ([subObject isKindOfClass:[NSString class]]) {
        for (NSInteger i = 0; i < valueArray.count; i++) {
            CGFloat xPos = self.genericAxis.axisStartXPos + self.genericAxis.groupPadding + (_barWidth + self.genericAxis.groupPadding) * i;
            CGFloat yPos = self.genericAxis.yLineMaxValueYPos;
            CGFloat width = _barWidth;
            CGFloat height = self.genericAxis.yLineMaxValueHeight;
            
            ZFBar * bar = [[ZFBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
            //当前数值超过y轴显示上限时，柱状改为红色
            if ([self.genericAxis.xLineValueArray[i] floatValue] / self.genericAxis.yLineMaxValue <= 1) {
                bar.percent = [self.genericAxis.xLineValueArray[i] floatValue] / self.genericAxis.yLineMaxValue;
                bar.barColor = _colorArray.firstObject;
            }else{
                bar.percent = 1.f;
                bar.barColor = _overMaxValueBarColor;
            }
            bar.isShadow = _isShadow;
            [bar strokePath];
            [self.barArray addObject:bar];
            [self.genericAxis addSubview:bar];
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        if ([[subObject firstObject] isKindOfClass:[NSString class]]) {
            //bar总数
            NSInteger count = [valueArray count] * [subObject count];
            for (NSInteger i = 0; i < count; i++) {
                //每组bar的下标
                NSInteger barIndex = i % [subObject count];
                //组下标
                NSInteger groupIndex = i / [subObject count];
                
                CGFloat xPos = self.genericAxis.axisStartXPos + self.genericAxis.groupPadding * (barIndex + 1) + self.genericAxis.groupWidth * barIndex + (_barWidth + _barPadding) * groupIndex;
                CGFloat yPos = self.genericAxis.yLineMaxValueYPos;
                CGFloat width = _barWidth;
                CGFloat height = self.genericAxis.yLineMaxValueHeight;
                
                ZFBar * bar = [[ZFBar alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
                //当前数值超过y轴显示上限时，柱状改为红色
                if ([valueArray[groupIndex][barIndex] floatValue] / self.genericAxis.yLineMaxValue <= 1) {
                    bar.percent = [valueArray[groupIndex][barIndex] floatValue] / self.genericAxis.yLineMaxValue;
                    bar.barColor = _colorArray[groupIndex];
                }else{
                    bar.percent = 1.f;
                    bar.barColor = _overMaxValueBarColor;
                }
                bar.isShadow = _isShadow;
                [bar strokePath];
                [self.barArray addObject:bar];
                [self.genericAxis addSubview:bar];
            }
        }
    }
}

/**
 *  设置x轴valueLabel
 */
- (void)setValueLabelOnChart:(NSMutableArray *)valueArray{
    NSArray* subObject = valueArray.firstObject;
    if ([subObject isKindOfClass:[NSString class]]) {
        for (NSInteger i = 0; i < self.barArray.count; i++) {
            ZFBar * bar = self.barArray[i];
            //label的中心点
            CGPoint label_center = CGPointMake(bar.center.x, bar.endYPos + self.genericAxis.yAxisLine.yLineEndYPos);
            CGRect rect = [self.genericAxis.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(_barWidth + self.genericAxis.groupPadding * 0.5, 30) fontOfSize:_valueOnChartFontSize isBold:NO];
            ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            
            label.text = self.genericAxis.xLineValueArray[i];
            label.font = [UIFont systemFontOfSize:_valueOnChartFontSize];
            label.numberOfLines = 0;
            label.center = label_center;
            label.isFadeInAnimation = YES;
            label.textColor = (UIColor *)_valueTextColorArray.firstObject;
            [self.genericAxis addSubview:label];
        }
        
    }else if ([subObject isKindOfClass:[NSArray class]]){
        if ([[subObject firstObject] isKindOfClass:[NSString class]]) {
            for (NSInteger i = 0; i < self.barArray.count; i++) {
                ZFBar * bar = self.barArray[i];
                NSInteger barIndex = i % [subObject count];
                NSInteger groupIndex = i / [subObject count];
                //label的中心点
                CGPoint label_center = CGPointMake(bar.center.x, bar.endYPos + self.genericAxis.yAxisLine.yLineEndYPos);
                CGRect rect = [valueArray[groupIndex][barIndex] stringWidthRectWithSize:CGSizeMake(_barWidth + self.genericAxis.groupPadding * 0.5, 30) fontOfSize:_valueOnChartFontSize isBold:NO];
                ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                label.text = valueArray[groupIndex][barIndex];
                label.font = [UIFont systemFontOfSize:_valueOnChartFontSize];
                label.numberOfLines = 0;
                label.center = label_center;
                label.isFadeInAnimation = YES;
                label.textColor = (UIColor *)_valueTextColorArray[groupIndex];
                [self.genericAxis addSubview:label];
            }
        }
    }
}

/**
 *  清除之前所有柱状条
 */
- (void)removeAllBar{
    [self.barArray removeAllObjects];
    for (UIView * view in self.genericAxis.subviews) {
        if ([view isKindOfClass:[ZFBar class]]) {
            [(ZFBar *)view removeFromSuperview];
        }
    }
}

/**
 *  清除柱状条上的Label
 */
- (void)removeLabelOnChart{
    for (UIView * view in self.genericAxis.subviews) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
}

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self.valueTextColorArray removeAllObjects];
    
    if ([self.dataSource respondsToSelector:@selector(valueArrayInGenericChart:)]) {
        self.genericAxis.xLineValueArray = [NSMutableArray arrayWithArray:[self.dataSource valueArrayInGenericChart:self]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(nameArrayInGenericChart:)]) {
        self.genericAxis.xLineNameArray = [NSMutableArray arrayWithArray:[self.dataSource nameArrayInGenericChart:self]];
    }
    
    if ([self.delegate respondsToSelector:@selector(colorArrayInGenericChart:)]) {
        _colorArray = [NSMutableArray arrayWithArray:[self.dataSource colorArrayInGenericChart:self]];
    }else{
        _colorArray = [NSMutableArray arrayWithArray:[[ZFMethod shareInstance] cachedColor:self.genericAxis.xLineValueArray]];
    }
    
    if ([self.dataSource respondsToSelector:@selector(yLineMaxValueInGenericChart:)]) {
        self.genericAxis.yLineMaxValue = [self.dataSource yLineMaxValueInGenericChart:self];
    }else{
        self.genericAxis.yLineMaxValue = [[ZFMethod shareInstance] cachedYLineMaxValue:self.genericAxis.xLineValueArray];
    }
    
    if ([self.dataSource respondsToSelector:@selector(yLineSectionCountInGenericChart:)]) {
        self.genericAxis.yLineSectionCount = [self.dataSource yLineSectionCountInGenericChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(barWidthInBarChart:)]) {
        _barWidth = [self.delegate barWidthInBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForGroupsInBarChart:)]) {
        self.genericAxis.groupPadding = [self.delegate paddingForGroupsInBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(paddingForBarInBarChart:)]) {
        _barPadding = [self.delegate paddingForBarInBarChart:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(valueTextColorArrayInChart:)]) {
        id color = [self.delegate valueTextColorArrayInChart:self];
        NSArray* subObject = self.genericAxis.xLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            if ([color isKindOfClass:[UIColor class]]) {
                [self.valueTextColorArray addObject:color];
            }else if ([color isKindOfClass:[NSArray class]]){
                self.valueTextColorArray = [NSMutableArray arrayWithArray:color];
            }
            
        }else if ([subObject isKindOfClass:[NSArray class]]){
            if ([color isKindOfClass:[UIColor class]]) {
                for (NSInteger i = 0; i < [subObject count]; i++) {
                    [self.valueTextColorArray addObject:color];
                }
            }else if ([color isKindOfClass:[NSArray class]]){
                self.valueTextColorArray = [NSMutableArray arrayWithArray:color];
            }
        }
        
    }else{
        NSArray* subObject = self.genericAxis.xLineValueArray.firstObject;
        if ([subObject isKindOfClass:[NSString class]]) {
            [self.valueTextColorArray addObject:_valueTextColor];
        }else if ([subObject isKindOfClass:[NSArray class]]){
            for (NSInteger i = 0; i < [subObject count]; i++) {
                [self.valueTextColorArray addObject:_valueTextColor];
            }
        }
    }
    
    self.genericAxis.groupWidth = [self cachedGroupWidth:self.genericAxis.xLineValueArray];
    
    [self removeAllBar];
    [self removeLabelOnChart];
    [self.genericAxis strokePath];
    [self drawBar:self.genericAxis.xLineValueArray];
    [self setValueLabelOnChart:self.genericAxis.xLineValueArray];
    [self.genericAxis bringSubviewToFront:self.genericAxis.yAxisLine];
}

/**
 *  求每组宽度
 */
- (CGFloat)cachedGroupWidth:(NSMutableArray *)array{
    id subObject = array.firstObject;
    if ([subObject isKindOfClass:[NSArray class]]) {
        return array.count * _barWidth + (array.count - 1) * _barPadding;
    }
    
    return _barWidth;
}

#pragma mark - 重写setter,getter方法

- (void)setTopic:(NSString *)topic{
    _topic = topic;
    self.topicLabel.text = _topic;
}

- (void)setUnit:(NSString *)unit{
    _unit = unit;
    self.genericAxis.unit = _unit;
}

- (void)setTopicColor:(UIColor *)topicColor{
    _topicColor = topicColor;
    self.topicLabel.textColor = _topicColor;
}

- (void)setXLineNameFontSize:(CGFloat)xLineNameFontSize{
    _xLineNameFontSize = xLineNameFontSize;
    self.genericAxis.xLineNameFontSize = _xLineNameFontSize;
}

- (void)setYLineValueFontSize:(CGFloat)yLineValueFontSize{
    _yLineValueFontSize = yLineValueFontSize;
    self.genericAxis.yLineValueFontSize = _yLineValueFontSize;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = !backgroundColor ? ZFWhite : backgroundColor;
    self.genericAxis.axisLineBackgroundColor = _backgroundColor;
}

@end
