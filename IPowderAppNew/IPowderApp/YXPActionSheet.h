//
//  YXPActionSheet.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXPActionSheet;

@protocol YXPActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(YXPActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex buttonTitle:(NSString *)title;

@end

@interface YXPActionSheet : UIView

+ (YXPActionSheet *)actionSheetWithFrame:(CGRect)frame
                       CancelButtonTitle:(NSString *)cancelTitle
                              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                   otherButtonTitles:(id)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic,assign) id<YXPActionSheetDelegate> delegate;

- (void)showInView:(UIView *)view;

- (void)showInWindow;

- (void)showInViewFromLeft:(UIView *)view;

- (void)showInWindowFromLeft;

- (void)dismiss;

@end
