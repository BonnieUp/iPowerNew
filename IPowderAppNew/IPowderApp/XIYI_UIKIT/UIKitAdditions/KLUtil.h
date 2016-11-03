//
//  KLUtil.h
//  MyApp
//
//  Created by dlt on 15-2-10.
//  Copyright (c) 2015年 dlt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLUtil : NSObject
+(void)doInBackground:(void(^)(void))block ;
+(void)doInMain:(void(^)(void))block;
+(void)doAsync:(void(^)(void))block completion:(void(^)(void))completion;
@end
