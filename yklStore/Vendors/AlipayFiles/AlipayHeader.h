//
//  AlipayHeader.h
//  IntegratedAlipay
//
//  Created by Winann on 15/1/9.
//  Copyright (c) 2015年 Winann. All rights reserved.
//

/**
 *  1. 将本工程中的IntegratedAlipay文件夹导入工程中，记得选copy；
 *  2. 点击项目名称,点击“Build Settings”选项卡,在搜索框中,以关键字“search” 搜索,对“Header Search Paths”增加头文件路径:“$(SRCROOT)/项目名称/IntegratedAlipay/AlipayFiles”（注意：不包括引号，如果不是放到项目根目录下，请在项目名称后面加上相应的目录名）；
 *  3. 点击项目名称,点击“Build Phases”选项卡,在“Link Binary with Librarles” 选项中,新增“AlipaySDK.framework”和“SystemConfiguration.framework” 两个系统库文件。如果项目中已有这两个库文件,可不必再增加；
 *  4. 在本头文件中设置kPartnerID、kSellerAccount、kNotifyURL、kAppScheme和kPrivateKey的值（所有的值在支付宝回复的邮件里面：注意，建议除appScheme以外的字段都从服务器请求）；
 *  5. 点击项目名称,点击“Info”选项卡，在URL types里面添加一项，Identifier可以不填，URL schemes必须和appScheme的值相同，用于支付宝处理回到应用的事件；
 *  6. 在需要用的地方导入“AlipayHeader.h”，并使用“[AlipayRequestConfig alipayWithPartner:...”方法进行支付；
 *  7. 在AppDelegate中处理事件回调（可直接复制下面内容）：
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
 [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
 NSLog(@"result = %@",resultDic);
 }];
 if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
 [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
 NSLog(@"result = %@",resultDic);
 }];
 }
 return YES;
 }
 */

#ifndef IntegratedAlipay_AlipayHeader_h
#define IntegratedAlipay_AlipayHeader_h


#import <AlipaySDK/AlipaySDK.h>     // 导入AlipaySDK
#import "AlipayRequestConfig.h"     // 导入支付类
#import "Order.h"                   // 导入订单类
#import "DataSigner.h"              // 生成signer的类：获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode

#import <Foundation/Foundation.h>   // 导入Foundation，防止某些类出现类似：“Cannot find interface declaration for 'NSObject', superclass of 'Base64'”的错误提示


/**
 *  partner:合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。
 *
 */
#define kPartnerID @"2088711420708521"


/**
 *  seller:支付宝收款账号,手机号码或邮箱格式。
 */
#define kSellerAccount @"2083007848@qq.com"

/**
 *  支付宝服务器主动通知商户 网站里指定的页面 http 路径。
 */

//#define kNotifyURL @"http://ykl.meipa.net/admin.php/TestBargain/alipay_notify"//测试支付宝回调地址

#define kNotifyURL @"http://ykl.meipa.net/admin.php/Bargain/alipay_notify"

/**
 *  联采支付宝回调
 */
#define shopNotifyURL @"http://ykl.meipa.net/admin.php/bargain/lc_alipay_notify"


//http://mpxp.meipa.net/alipay/notify_url.php

/**
 *  页面跳转同步通知页面路径。
 */
#define CallBackURL @"http://mpxp.meipa.net/alipay/call_back_url.php"
//
/**
 *  操作中断返回地址
 */
#define MerchantURL @"http://mpxp.meipa.net/alipay/interrupt.php"

/**
 *  appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
 */
#define kAppScheme @"wxb5d5bee20c705a19"



/**
 *  private_key:商户方的私钥,pkcs8 格式。
 */
#define kPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMKHM84/TfgZJ6K3LDaxFWLM1DXRzE8YqmI585rkjQSri3GrBoKciI7GOA55J4ysLXuloJi3M95jA3hvdaaeA6Zf1shvxb68wc1ZzPc6iUbnKssq5DX1a07Es7BR0zh6v0EkyFMICq1aebORgFKrgf/+IbMX2tW+icLV/Rr8Bv/ZAgMBAAECgYEAldg19NLYyZr+6B13Zm3EToX/lbGVUvxqCx4e45rYcdd+o8GdUzEnE+vmtGdpKrhalNuBuQGuZ8kXnEcndoBTyBPoh03UcmSaq/DC6knlhYcIW8Y02rtn5JsyMjhOwR1HyZbdmWqh9ZU0apz1uFKqtK75lvfZVVrkhQmb1tw0LK0CQQD7KhT5wndKfok7BEOw9CjrGTfe3hqbB3/WrrHTlRLwAhe4ftEeg6D1bfCY7uGxjZA6BiqyOMzqCozZMaH00S/bAkEAxkX59iNobEIjN6H3+g78lYnUlA3uhiT9EL3i4QA6OKuNA6+2Wv/s0l3rA83GWZqpo1jwIKAD48bJ4gkjlNQHWwJBAOXGlfH4ipHIOVuYhyT3+gc6xvZJUyXJMpcAswbSNsUD5ReQTVgRK8vcjGQdBrUcwXmT8rOhazYh+MEquvPx/EkCQBQ013edPiwiRWKLEDGcy2MWC+MW1GM5a80D/RY/Jq/V0+Y3RxdZE7KQvb3Cf99r4rPyAW7hv+O7w6FUmxq0zRcCQE1XHk+f0IFGpyW1u4SxC74g011X7GDxqtW+i4dxXE5RjH6c2VUOP1rTZoRWH1PQ3Teze0oR1ptWJpMKVtkl3c0="


#endif
