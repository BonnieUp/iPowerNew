//
//  IconView.h
//  i动力
//
//  Created by 丁浪平 on 16/3/19.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IconViewDelegate <NSObject>

- (void)didSelectIcon:(NSInteger)tag;

@end

@interface IconView : UIView<UIGestureRecognizerDelegate>{
    NSString *imageNameString;
    NSString *IconTitleString;
    
    
    
    UIImageView *ziyuanhechaImage;
    UILabel *nameLabel;
}
@property(nonatomic, strong) NSString *imageNameString;
@property(nonatomic, strong) NSString *IconTitleString;

@property(nonatomic,assign)id<IconViewDelegate>delegate;


- (instancetype)initIconViewWithValue:(NSString*)string1 title:(NSString*)string2;

@end
