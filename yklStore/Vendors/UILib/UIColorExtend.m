//
//  UIColor+UIColorExtend.m
//  etionLib
//
//  Created by wu jingxing on 12-6-20.
//  Copyright (c) 2012年 GuangZhouXuanWu. All rights reserved.
//

#import "UIColorExtend.h"

@implementation UIColor (UIColorExtend)

+(UIColor*)colorWithRGBString:(NSString*)szRGB
{
    return [UIColor colorWithRGBAString:[NSString stringWithFormat:@"%@,1",szRGB]];
}

+(UIColor*)colorWithRGBAString:(NSString*)szRGBA
{
    NSArray* ar=[szRGBA componentsSeparatedByString:@","]; 
    return [UIColor colorWithR:[[ar objectAtIndex:0]floatValue] G:[[ar objectAtIndex:1]floatValue] B:[[ar objectAtIndex:2]floatValue] A:[[ar objectAtIndex:3]floatValue]];
}

+(UIColor*)colorWithR:(float)nR G:(float)nG B:(float)nB A:(float)nA
{
    return [UIColor colorWithRed:nR/255.0 green:nG/255.0 blue:nB/255.0 alpha:nA];
}

+(UIColor*)colorWithHex:(NSUInteger)color
{
    return [UIColor colorWithHex:color alpha:1.0];
}

+(UIColor*)colorWithHex:(NSUInteger)color alpha:(float)alpha
{
    return [UIColor colorWithRed:((color & 0xff0000) >> 16) / 255.0f
                           green:((color & 0xff00) >> 8) / 255.0f
                            blue:(color & 0xff) / 255.0f
                           alpha:alpha];
}

+(UIColor*)colorWithHexString:(NSString*)hexString
{
    NSString *valueString = hexString;
    if ([valueString hasPrefix:@"0x"])
    {
        valueString = [hexString substringFromIndex:2];
    }
    if (valueString.length != 8 && valueString.length != 6)
    {
        return nil;
    }
    
    unsigned int color = 0;
    unsigned int alpha = 255;
    if (valueString.length == 6)
    {
        NSScanner *scanner = [NSScanner scannerWithString:valueString];
        [scanner scanHexInt:&color];
    }
    else
    {
        NSScanner *scanner = [NSScanner scannerWithString:[valueString substringToIndex:6]];
        [scanner scanHexInt:&color];
        scanner = [NSScanner scannerWithString:[valueString substringFromIndex:6]];
        [scanner scanHexInt:&alpha];
    }
    
    return [UIColor colorWithHex:color alpha:alpha/255.0f];
}

@end



static EUIColorSet s_colorSet = EUIColorSetTender;
static NSArray *s_lightBgColor;
static NSArray *s_darkBgColor;
static NSArray *s_lightFgColor;
static NSArray *s_darkFgColor;

@implementation UIColor (Set)

+ (void)useColorSet:(EUIColorSet)colorSet
{
    s_colorSet = colorSet;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_lightBgColor = @[RGBCOLOR(254, 239, 239), RGBCOLOR(245, 248, 234), RGBCOLOR(242, 249, 249)];
        s_darkBgColor = @[RGBCOLOR(239, 111, 137), RGBCOLOR(157, 201, 42), RGBCOLOR(109, 187, 203)];
        s_lightFgColor = @[RGBCOLOR(252, 227, 206), RGBCOLOR(206, 222, 90), RGBCOLOR(223, 242, 252)];
        s_darkFgColor = @[RGBCOLOR(233, 71, 48), RGBCOLOR(92, 146, 65), RGBCOLOR(0, 153, 189)];
    });
}

+ (UIColor *)lightBgColor
{
    return s_lightBgColor[s_colorSet];
}

+ (UIColor *)darkBgColor
{
    return s_darkBgColor[s_colorSet];
}

+ (UIColor *)lightFgColor
{
    return s_lightFgColor[s_colorSet];
}

+ (UIColor *)darkFgColor
{
    return s_darkFgColor[s_colorSet];
}

