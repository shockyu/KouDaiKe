//
//  PathManager.m
//  TuJing
//
//  Created by Will Bin on 14-7-10.
//  Copyright (c) 2014年 willbin. All rights reserved.
//

#import "PathManager.h"

#include <sys/sysctl.h>
#include <sys/utsname.h>

@implementation PathManager

#pragma mark - 基本信息

+ (NSString *)getSelfName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)getSelfBundleName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)getSelfIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

#pragma mark - 尾部信息

+ (NSString *)getselfDeviceName
{
    //here use sys/utsname.h
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    NSString *destNameStr = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    destNameStr = [destNameStr length] ? destNameStr : @"null";
    return destNameStr;  
}

+ (NSString *)getselfDeviceType
{
    // iphone 1,   iPad 2
    NSString *devTypeStr = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"2" : @"1";
    return devTypeStr;
}

+ (NSString *)getSystemVersion
{
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    if (!ver) {
        ver = @"";
    }
	return ver;
}

+ (NSString *)getSelfVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**  *得到本机现在用的语言  * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......  */
+ (NSString*)getPreferredLanguage
{
    NSString *preferredLang = @"";
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    if (languages.count) {
        preferredLang =  languages[0];
    }
    
    return preferredLang;
}

// 不支持英文, 先把英文的处理掉
+ (BOOL)isZh_HanLanguage
{
    return YES;
    
//    BOOL isZh = NO;
//    NSString *cLan = [[self getPreferredLanguage] lowercaseString];
//    
//    if ([cLan isEqualToString:@"zh-hans"] || [cLan isEqualToString:@"zh-hant"])
//    {
//        isZh = YES;
//    }
//
//    return isZh;
}

+ (NSString *)getExpandURLString
{
    return @"";
    
//    NSString *statusStr =  @"1";
//	return [NSString stringWithFormat:@"?sysv=%@&selfv=%@&dev=%@&devn=%@&lang=%@&srclang=%@&net=%@",
//            [self getSystemVersion],
//            [self getSelfVersion],
//            [self getselfDeviceType],
//            [self getselfDeviceName],
//            [self isZh_HanLanguage] ? @"1" : @"0",
//            [self getPreferredLanguage],
//            statusStr
//            ];
}

#pragma mark - app path

+ (NSString *)getTemporaryPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)getCachePath
{
    NSArray *CachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *directory = [CachePaths objectAtIndex:0];
    
    return directory;
}

+ (NSString *)getDraftCachePath
{
    NSString *cStr = [PathManager getCachePath];
    cStr = [cStr stringByAppendingPathComponent:@"/draft"];
    return cStr;
}

#pragma mark - Func

+ (BOOL)isDirectoryForPath:(NSString *)pathStr
{
    BOOL isDir;
    [[NSFileManager defaultManager] fileExistsAtPath:pathStr isDirectory:&isDir];
    return isDir;
}

#pragma mark - 基础 api 地址

+ (NSString *)getAPIHostURLString
{
    return BaseDomainURLString;
    
//    NSString *sorStr = nil;
//    if ([[QTXUserDataModel objectForDestKey:ShouldUseDEVAddr] boolValue])
//    {
//        sorStr = DEVServerString;
//    }
//    else
//    {
//        sorStr = BaseDomainURLString;
//    }
//
//    NSString *hostStr = [sorStr stringByReplacingOccurrencesOfString:kLinkHeaderStr withString:@""];
//    return hostStr;
}

+ (NSString *)getImageHostURLString
{
    return BaseDomainImagesString;

//    NSString *sorStr = nil;
//    if ([[QTXUserDataModel objectForDestKey:ShouldUseDEVAddr] boolValue])
//    {
//        sorStr = DEVServerImagesString;
//    }
//    else
//    {
//        sorStr = BaseDomainImagesString;
//    }
//
//    NSString *hostStr = [sorStr stringByReplacingOccurrencesOfString:kLinkHeaderStr withString:@""];
//    return hostStr;
}

