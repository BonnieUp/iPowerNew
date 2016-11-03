//
//  RequestData.m
//  IPowerApp
//
//  Created by 王敏 on 14-6-14.
//  Copyright (c) 2014年 Min.wang. All rights reserved.
//

#import "RequestData.h"

@implementation RequestData

-(id)init {
    self = [super init];
    if(self ){
        parameterDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)addParameter:(NSString *)key value:(id)value {
    if(value!=nil) {
        [parameterDic setValue:value forKey:key];
    }
}

-(NSString *)toString {
    NSMutableString *result = [[NSMutableString alloc]init];
    NSArray *keys =  parameterDic.allKeys;
    for (NSString *key in keys) {
        id value = [parameterDic objectForKey:key];
        if([value isKindOfClass:[NSString class]]) {
            if(result.length == 0) {
                [result appendFormat:@"%@=%@",key,value];
            }else {
                [result appendFormat:@"&%@=%@",key,value];
            }
            
        }
    }
    return result;
}

-(NSMutableDictionary *)toDictionary{
     NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:parameterDic forKey:@"JsonParaList"];
     return jsonDict;
}

@end
