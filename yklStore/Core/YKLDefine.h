//
//  MPSDefine.h
//  MPStore
//
//  Created by apple on 14/10/7.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#ifndef yklStore_YKLDefine_h
#define yklStore_YKLDefine_h

typedef NS_ENUM(NSInteger, YKLLoginViewType) {
    MPSLoginViewTypeNone,
    MPSUserViewTypeOrderDetail,
    
};

// 屏幕尺寸宽
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

// 屏幕尺寸高
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define kNavbarHeight               44.0
#define kStatusbarHeight            20.0

// 提供RGB模式的UIColor定义.
#define     RGBCOLOR(r,g,b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define     RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define     HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


//判断空数组
#define ISNULLARRAY(arr) (arr == nil || (NSObject *)arr == [NSNull null] || arr.count == 0)
// 判断空值
#define ISNULL(obj)      (obj == nil || (NSObject *)obj == [NSNull null])
//判断空字符串
#define ISNULLSTR(str)   (str == nil || (NSObject *)str == [NSNull null] || str.length == 0)


#define MPS_MSG_LOGOUT @"MPS_MSG_LOGOUT"
#define MPS_MSG_NEW_ORDER @"MPS_MSG_NEW_ORDER"
#define MPS_MSG_ORDER_STATUS_CHANGE @"MPS_MSG_ORDER_STATUS_CHANGE"

#define MPS_MSG_VOUCHER @"MPS_MSG_VOUCHER"

#define MPS_MSG_USER_SCORE_CHANGE @"MPS_MSG_USER_SCORE_CHANGE"

#define MPS_MSG_CONSUMER_DEF_GUIDER_CHANGE @"MPS_MSG_CONSUMER_DEF_GUIDER_CHANGE"

typedef enum {
    EMPSUserActionTypeNone,
    EMPSUserActionTypeShareStore,
    EMPSUserActionTypeShareProduct,
    EMPSUserActionTypeShareArticle,
    EMPSUserActionTypeShareBrotherArticle
} EMPSUserActionType;

static const float MPSUserRainshedLaceH = 30;

typedef enum {
    YKLUserTypeNone,
    YKLUserTypeBoss
} YKLUserType;

//BOOL isOut = NO;

// colors

#define YKLRedColor     HEXCOLOR(0xff4747)
#define YKLTextColor    HEXCOLOR(0x3f4346)







#endif
