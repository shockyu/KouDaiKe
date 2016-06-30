

#import <Foundation/Foundation.h>
#import "WXUtil.h"
#import "ApiXml.h"


// 账号帐户资料

#define APP_ID          @"wxb5d5bee20c705a19"               //APPID
#define APP_SECRET      @"da7264786cad49773a834944238b1574" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1269532301"
//商户API密钥，填写相应参数 //ae1891c40ac69ad7493ea317b3f74921
#define PARTNER_ID      @"JnCMVI3eHRCsqqprcR96nSWlIpFPFYNB"
//支付结果回调页面
//#define NOTIFY_URL      @"http://ykl.meipa.net/admin.php/TestBargain/wx_notify"//测试微信支付回调

#define NOTIFY_URL      @"http://ykl.meipa.net/admin.php/Bargain/wx_notify"

//联采微信回到
#define SHOP_NOTIFY_URL @"http://ykl.meipa.net/admin.php/bargain/lc_wx_notify"

//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

//商户平台api密匙
//#define SPKEY           @"E9997E917698EB98AD1E75D93B696018"


@interface payRequsestHandler : NSObject{
	//预支付网关url地址
    NSString *payUrl;

    //lash_errcode;
    long     last_errcode;
	//debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
    
    
}
//初始化函数
-(BOOL) init:(NSString *)app_id mch_id:(NSString *)mch_id;
-(NSString *) getDebugifo;
-(long) getLasterrCode;
//设置商户密钥
-(void) setKey:(NSString *)key;
//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;
//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//签名实例
//- ( NSMutableDictionary *)sendPay_demo;
- ( NSMutableDictionary *)sendPay_demo:(NSString *)orderName
                            OrderPrice:(NSString *)orderPrice
                              OrderNub:(NSString *)orderNub
                             NotifyURL:(NSString *)notifyURL;

@property (nonatomic, copy) NSString *getPrepayID;
@end