+ (NSString *)getBaseAPIURLString
{
    return BaseDomainURLString;

//    // 优先返回D+的ip地址
//    NSString *httpdnsStr = [QTXUserDataModel objectForDestKey:kHttpDNSAPISaveKey];
//    if (httpdnsStr.length > 5)
//    {
//        NSString *rStr = [NSString stringWithFormat:@"http://%@", httpdnsStr];
//        return rStr;
//    }
//
//    // 无IP时, 请求域名形式
//    if ([[QTXUserDataModel objectForDestKey:ShouldUseDEVAddr] boolValue])
//    {
//        return DEVServerString;
//    }
//    else
//    {
//        return BaseDomainURLString;
//    }
}

//基础图片地址
+ (NSString *)getBaseImgString
{
    return BaseDomainImagesString;
    
//    if ([[QTXUserDataModel objectForDestKey:ShouldUseDEVAddr] boolValue])
//    {
//        return DEVServerImagesString;
//    }
//    else
//    {
//        NSString *httpdnsStr = [QTXUserDataModel objectForDestKey:kHttpDNSImgSaveKey];
//        if (httpdnsStr.length > 5)
//        {
//            NSString *rStr = [NSString stringWithFormat:@"http://%@", httpdnsStr];
//            return rStr;
//        }
//        else
//        {
//            return BaseDomainImagesString;
//        }
//    }
}

//基础地址
+ (NSString *)getBaseURLString
{
    return BaseDomainURLString;

//    if ([[QTXUserDataModel objectForDestKey:ShouldUseDEVAddr] boolValue])
//    {
//        return DEVServerString;
//    }
//    else
//    {
//        return BaseDomainURLString;
//    }
}

#pragma mark - 账号注册和登录
//注册
+ (NSString *)userSignupUrlString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/signup",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

//登录
+ (NSString *)userloginUrlString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/login",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

// 微博授权登录
+ (NSString *)userWeiboLoginUrlString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/weibo",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

// QQ授权登录
+ (NSString *)userQQLoginUrlString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/qq",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

// 微信授权登录
+ (NSString *)userWeixinLoginUrlString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/weixin",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

// 新头像修改
+ (NSString *)newUserUpdateAvatarUrlString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/avatar",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

// 资料修改
+ (NSString *)userUpdateInfoUrlString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/postdetail",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

//用户关注
+ (NSString *)userFollowURLString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/followed",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

// 批量关注
+ (NSString *)userFollowListURLString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/followlist",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

//用户取消关注
+ (NSString *)userUnfollowURLString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/unfollowed",
                        [self getBaseAPIURLString]];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

//用户信息
+ (NSString *)userDetailURLStringWithUserIDStr:(NSString *)uIDStr
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/user/info/user_id/%@",
                        [self getBaseAPIURLString], uIDStr];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

#pragma mark -  请求地址

+ (NSString *)postDetailUrlStringWithPostID:(NSString *)pIDStr
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/post/detail/%@",
                        [self getBaseAPIURLString], pIDStr];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

// 用户
+ (NSString *)getHomeFeedURLStringWithLimit:(NSString *)limit
                                       Page:(NSString *)Page
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/post/homefeed/limit/%@/page/%@",
                        [self getBaseAPIURLString],limit,Page];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}


#pragma mark - 口袋说

/*
 @"act"           : @"get_fileList",
 @"API_Token"     : @"EPveMP8T-dJ_NGsoNN7VNZAX",
 */

// 首页列表
+ (NSString *)getKDSListURLString;
{
    NSString *urlStr = [NSString stringWithFormat:@"%@?act=%@&API_Token=%@",
                        [self getBaseAPIURLString],@"get_fileList",@"EPveMP8T-dJ_NGsoNN7VNZAX"];
    return urlStr;
 
}

// 收藏列表
+ (NSString *)getKDSFavouriteURLString
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",
                        [self getBaseAPIURLString],@"get_file_collection"];
    return [urlStr stringByAppendingString:[self getExpandURLString]];
}

@end
