//
//  BZDataDealer.m
//  Bizhi
//
//  Created by wangs on 13-10-7.
//  Copyright (c) 2013年 wangs. All rights reserved.
//

#import "BZDataDealer.h"

//#import "QTXDataUtils.h"

@implementation BZDataDealer

+ (CGSize)SizeForString:(NSString *)str WithFont:(UIFont *)font AndWidth:(NSInteger)width
{
    if (!str)
    {
        return CGSizeZero;
    }
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:str attributes:attrsDictionary];

    CGRect paragraphRect =
    [attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                 options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                 context:nil];
    CGSize returnSize = CGSizeMake(ceilf(paragraphRect.size.width), ceilf(paragraphRect.size.height));
    
	return returnSize;
}

+ (int)sinaCountWord:(NSString*)s
{
    int i,n=[s length],l=0,a=0,b=0;
    
    unichar c;
    
    for(i=0;i<n;i++)
    {
        c=[s characterAtIndex:i];
        if(isblank(c))
        {
            b++;
        }
        else if(isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }
    }
    
    if(a==0 && l==0)
        return 0;
    
    NSInteger len = l+(int)ceilf((float)(a+b)/2.0);
    
    return len;
}

/* 时间表示        // 1~59m | 1~23h |  1~6d | 1~52w | 1~ny
+ (NSString *)getCustomDateStringWithDateString:(NSString *)dateStr
{
    NSString *timeStamp = nil;
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    NSTimeInterval tInterval = [[NSDate date] timeIntervalSinceDate:destDate];
    
    NSInteger minuteInt = 60;
    NSInteger hourInt   = 60*60;
    NSInteger dayInt    = 60*60*24;
    NSInteger weekInt   = 60*60*24*7;
    NSInteger yearInt   = 60*60*24*7*52;
   
    int gapTime = (int)tInterval;
    if (gapTime < minuteInt)
    {
        //一分钟内显示刚刚
        timeStamp = @"1m";
    }
    else if(minuteInt<=gapTime && gapTime<hourInt)
    {
        //一分钟以上且一个小时之内的，显示“1~59m ”
        timeStamp = [NSString stringWithFormat:@"%im",gapTime/minuteInt];
    }
    else if (hourInt<=gapTime && gapTime<dayInt)
    {
        //1-24小时，显示“1~23h”
        timeStamp = [NSString stringWithFormat:@"%ih",gapTime/hourInt];
    }
    else if (dayInt<=gapTime && gapTime<weekInt)
    {
        timeStamp = [NSString stringWithFormat:@"%id",gapTime/dayInt];
        
    }
    else if (weekInt<=gapTime && gapTime<yearInt)
    {
        timeStamp = [NSString stringWithFormat:@"%iw",gapTime/weekInt];
    }
    else
    {
        timeStamp = [NSString stringWithFormat:@"%iny",gapTime/yearInt];
    }
    
    return timeStamp;
}
 */

#pragma mark - URLEncode

+ (NSString *)URLEncodedString:(NSString *)sorStr
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)sorStr,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}

+ (NSString *)URLDecodeString:(NSString *)sorStr
{
    NSString *result = [sorStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

//+ (NSString *)MD5EncodeWithString:(NSString*)sorStr;
//{
//    const char *cStr = [sorStr UTF8String];
//    unsigned char result[16];
//    CC_MD5( cStr, strlen(cStr), result );
//    return [NSString stringWithFormat:
//            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
//    
////    const char *ptr = [sorStr UTF8String];
////    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
////    
////    CC_MD5(ptr, strlen(ptr), md5Buffer);
////    
////    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
////    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
////    {
////        [output appendFormat:@"%02x",md5Buffer[i]];
////    }
////    return output;
//}

+ (NSDictionary *)getProperDictWithData:(NSData *)jsonData;
{
    if (![jsonData isKindOfClass:[NSData class]])
    {
        return nil;
    }
    
    NSDictionary *jsonDict = nil; // [jsonData objectFromJSONData];
    NSDictionary *cleanDict = [jsonDict dictionaryByReplacingNullsWithBlanks];
    
    return cleanDict;
}

@end
