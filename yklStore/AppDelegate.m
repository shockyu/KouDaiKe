//
//  AppDelegate.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YKLShopPayResultViewController.h"

#import "WXApi.h"
#import "AlipayHeader.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"

//服务端签名只需要用到下面一个头文件
//#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>
////////////////////
#import "APService.h"

#import "YKLUserGuideViewController.h"
#import "YKLBaseNavigationController.h"
#import "YKLPushWebViewController.h"
#import "YKLMainMenuViewController.h"
//分享控制器
#import "YKLTogetherShareViewController.h"

#import "UncaughtExceptionHandler.h"

@interface AppDelegate ()<WXApiDelegate>


@end

@implementation AppDelegate

- (void)startNetworkMonitoring
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         self.networkStatus = status;
     }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self startNetworkMonitoring];
    
    //设置启动页面时间
    [NSThread sleepForTimeInterval:0.5];
        
    
    //新版本新增字段初始化
    if ([YKLLocalUserDefInfo defModel].actType == nil) {
        [YKLLocalUserDefInfo defModel].actType = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].redFlowDesc == nil) {
        [YKLLocalUserDefInfo defModel].redFlowDesc = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].agentCode == nil) {
        [YKLLocalUserDefInfo defModel].agentCode = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].agentName == nil) {
        [YKLLocalUserDefInfo defModel].agentName = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].agentMobile == nil) {
        [YKLLocalUserDefInfo defModel].agentMobile = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].agentAddress == nil) {
        [YKLLocalUserDefInfo defModel].agentAddress = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].agentHeaderURL == nil) {
        [YKLLocalUserDefInfo defModel].agentHeaderURL = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].shareURL == nil||[YKLLocalUserDefInfo defModel].shareTitle == nil||[YKLLocalUserDefInfo defModel].shareDesc == nil||[YKLLocalUserDefInfo defModel].shareImage == nil||[YKLLocalUserDefInfo defModel].shareActType == nil||[YKLLocalUserDefInfo defModel].isShowShare == nil){
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"";
        [YKLLocalUserDefInfo defModel].shareURL = @"";
        [YKLLocalUserDefInfo defModel].shareTitle = @"";
        [YKLLocalUserDefInfo defModel].shareDesc = @"";
        [YKLLocalUserDefInfo defModel].shareImage = @"";
        [YKLLocalUserDefInfo defModel].shareActType = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].firstHelp == nil||[YKLLocalUserDefInfo defModel].secondHelp == nil||[YKLLocalUserDefInfo defModel].actTypeHelp == nil||[YKLLocalUserDefInfo defModel].settingHelp == nil||[YKLLocalUserDefInfo defModel].onlinePayHelp == nil||[YKLLocalUserDefInfo defModel].shareHelp == nil||[YKLLocalUserDefInfo defModel].QRcodeHelp == nil) {
        
        [YKLLocalUserDefInfo defModel].firstHelp = @"";
        [YKLLocalUserDefInfo defModel].secondHelp = @"";
        [YKLLocalUserDefInfo defModel].actTypeHelp = @"";
        [YKLLocalUserDefInfo defModel].settingHelp = @"";
        [YKLLocalUserDefInfo defModel].onlinePayHelp = @"";
        [YKLLocalUserDefInfo defModel].shareHelp = @"";
        [YKLLocalUserDefInfo defModel].QRcodeHelp = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].bargainDDHelp == nil||[YKLLocalUserDefInfo defModel].bargainCXHelp == nil||[YKLLocalUserDefInfo defModel].higoHelp == nil||[YKLLocalUserDefInfo defModel].duoBaoHelp == nil||[YKLLocalUserDefInfo defModel].miaoShaHelp == nil||[YKLLocalUserDefInfo defModel].suDingHelp == nil) {
        
        [YKLLocalUserDefInfo defModel].bargainDDHelp = @"";
        [YKLLocalUserDefInfo defModel].bargainCXHelp = @"";
        [YKLLocalUserDefInfo defModel].higoHelp = @"";
        [YKLLocalUserDefInfo defModel].duoBaoHelp = @"";
        [YKLLocalUserDefInfo defModel].miaoShaHelp = @"";
        [YKLLocalUserDefInfo defModel].suDingHelp = @"";
    }
    
    
    
    if ([YKLLocalUserDefInfo defModel].address == nil||[YKLLocalUserDefInfo defModel].street == nil) {
        
        [YKLLocalUserDefInfo defModel].address = @"";
        [YKLLocalUserDefInfo defModel].street = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].saveActInfoDict == nil) {
        
        [YKLLocalUserDefInfo defModel].saveActInfoDict = [NSMutableDictionary new];
        
    }
    
    if ([YKLLocalUserDefInfo defModel].saveHighGoActInfoDict == nil) {
        
        [YKLLocalUserDefInfo defModel].saveHighGoActInfoDict = [NSMutableDictionary new];
    }
    
    if ([YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict == nil) {
        
        [YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict = [NSMutableDictionary new];
    }
    
    if ([YKLLocalUserDefInfo defModel].savePrizesActInfoDict == nil) {
        
        [YKLLocalUserDefInfo defModel].savePrizesActInfoDict = [NSMutableDictionary new];
    }
    
    if ([YKLLocalUserDefInfo defModel].saveDuoBaoActInfoDict == nil) {
        
        [YKLLocalUserDefInfo defModel].saveDuoBaoActInfoDict = [NSMutableDictionary new];
    }
    
    if ([YKLLocalUserDefInfo defModel].saveMiaoShaActInfoDict == nil) {
        
        [YKLLocalUserDefInfo defModel].saveMiaoShaActInfoDict = [NSMutableDictionary new];
    }
    
    if ([YKLLocalUserDefInfo defModel].saveSuDingActInfoDict == nil) {
        
        [YKLLocalUserDefInfo defModel].saveSuDingActInfoDict = [NSMutableDictionary new];
    }
    
    if ([YKLLocalUserDefInfo defModel].shopPayInfoDict == nil) {
        
        [YKLLocalUserDefInfo defModel].shopPayInfoDict = [NSMutableDictionary new];
    }

    if ([YKLLocalUserDefInfo defModel].payWay == nil) {
        
        [YKLLocalUserDefInfo defModel].payWay = @"";
    }

    
    if ([YKLLocalUserDefInfo defModel].firstIN == nil||[[YKLLocalUserDefInfo defModel].firstIN isBlankString]) {
        
        [YKLLocalUserDefInfo defModel].firstIN = @"YES";
    }
    
    if ([YKLLocalUserDefInfo defModel].isVip == nil) {
        [YKLLocalUserDefInfo defModel].isVip = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].vipEnd == nil) {
        [YKLLocalUserDefInfo defModel].vipEnd = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].money == nil) {
        [YKLLocalUserDefInfo defModel].money = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].headImage == nil) {
        [YKLLocalUserDefInfo defModel].headImage = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].purview == nil) {
        [YKLLocalUserDefInfo defModel].purview = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].shopQRCode == nil) {
        [YKLLocalUserDefInfo defModel].shopQRCode = @"";
    }
    
    if ([YKLLocalUserDefInfo defModel].servicTel == nil) {
        [YKLLocalUserDefInfo defModel].servicTel = @"";
    }
    
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    
    if ([ZZSLocalUserDefInfo defModel].playingMusicName == nil ||[ZZSLocalUserDefInfo defModel].playingMusicFileName == nil || [ZZSLocalUserDefInfo defModel].startTime == nil ||[ZZSLocalUserDefInfo defModel].endTime == nil ||[ZZSLocalUserDefInfo defModel].currentTime == nil || [ZZSLocalUserDefInfo defModel].duration == nil) {
        
        [ZZSLocalUserDefInfo defModel].playingMusicName = @"";
        [ZZSLocalUserDefInfo defModel].playingMusicFileName = @"";
        [ZZSLocalUserDefInfo defModel].startTime = @"";
        [ZZSLocalUserDefInfo defModel].endTime = @"";
        [ZZSLocalUserDefInfo defModel].currentTime = @"";
        [ZZSLocalUserDefInfo defModel].duration = @"";
        
    }
    [[ZZSLocalUserDefInfo defModel]saveToLocalFile];
    
    if ([[YKLLocalUserDefInfo defModel].firstIN isEqual:@"YES"]) {
    
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        YKLUserGuideViewController *userGuideViewController = [[YKLUserGuideViewController alloc] init];
        self.window.rootViewController = userGuideViewController;
    }
    else
    {
        NSLog(@"不是第一次启动");
        
        //如果不是第一次启动的话,使用LoginViewController作为根视图
        ViewController *firstVC = [[ViewController alloc] init];
        self.window.rootViewController = firstVC;
    }

    
    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    
    /*
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
     */
    
    // 配置推送
    {
        // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            //categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        }
        else
        {
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
#else
                                               categories:nil];
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
#endif
             // Required
                                               categories:nil];
        }
        
        [APService setupWithOption:launchOptions];
    }
    
    // 如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsLocalNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他。
    {
#warning 推送消息的另一个入口
        NSDictionary  *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification.count)
        {
            NSLog(@"%@", remoteNotification);
        }
    }
    
    // 崩溃了调用捕捉
