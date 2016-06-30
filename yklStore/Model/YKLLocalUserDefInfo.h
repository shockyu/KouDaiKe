//
//  MPSLocalUserDefInfo.h
//  MPStore
//
//  Created by apple on 14/11/30.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKLLocalUserDefInfo : NSObject

//@property (nonatomic, assign) YKLUserType lastUserType;

@property (nonatomic, copy) NSString *firstIN;         //更新软件后第一次进入判断

@property (nonatomic, copy) NSString *firstHelp;         //该未授权用户是否第一次进入 首页
@property (nonatomic, copy) NSString *secondHelp;        //该未授权用户是否第一次进入 发布页面
@property (nonatomic, copy) NSString *actTypeHelp;       //该未授权用户是否第一次进入 活动选择页面
@property (nonatomic, copy) NSString *settingHelp;       //该未授权用户是否第一次进入 个人中心页面
@property (nonatomic, copy) NSString *onlinePayHelp;     //该未授权用户是否第一次进入 在线支付
@property (nonatomic, copy) NSString *shareHelp;         //该未授权用户是否第一次进入 合并分享

@property (nonatomic, copy) NSString *QRcodeHelp;        //该已授权用户是否第一次进入 注册二维码

@property (nonatomic, copy) NSString *bargainDDHelp;     //首次进入到店模式砍价发布页面
@property (nonatomic, copy) NSString *bargainCXHelp;     //首次进入促销模式砍价发布页面
@property (nonatomic, copy) NSString *higoHelp;          //首次进入嗨购发布页面
@property (nonatomic, copy) NSString *duoBaoHelp;        //首次进入夺宝发布页面
@property (nonatomic, copy) NSString *miaoShaHelp;       //首次进入秒杀发布页面
@property (nonatomic, copy) NSString *suDingHelp;        //首次进入速定发布页面


@property (nonatomic, copy) NSString *isRegister;        //是否注册
@property (nonatomic, copy) NSString *isLogin;           //是否登陆

@property (nonatomic, copy) NSString *unpublishedNum;   //待发布的活动数量
@property (nonatomic, copy) NSString *completeNum;      //已完成的活动数量
@property (nonatomic, copy) NSString *ongoingNum;       //进行中的活动数量
@property (nonatomic, copy) NSString *smsNum;           //剩余短信条数
@property (nonatomic, copy) NSString *shopExposureNum;  //总曝光

@property (nonatomic, copy) NSString *userID;           //商家ID / shopID
@property (nonatomic, copy) NSString *userName;         //用户名
@property (nonatomic, copy) NSString *mobile;           //手机号码
@property (nonatomic, copy) NSString *shopName;         //店铺名
@property (nonatomic, copy) NSString *address;          //地址(省市区)
@property (nonatomic, copy) NSString *street;           //街道
@property (nonatomic, copy) NSString *servicTel;        //服务电话
@property (nonatomic, copy) NSString *lianxiren;        //联系人
@property (nonatomic, copy) NSString *identityCard;     //身份证
@property (nonatomic, copy) NSString *license;          //营业执照
@property (nonatomic, copy) NSString *shopQRCode;       //二维码
@property (nonatomic, copy) NSString *agentCode;        //代理标识码
@property (nonatomic, copy) NSString *agentName;        //代理商名字
@property (nonatomic, copy) NSString *agentMobile;      //代理商手机号
@property (nonatomic, copy) NSString *agentAddress;     //代理商地址
@property (nonatomic, copy) NSString *agentHeaderURL;   //代理商头像


@property (nonatomic, copy) NSString *alipayName;       //支付宝账户名
@property (nonatomic, copy) NSString *alipayAccount;    //支付宝账号
@property (nonatomic, copy) NSString *status;           //无效用户0，已授权1,未授权2
@property (nonatomic, copy) NSString *isVip;            //1.是2.不是
@property (nonatomic, copy) NSString *vipEnd;           //vipEnd结束时间
@property (nonatomic, copy) NSString *money;            //零钱余额
@property (nonatomic, copy) NSString *headImage;        //个人头像


@property (nonatomic, copy) NSString *activityNum;      //活动个数

@property (nonatomic, copy) NSString *payStatus;        //支付状态
@property (nonatomic, copy) NSString *isFirst;          //授权支付判断

@property (nonatomic, copy) NSMutableDictionary *saveActInfoDict;           //大砍价线下付草稿
@property (nonatomic, copy) NSMutableDictionary *saveOnlinePayActInfoDict;  //大砍价线上付草稿
@property (nonatomic, copy) NSMutableDictionary *saveHighGoActInfoDict;     //一元抽奖草稿
@property (nonatomic, copy) NSMutableDictionary *savePrizesActInfoDict;     //口袋红包草稿
@property (nonatomic, copy) NSMutableDictionary *saveDuoBaoActInfoDict;     //口袋夺宝草稿
@property (nonatomic, copy) NSMutableDictionary *saveMiaoShaActInfoDict;    //全民秒杀草稿
@property (nonatomic, copy) NSMutableDictionary *saveSuDingActInfoDict;     //一元速定草稿

@property (nonatomic, copy) NSMutableDictionary *shopPayInfoDict;           //商品付款信息字典
@property (nonatomic, copy) NSString *payWay;                               //付款方式

//临时分享所需字段
@property (nonatomic, copy) NSString *isShowShare; //付款后是否弹出分享
@property (nonatomic, copy) NSString *shareURL;     //分享链接
@property (nonatomic, copy) NSString *shareTitle;   //分享标题
@property (nonatomic, copy) NSString *shareDesc;    //分享介绍
@property (nonatomic, copy) NSString *shareImage;   //分享图片
@property (nonatomic, copy) NSString *shareActType; //分享活动类型

@property (nonatomic, copy) NSString *redFlowDesc;      //流量红包描述
@property (nonatomic, copy) NSString *actType;          //0.全民砍价 1.一元秒杀 2.一元速定 3.口袋夺宝 4.一元抽奖 5.口袋红包

@property (nonatomic, copy) NSString *purview;      //权限位 1.联采 2.web(不用) 3.砍价 4.夺宝

+ (YKLLocalUserDefInfo *)defModel;

- (void)copyLocalFileToDocument;
- (void)loadFromLocalFile;
- (void)saveToLocalFile;

// 当发现当前登陆的用户和上一次登陆的用户不一样时，清除上一次用户的默认信息
- (void)clearDefInfo;

@end
