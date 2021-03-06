//
//  UtilityAdditions.m
//  WQExtension
//
//  Created by Jerry on 13-5-27.
//  Copyright (c) 2013年 Jerry. All rights reserved.
//

#import "UtilityAdditions.h"

#pragma mark NSObject
@implementation NSObject(WQ)

-(BOOL)isDictionary
{
    return [self isKindOfClass:[NSDictionary class]];
}

-(BOOL)isMutableDictionary
{
    return [self isKindOfClass:[NSMutableDictionary class]];
}

-(BOOL)isArray
{
    return [self isKindOfClass:[NSArray class]];
}

-(BOOL)isMutableArray
{
    return [self isKindOfClass:[NSMutableArray class]];
}

-(BOOL)isString
{
    return [self isKindOfClass:[NSString class]];
}

-(BOOL)isMutableString
{
    return [self isKindOfClass:[NSMutableString class]];
}

-(BOOL)isNumber
{
    return [self isKindOfClass:[NSNumber class]];
}

-(BOOL)isNull
{
    return [self isKindOfClass:[NSNull class]];
}

-(int)myIntValue
{
    if ([self isString])
        return [(NSString*)self intValue];
    else if ([self isNumber])
        return [(NSNumber*)self intValue];
    return 0;
}

//array
-(id)myObjectAtIndex:(NSUInteger)index
{
    if ([self isArray])
        return [(NSArray*)self noNullValueAtIndex:index];
    return nil;
}

-(void)myAddObject:(id)anObject
{
    if (![self isKindOfClass:[NSMutableArray class]])
    {
        return;
    }
    if (!anObject)
    {
        return;
    }
    [(NSMutableArray*)self addObject:anObject];
}

-(void)myInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (![self isKindOfClass:[NSMutableArray class]])
    {
        return;
    }
    if (!anObject)
    {
        return;
    }
    [(NSMutableArray*)self insertObject:anObject atIndex:index];
}

-(void)myReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (![self isKindOfClass:[NSMutableArray class]])
    {
        return;
    }
    if (!anObject)
    {
        return;
    }
    [(NSMutableArray*)self replaceObjectAtIndex:index withObject:anObject];
}

//dictionary
-(id)myObjectForKey:(id)aKey
{
    if ([self isDictionary])
        return [(NSDictionary*)self noNullValueForKey:aKey];
    return nil;
}

-(void)mySetObject:(id)anObject forKey:(id<NSCopying>)aKey;
{
    if (![self isKindOfClass:[NSMutableDictionary class]])
    {
        return;
    }
    if (!anObject)
    {
        return;
    }
    if (!aKey)
    {
        return;
    }
    [(NSMutableDictionary*)self setObject:anObject forKey:aKey];
}

@end
#pragma mark NSString
@implementation NSString (WQ)

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                (CFStringRef)[self mutableCopy],
                                                                                NULL,
                                                                                CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding);
}

-(NSString *)URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    
    return result;
}



-(BOOL)isNullOrEmptyString
{
    return [self isNull] || ([self length] == 0);
}

- (NSString *)byteString:(NSInteger)byte
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str = [[NSString alloc] initWithFormat:@"%@", self];
    
    if( [self lengthOfBytesUsingEncoding:enc] >= byte-30)
    {
        for (int i = ([self length] - 30)/2; i < [self length]/2; i++)
        {
            str = [self substringToIndex:i];
            if([str lengthOfBytesUsingEncoding:enc] >= (byte - 30))
            {
                break;
            }
        }
        return str;
    }
    else
    {
        return str;
    }
}

-(CGSize)FDPicSize
{
    //  NSString *url = @"http://upload.utan.com/skill_image/c8/8d/1549/2012/02/25/201202252030259i_500X333.jpg";
    
    NSString *name = [self lastPathComponent];
    
    if( !name )
    {
        return CGSizeMake(0, 0);
    }
    
    NSRange _last = [name rangeOfString:@"."];
    if( _last.length == 0 ) return CGSizeMake(0, 0);
    
    NSRange _start = [name rangeOfString:@"_" options:NSBackwardsSearch];
    if( _start.length == 0 ) return CGSizeMake(0, 0);
    
    NSString *size = [name substringWithRange:NSMakeRange(_start.location+1, _last.location-1-_start.location)];
    
    NSRange widthRange = [size rangeOfString:@"X"];
    if( widthRange.length == 0 ) return CGSizeMake(0, 0);
    
    NSString *w = [size substringWithRange:NSMakeRange(0, widthRange.location)];
    NSString *h = [size substringFromIndex:widthRange.location+1];
    
    return CGSizeMake([w intValue], [h intValue]);
}

-(BOOL)isEmptyOrWhitespace
{
    if (![self isString])
        return YES;
    
    return (!self.length
            || ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length);
}

-(NSString*)stringByReplacingBackslash
{
    return [self stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

@end


#pragma mark NSArray
@implementation NSArray (WQ)

-(id)noNullValueAtIndex:(NSUInteger)index
{
    if ([self count] <= index)
        return nil;
    id object = [self objectAtIndex:index];
    if ([object isKindOfClass:[NSNull class]])
        return nil;
    return object;
}

@end


#pragma mark NSDictionary
@implementation NSDictionary (WQ)

-(id)noNullValueForKey:(id)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]])
        return nil;
    return object;
}

-(NSString*)intStringForKey:(id)key
{
    NSString* str = [NSString stringWithFormat:@"%d", [[self objectForKey:key] intValue]];
    return str;
}

-(int)intForKey:(id)key
{
    return [[self objectForKey:key] intValue];
}

@end


#pragma mark
@implementation NSUserDefaults (WQ)

-(void)setObjectAndSync:(id)value forKey:(NSString *)defaultName
{
    [self setObject:value forKey:defaultName];
    [self synchronize];
}

-(void)removeObjectForKeyAndSync:(NSString *)defaultName
{
    [self removeObjectForKey:defaultName];
    [self synchronize];
}

@end

