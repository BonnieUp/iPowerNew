//
//  RequestData.h
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestData : NSObject {
    NSMutableDictionary *parameterDic;
}


-(void)addParameter:(NSString *)key
              value:(id)value;

-(NSString *)toString;
-(NSMutableDictionary *)toDictionary;

@end
