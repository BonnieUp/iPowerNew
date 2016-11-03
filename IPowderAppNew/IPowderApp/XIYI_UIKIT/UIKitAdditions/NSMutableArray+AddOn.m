//
//  NSMutableArray+AddOn.m
//  Gagein
//
//  Created by Dong Yiming on 5/22/13.
//  Copyright (c) 2013 gagein. All rights reserved.
//

#import "NSMutableArray+AddOn.h"

@implementation NSArray (AddOn)

-(id)objectAtIndexSafe:(NSUInteger)index
{
    if (index < self.count)
    {
        return self[index];
    }
    
    return nil;
}

@end

@implementation NSMutableArray (AddOn)


-(void)addObjectIfNotNil:(id)anObject
{
    if (anObject)
    {
        [self addObject:anObject];
    }
}

-(NSArray *)objectsTop:(NSUInteger)aTopNumber {
    NSUInteger number = MIN(aTopNumber, self.count);
    
    if (number > 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:number];
        for (int i = 0; i < number; i++) {
            [arr addObject:self[i]];
        }
        return arr;
    }
    
    return nil;
}

- (NSArray *)reverse {
    if ([self count] == 0)
        return self;
    
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
    
    return self;
}

@end