//    InstallUncaughtExceptionHandler();
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

#pragma mark - 极光推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Required
    [APService registerDeviceToken:deviceToken];
}

// 如果 App状态为正在前台或者后台运行，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行。此种情况在此函数中处理：
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"active");
        //程序当前正处于前台
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    }
    else if(application.applicationState == UIApplicationStateInactive)
    {
        NSLog(@"inactive");
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    /*
     {
     "_j_msgid" = 3492569335;
     aps =     {
     alert = "\U53e3\U888b\U5ba2\U795d\U5927\U5bb6\U516d\U4e00\U513f\U7ae5\U8282\U5feb\U4e50";
     "content-available" = 1;
     sound = "";
     };
     title = "\U6807\U9898";
     type = web;
     url = "http://www.01gou.cn";
     }
     */
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *type = [userInfo valueForKey:@"type"];
    NSString *url = [userInfo valueForKey:@"url"];
    NSDictionary *extras = [userInfo valueForKey:@"aps"];
    NSString *aTitle = [extras valueForKey:@"alert"];
    
    [UIAlertView showInfoMsg:aTitle];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void
                                                                                                                               (^)(UIBackgroundFetchResult))completionHandler
{
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    // 取得 APNs 标准信息内容
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *type = [userInfo valueForKey:@"type"];
    NSString *url = [userInfo valueForKey:@"url"];
    NSDictionary *extras = [userInfo valueForKey:@"aps"];
    NSString *aTitle = [extras valueForKey:@"alert"];
    
    if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"active");
        //程序当前正处于前台
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
        
        [UIAlertView showInfoMsg:title];

    }
    else if(application.applicationState == UIApplicationStateInactive)
    {
        NSLog(@"inactive");
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
        
    }
    YKLPushWebViewController *pushVC = [YKLPushWebViewController new];
    pushVC.hidenBar = YES;
    pushVC.webTitle = userInfo[@"title"];
    pushVC.webURL = userInfo[@"url"];
    self.window.rootViewController = pushVC;
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData
//                                     mutabilityOption:NSPropertyListImmutable
//                                               format:NULL
//                                     errorDescription:NULL];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData
                                              options:NSPropertyListImmutable
                                               format:NULL
                                                error:NULL];
    return str;
}

