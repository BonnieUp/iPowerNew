//
//  CustomSwitch.h
//  IPowerApp
//
//  Created by 王敏 on 14-7-12.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomSwitchDelegate <NSObject>
@optional
-(void)switchOnChange:(id)sender;
@end

@interface CustomSwitch : UIButton

-(void)setSwitchOnImage:(UIImage *)onImage
               offImage:(UIImage *)offImage;

@property (nonatomic,assign) BOOL on;

@property(nonatomic,assign) id<CustomSwitchDelegate> delegate;
@end
