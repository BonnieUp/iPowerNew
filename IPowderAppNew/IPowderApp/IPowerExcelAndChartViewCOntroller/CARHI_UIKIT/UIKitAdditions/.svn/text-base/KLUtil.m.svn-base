//
//  KLUtil.m
//  MyApp
//
//  Created by dlt on 15-2-10.
//  Copyright (c) 2015年 dlt. All rights reserved.
//

#import "KLUtil.h"

@implementation KLUtil


+(void)doInBackground:(void(^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (block) {
            block();
        }
    });
}

+(void)doInMain:(void(^)(void))block {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

+(void)doAsync:(void(^)(void))block completion:(void(^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (block) {
            block();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}
@end