#pragma mark - WX api

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);

#pragma mark - 支付宝回调
    
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        
        NSString *object=[resultDic objectForKey:@"resultStatus"];
        NSLog(@"%@",object);
        
        if ([object isEqualToString:@"9000"])
        {
            NSLog(@"成功%@", CallBackURL);
            
            [YKLLocalUserDefInfo defModel].payStatus = @"成功";
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            
            if ([[YKLLocalUserDefInfo defModel].isShowShare isEqual:@"YES"])
            {
                
                YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                ShareVC.hidenBar = YES;
                ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                self.window.rootViewController = ShareVC;
                
            }
            else
            {
                if (![[YKLLocalUserDefInfo defModel].shopPayInfoDict isEqual:@{}]) {
                    
                    YKLShopPayResultViewController *vc = [YKLShopPayResultViewController new];
                    vc.type = 1;
                    
                    YKLBaseNavigationController *naVC = [[YKLBaseNavigationController alloc]initWithRootViewController:vc];
                    self.window.rootViewController = naVC;
                }
                else{
                    
                    ViewController *firstVC = [[ViewController alloc] init];
                    self.window.rootViewController = firstVC;
                    
                }
            }
            
        }
        else{
            NSLog(@"失败%@",MerchantURL);
            
            [YKLLocalUserDefInfo defModel].payStatus = @"失败";
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            
            if (![[YKLLocalUserDefInfo defModel].shopPayInfoDict isEqual:@{}]) {
                
                YKLShopPayResultViewController *vc = [YKLShopPayResultViewController new];
                vc.type = 2;
                
                YKLBaseNavigationController *naVC = [[YKLBaseNavigationController alloc]initWithRootViewController:vc];
                self.window.rootViewController = naVC;
            }else{
                
                ViewController *firstVC = [[ViewController alloc] init];
                self.window.rootViewController = firstVC;
                
            }
            
        }

    }];
    
    
    return YES;
    
    return  [WXApi handleOpenURL:url delegate:self];
    
}

