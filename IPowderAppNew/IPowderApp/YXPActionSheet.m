//
//  YXPActionSheet.m
//  IPowerApp
//
//  Created by 王敏 on 14-7-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "YXPActionSheet.h"

#define BUTTON_LABEL_TAG 891204

@interface YXPActionSheet()

+ (UILabel *)buttonLabelWithText:(NSString *)text;
- (void)setActionSheetHeight:(CGFloat)height;
- (void)addButton:(UIGlossyButton *)button;
- (void)resizeButtons;
- (void)buttonTouched:(UIGlossyButton *)button;

@end

@implementation YXPActionSheet
{
    UIView *_dimmView;
    UIView *_sheetBackgroundView;
    NSMutableArray *_buttonArray;
}

@synthesize delegate = _delegate;

+ (YXPActionSheet *)actionSheetWithFrame:(CGRect)frame CancelButtonTitle:(NSString *)cancelTitle
                              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                   otherButtonTitles:(id)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    YXPActionSheet *sheetView = [[YXPActionSheet alloc] initWithFrame:frame];
    if(!sheetView) return nil;
    
    NSUInteger buttonIndex = 0;
    
    CGFloat height = 27.0f;
    if (destructiveButtonTitle)
    {
        UIGlossyButton *button = [[UIGlossyButton alloc]init];
        button.tag = buttonIndex++;
        button.frame = CGRectMake(0, height - 4.0f, 0.0f, 30);
        [button setNavigationButtonWithColor:[UIColor doneButtonColor]];
        UILabel *label = [YXPActionSheet buttonLabelWithText:destructiveButtonTitle];
        [button addSubview:label];
        [sheetView addButton:button];
        height += 59.0f;
    }
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
    {
        UIGlossyButton *button = [[UIGlossyButton alloc]init];
        button.tag = buttonIndex++;
        button.frame = CGRectMake(10, frame.size.height-35, 0.0f, 30);
        [button setNavigationButtonWithColor:[UIColor doneButtonColor]];
        UILabel *label = [YXPActionSheet buttonLabelWithText:arg];
        [button addSubview:label];
        [sheetView addButton:button];
        height += 59.0f;
    }
    va_end(args);
    
    if (cancelTitle)
    {
        UIGlossyButton *button = [[UIGlossyButton alloc]init];
        button.tag = buttonIndex++;
        button.frame = CGRectMake(0, height - 4.0f, 0.0f, 30);
        [button setNavigationButtonWithColor:[UIColor doneButtonColor]];
        UILabel *label = [YXPActionSheet buttonLabelWithText:cancelTitle];
        [button addSubview:label];
        [sheetView addButton:button];
        height += 59.0f;
    }
    
    [sheetView setActionSheetHeight:frame.size.height];
    return sheetView;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    self = [super initWithFrame:(CGRect){CGPointZero,screenSize}];
    if (self)
    {
        _buttonArray = [NSMutableArray array];
        
        _dimmView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,screenSize}];
        _dimmView.backgroundColor = [UIColor colorWithWhite:0.0f/255.0f alpha:0.5f];
        [super addSubview:_dimmView];
        
        _sheetBackgroundView = [[UIView alloc] initWithFrame:frame];
        _sheetBackgroundView.backgroundColor = [UIColor whiteColor];
        _sheetBackgroundView.userInteractionEnabled = YES;
        [super addSubview:_sheetBackgroundView];
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [_sheetBackgroundView addSubview:view];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    _sheetBackgroundView.transform = CGAffineTransformIdentity;
    
    CGFloat height = _sheetBackgroundView.frame.size.height;
    CGFloat superViewHeight = view.frame.size.height;
    
    _dimmView.alpha = 0;
    _sheetBackgroundView.frame = CGRectMake(0, superViewHeight, view.frame.size.width, height);
    [self resizeButtons];
    [UIView animateWithDuration:0.2 animations:^{
        _dimmView.alpha = 1;
        _sheetBackgroundView.frame = CGRectMake(0, superViewHeight - height, view.frame.size.width, height);
    }];
}

- (void)showInWindow
{
    [self showInView:[[[UIApplication sharedApplication] delegate] window]];
}

- (void)showInViewFromLeft:(UIView *)view
{
    [view addSubview:self];
    
    CGFloat height = _sheetBackgroundView.frame.size.height;
    CGFloat superViewHeight = view.frame.size.height;
    
    _dimmView.alpha = 0;
    
    CGRect originFrame = CGRectMake(-height / 2 - superViewHeight / 2,
                                    superViewHeight / 2 - height / 2,
                                    superViewHeight,
                                    height);
    _sheetBackgroundView.frame = originFrame;
    _sheetBackgroundView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    [self resizeButtons];
    [UIView animateWithDuration:0.2 animations:^{
        _dimmView.alpha = 1;
        _sheetBackgroundView.center = CGPointMake(height / 2, _sheetBackgroundView.center.y);
    }];
}

- (void)showInWindowFromLeft
{
    [self showInViewFromLeft:[[[UIApplication sharedApplication] delegate] window]];
}


- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        _dimmView.alpha = 0;
        if (CGAffineTransformEqualToTransform(_sheetBackgroundView.transform, CGAffineTransformMakeRotation(M_PI_2)))
        {
            CGFloat height = _sheetBackgroundView.frame.size.height;
            CGFloat superViewHeight = self.superview.frame.size.height;
            CGRect originFrame = CGRectMake(-height / 2 - superViewHeight / 2,
                                            superViewHeight / 2 - height / 2,
                                            superViewHeight,
                                            height);
            _sheetBackgroundView.frame = originFrame;
        }
        else
        {
            CGRect frame = _sheetBackgroundView.frame;
            frame.origin.y = self.superview.frame.size.height;
            _sheetBackgroundView.frame = frame;
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Private Methods

+ (UILabel *)buttonLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    label.text = text;
    label.font = [UIFont systemFontOfSize:19.0f];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor colorWithRed:44.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0, -1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.tag = BUTTON_LABEL_TAG;
    return label;
}

- (void)resizeButtons
{
    CGFloat frameWidth = _sheetBackgroundView.frame.size.width;
    if (CGAffineTransformEqualToTransform(_sheetBackgroundView.transform, CGAffineTransformMakeRotation(M_PI_2)))
    {
        frameWidth =_sheetBackgroundView.frame.size.height;
    }
    float buttonWidth = (frameWidth-20.0-_buttonArray.count*5)/_buttonArray.count;
    for (UIView *eachButton in _buttonArray)
    {
        int index = [_buttonArray indexOfObject:eachButton];
        CGRect buttonFrame = eachButton.frame;
        buttonFrame.origin.x = buttonWidth*index+index*5+10;
        buttonFrame.size.width = buttonWidth;
        eachButton.frame = buttonFrame;
        
        UIView *label = [eachButton viewWithTag:BUTTON_LABEL_TAG];
        label.frame = CGRectMake(10, 0, eachButton.frame.size.width - 20, eachButton.frame.size.height);
    }
}

- (void)setActionSheetHeight:(CGFloat)height
{
    _sheetBackgroundView.frame = CGRectMake(0, 0, 0, height);
}

- (void)addButton:(UIGlossyButton *)button
{
    [_buttonArray addObject:button];
    [button addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetBackgroundView addSubview:button];
}

- (void)buttonTouched:(UIGlossyButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:buttonTitle:)])
    {
        UILabel *label = (UILabel *)[button viewWithTag:BUTTON_LABEL_TAG];
        [self.delegate actionSheet:self clickedButtonAtIndex:button.tag buttonTitle:label.text];
    }
    [self dismiss];
}

@end
