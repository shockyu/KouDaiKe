//
//  BZDataDealer.h
//  Bizhi
//
//  Created by wangs on 13-10-7.
//  Copyright (c) 2013年 wangs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NSArray+NullReplacement.h"
#import "NSDictionary+NullReplacement.h"

@interface BZDataDealer : NSObject

+ (CGSize)SizeForString:(NSString *)str WithFont:(UIFont *)font AndWidth:(NSInteger)width;

+ (int)sinaCountWord:(NSString*)s;

// 时间表示               // 1~59m | 1~23h |  1~6d | 1~52w | 1~ny
+ (NSString *)getCustomDateStringWithDateString:(NSString *)dateStr;

//
+ (NSString *)URLDecodeString:(NSString *)sorStr;

+ (NSString *)URLEncodedString:(NSString *)sorStr;

//+ (NSString *)MD5EncodeWithString:(NSString*)sorStr;

+ (NSDictionary *)getProperDictWithData:(NSData *)jsonData;

@end