#pragma mark - WeiXin

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == WXSuccess) {
            
            [UIAlertView showInfoMsg:@"分享成功"];
            
        }
        else {
            [UIAlertView showInfoMsg:@"分享取消"];
            
            NSLog(@"Not Share!");
        }
 
    }
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        //微信支付回调判断
        if (resp.errCode == WXSuccess) {
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            [YKLLocalUserDefInfo defModel].payStatus = @"成功";
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            
            if ([[YKLLocalUserDefInfo defModel].isShowShare isEqual:@"YES"]) {
                
                YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                ShareVC.hidenBar = YES;
                ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                self.window.rootViewController = ShareVC;
            }
            else if([[YKLLocalUserDefInfo defModel].isShowShare isEqual:@"NO"]){
            
                if (![[YKLLocalUserDefInfo defModel].shopPayInfoDict isEqual:@{}]) {
                    
                    YKLShopPayResultViewController *vc = [YKLShopPayResultViewController new];
                    vc.type = 1;
                    
                    YKLBaseNavigationController *naVC = [[YKLBaseNavigationController alloc]initWithRootViewController:vc];
                    self.window.rootViewController = naVC;
                }else{
                    
                    ViewController *firstVC = [[ViewController alloc] init];
                    self.window.rootViewController = firstVC;
                
                }
            }
            
        }else{
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            [YKLLocalUserDefInfo defModel].payStatus = @"失败";
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            
            if (![[YKLLocalUserDefInfo defModel].shopPayInfoDict isEqual:@{}]) {
                
                YKLShopPayResultViewController *vc = [YKLShopPayResultViewController new];
                vc.type = 2;
                
                YKLBaseNavigationController *naVC = [[YKLBaseNavigationController alloc]initWithRootViewController:vc];
                self.window.rootViewController = naVC;
            }else{
                
                ViewController *firstVC = [[ViewController alloc] init];
                self.window.rootViewController = firstVC;
                
            }

        }
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
