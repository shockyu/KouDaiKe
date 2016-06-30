//
//  UIColor+UIColorExtend.h
//  etionLib
//
//  Created by wu jingxing on 12-6-20.
//  Copyright (c) 2012年 GuangZhouXuanWu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (UIColorExtend)

+(UIColor*)colorWithRGBString:(NSString*)szRGB;

+(UIColor*)colorWithRGBAString:(NSString*)szRGBA;

+(UIColor*)colorWithR:(float)nR G:(float)nG B:(float)nB A:(float)nA;

+(UIColor*)colorWithHex:(NSUInteger)color;

+(UIColor*)colorWithHex:(NSUInteger)color alpha:(float)alpha;

+(UIColor*)colorWithHexString:(NSString*)hexString;

@end



typedef enum {EUIColorSetTender, EUIColorSetMild, EUIColorSetClean} EUIColorSet;

@interface UIColor (Set)

+ (void)useColorSet:(EUIColorSet)colorSet;
+ (UIColor *)lightBgColor;
+ (UIColor *)darkBgColor;
+ (UIColor *)lightFgColor;
+ (UIColor *)darkFgColor;
+ (UIColor *)midnightTextColor;
+ (UIColor *)goldColor;

+ (UIColor *)flatWhiteColor;
+ (UIColor *)flatLightWhiteColor;
+ (UIColor *)flatLightBlueColor;
+ (UIColor *)flatLightGreenColor;
+ (UIColor *)flatLightYellowColor;
+ (UIColor *)flatLightPinkYellowColor;
+ (UIColor *)flatLightRedColor;
+ (UIColor *)flatLightGrayColor;
+ (UIColor *)flatOrangeColor;
+ (UIColor *)flatPinkColor;

+ (UIColor *)flatDarkGrayColor;
+ (UIColor *)flatDarkGreenColor;

//海报颜色：
+ (UIColor *)PosterRedColor;              //红
+ (UIColor *)PosterOrangeColor;           //橙
+ (UIColor *)PosterYellowColor;           //黄
+ (UIColor *)PosterGreenColor;            //绿
+ (UIColor *)PosterLightGreenColor;       //青
+ (UIColor *)PosterBlueColor;             //蓝
+ (UIColor *)PosterPurpleColor;           //紫

//侧边栏颜色
+ (UIColor *)flatLightBlackColor;         //黑

+ (UIColor *)brighterColorWithColor:(UIColor *)color;
+ (UIColor *)lighterColorWithColor:(UIColor *)color;
+ (UIColor *)brighterColorWithColor:(UIColor *)color rate:(float)rate;
+ (UIColor *)lighterColorWithColor:(UIColor *)color rate:(float)rate;

@end
