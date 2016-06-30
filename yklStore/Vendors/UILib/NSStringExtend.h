//
//  NSStringExtend.h
//  Etion
//
//  Created by  user on 11-7-30.
//  Copyright 2011 GuangZhouXuanWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CQueueDictionary;

@interface NSString (NSStringExtend)
@property (nonatomic, strong)NSArray *bankBin;
@property (nonatomic, strong)NSArray *bankName;

+ (BOOL)isNumberString:(NSString *)str;

- (BOOL)isNumberString;

+ (BOOL)isFloatNumberString:(NSString *)str;

- (BOOL)isFloatNumberString;

+ (BOOL)isBlankString:(NSString *)str;

- (BOOL)isBlankString;

+ (BOOL)isEmailString:(NSString *)str;

- (BOOL)isEmailString;

+ (BOOL)isEnglishString:(NSString *)str;

- (BOOL)isEnglishString;

+ (BOOL)isHttpString:(NSString *)str;

- (BOOL)isHttpString;

+ (BOOL)isMobileNumber:(NSString *)str;

- (BOOL)isMobileNumber;

+ (BOOL)isTelephoneNumber:(NSString *)str;

- (BOOL)isTelephoneNumber;

+ (NSString*)stringValue:(NSString*)string;

+ (UInt32)hexToUInt:(NSString *)szHex;

- (UInt32)hexToUInt;

- (NSDate *)toNSDate:(NSString *)szFormat;

- (NSString *)isBankNumber;
//判断银行卡归属行
+ (NSString *)returnBankName:(NSString*) idCard;

- (NSString *)timeNumber;
//+ (NSString *)timeNumber:(NSString*)time;

+ (NSString *)timeNumberHHmm:(NSString*)time;

/** 四舍五入 */
- (NSDecimalNumber *)getNSRoundPlain:(int)num;
@end