+ (UIColor *)midnightTextColor
{
    return [UIColor colorWithRed:112.0/255 green:112.0/255 blue:112.0/255 alpha:1];
}

+ (UIColor *)goldColor
{
    return [UIColor colorWithHex:0xffd700];
}

+ (UIColor *)brighterColorWithColor:(UIColor *)color
{
    return [UIColor brighterColorWithColor:color rate:0.5];
}

+ (UIColor *)lighterColorWithColor:(UIColor *)color
{
    return [UIColor lighterColorWithColor:color rate:0.85];
}

+ (UIColor *)flatWhiteColor
{
    //    return [UIColor colorWithHex:0xECF0F1];
    return [UIColor colorWithHexString:@"F3F3F3"];
}

+ (UIColor *)flatLightWhiteColor
{
//    return [UIColor colorWithHex:0xECF0F1];
    return [UIColor colorWithHexString:@"EBEBEB"];
}

+ (UIColor *)flatLightBlueColor
{
//    return [UIColor colorWithHex:0x3498DB];
    return [UIColor colorWithHexString:@"54A8FB"];
}

+ (UIColor *)flatLightGreenColor
{
    return [UIColor colorWithHexString:@"37D354"];
//    return [UIColor colorWithHex:0x1ABC9C];
}

+ (UIColor *)flatLightYellowColor
{
    return [UIColor colorWithHex:0xF1C40F];
}

+ (UIColor *)flatLightPinkYellowColor
{
    return [UIColor colorWithHex:0xfdffe7];
}

+ (UIColor *)flatLightRedColor
{
//    return [UIColor colorWithHex:0xE74C3C];
    return [UIColor colorWithRed:247.0/255.0 green:81.0/255.0 blue:81.0/255.9 alpha:1];
}

+ (UIColor *)flatLightGrayColor
{
    return [UIColor colorWithHex:0xf2f2f2];
}

+ (UIColor *)flatOrangeColor
{
//    return [UIColor colorWithHex:0xF39C12];
    return [UIColor colorWithHexString:@"fba14d"];
}

+ (UIColor *)flatPinkColor
{
    return [UIColor colorWithRed:253.0/255 green:145.0/255 blue:181.0/255 alpha:1];
}

+ (UIColor *)flatDarkGrayColor
{
    return [UIColor colorWithHex:0x7F8C8D];
}

+ (UIColor *)flatDarkGreenColor
{
    return [UIColor colorWithHex:0x16A085];
}

+ (UIColor *)PosterRedColor
{
    return [UIColor colorWithHexString:@"fc3a39"];
}//红

+ (UIColor *)PosterOrangeColor
{
     return [UIColor colorWithHexString:@"fc9435"];
}//橙

+ (UIColor *)PosterYellowColor
{
     return [UIColor colorWithHexString:@"f7d648"];
}//黄

+ (UIColor *)PosterGreenColor
{
     return [UIColor colorWithHexString:@"c8f64b"];
}//绿

+ (UIColor *)PosterLightGreenColor
{
     return [UIColor colorWithHexString:@"07e7df"];
}//青

+ (UIColor *)PosterBlueColor
{
     return [UIColor colorWithHexString:@"86aefe"];
}//蓝

+ (UIColor *)PosterPurpleColor
{
     return [UIColor colorWithHexString:@"b287fb"];
}//紫

+ (UIColor *)flatLightBlackColor{
    return [UIColor colorWithHexString:@"424242"];
}//黑

+ (UIColor *)brighterColorWithColor:(UIColor *)color rate:(float)rate
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    CGFloat baseValue = MAX(r, MAX(g, b));
    CGFloat brightRate = (1.0-baseValue)*rate/baseValue;
    r += r*brightRate;
    g += g*brightRate;
    b += b*brightRate;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)lighterColorWithColor:(UIColor *)color rate:(float)rate
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    CGFloat lightRate = rate;
    r += (1.0-r)*lightRate;
    g += (1.0-g)*lightRate;
    b += (1.0-b)*lightRate;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
