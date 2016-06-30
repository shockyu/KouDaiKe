//
//  PathManager.h
//  TuJing
//
//  Created by Will Bin on 14-7-10.
//  Copyright (c) 2014年 willbin. All rights reserved.
//

#import <Foundation/Foundation.h>

//Image 服务器
//正式
#define BaseDomainImagesString      @"http://ykl.meipa.net/admin.php/ZzsApi"

// API 服务器
// 正式
#define BaseDomainURLString         @"http://ykl.meipa.net/admin.php/ZzsApi"

// 基础域名
#define WebDomainURLString          @"http://ykl.meipa.net/admin.php/ZzsApi"




@interface PathManager : NSObject

#pragma mark -  基础地址

// 系统相关
+ (NSString *)getSelfName;
+ (NSString *)getSelfVersion;
+ (NSString *)getSelfBundleName;
+ (NSString *)getSelfIdentifier;
+ (BOOL)isZh_HanLanguage;       // 是否是中文系统 

// 系统路径
+ (NSString *)getTemporaryPath;
+ (NSString *)getCachePath;

// 目前用不到
+ (NSString *)getDraftCachePath;

+ (BOOL)isDirectoryForPath:(NSString *)pathStr;

#pragma mark -  基础 api 地址

+ (NSString *)getAPIHostURLString;
+ (NSString *)getImageHostURLString;

+ (NSString *)getBaseAPIURLString;

//基础图片地址
+ (NSString *)getBaseImgString;

//基础地址
+ (NSString *)getBaseURLString;

+ (NSString *)shareURLTailStringForType:(NSString *)typeStr;


#pragma mark - 用户相关
//注册
+ (NSString *)userSignupUrlString;

//登录
+ (NSString *)userloginUrlString;

// 微博授权登录
+ (NSString *)userWeiboLoginUrlString;

// QQ授权登录
+ (NSString *)userQQLoginUrlString;

// 微信授权登录
+ (NSString *)userWeixinLoginUrlString;

// 新头像修改
+ (NSString *)newUserUpdateAvatarUrlString;

// 资料修改
+ (NSString *)userUpdateInfoUrlString;

//用户关注列表
+ (NSString *)userFollowListURLStringWithUserId:(NSString *)userId
                                          Limit:(NSString *)limit
                                           Page:(NSString *)page;

// 我的粉丝
+ (NSString *)userFansListURLStringWithUIDStr:(NSString *)uIDStr
                                        Limit:(NSString *)limit
                                         Page:(NSString *)page;

// 赞 的用户列表
+ (NSString *)postLikersUserListURLStringWithUIDStr:(NSString *)uIDStr
                                              Limit:(NSString *)limit
                                               Page:(NSString *)page;

//用户关注
+ (NSString *)userFollowURLString;

// 批量关注
+ (NSString *)userFollowListURLString;


//用户取消关注
+ (NSString *)userUnfollowURLString;

//用户信息
+ (NSString *)userDetailURLStringWithUserIDStr:(NSString *)uIDStr;

#pragma mark -  请求地址

+ (NSString *)postDetailUrlStringWithPostID:(NSString *)pIDStr;

// 编辑精选
+ (NSString *)getHomeFeedURLStringWithLimit:(NSString *)limit
                                       Page:(NSString *)Page;



#pragma mark - 口袋说

// 首页列表
+ (NSString *)getKDSListURLString;

// 收藏列表
+ (NSString *)getKDSFavouriteURLString;






@end
