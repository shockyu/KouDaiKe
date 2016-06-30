//
//  YKLUserSynchronizationModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLUserSynchronizationModel : YKLBaseModel

@property (nonatomic, copy) NSDictionary *agentDic;      //代理商详情
@property (nonatomic, copy) NSString *registerAgentCode; //代理商识别码
@property (nonatomic, copy) NSString *agentName;         //代理商名字
@property (nonatomic, copy) NSString *agentMobile;       //代理商手机号
@property (nonatomic, copy) NSString *agentAddress;      //代理商地址
@property (nonatomic, copy) NSString *agentHeaderURL;    //代理商头像


@property (nonatomic, copy) NSDictionary *shopDic;      //店铺详情
@property (nonatomic, copy) NSString *unpublishedNum;   //待发布的活动数量
@property (nonatomic, copy) NSString *completeNum;      //已完成的活动数量
@property (nonatomic, copy) NSString *ongoingNum;       //进行中的活动数量
@property (nonatomic, copy) NSString *smsNum;           //短信剩余条数

@property (nonatomic, copy) NSString *shopSale;         //商户总成交量
@property (nonatomic, copy) NSString *shopVol;          //总成交额
@property (nonatomic, copy) NSString *shopExposureNum;  //总曝光
@property (nonatomic, copy) NSString *todayExposure;    //今日曝光率

@property (nonatomic, copy) NSString *userID;       //商家ID
@property (nonatomic, copy) NSString *userName;     //用户名
@property (nonatomic, copy) NSString *mobile;       //手机号码
@property (nonatomic, copy) NSString *shopName;     //店铺名
@property (nonatomic, copy) NSString *shopQRCode;   //二维码
@property (nonatomic, copy) NSString *address;      //地址(省市区)
@property (nonatomic, copy) NSString *street;       //街道
@property (nonatomic, copy) NSString *servicTel;    //服务电话
@property (nonatomic, copy) NSString *lianxiren;    //联系人
@property (nonatomic, copy) NSString *identityCard; //身份证
@property (nonatomic, copy) NSString *license;      //营业执照
@property (nonatomic, copy) NSString *agentCode;    //代理标识码
@property (nonatomic, copy) NSString *alipayName;   //支付宝账户名
@property (nonatomic, copy) NSString *alipayAccount;//支付宝账号
@property (nonatomic, copy) NSString *status;       //无效用户0，已授权1,未授权2
@property (nonatomic, copy) NSString *activityNum;  //活动个数

@property (nonatomic, copy) NSString *redFlowDesc;  //流量红包描述

@property (nonatomic, copy) NSString *isVip;        //1.是2.不是
@property (nonatomic, copy) NSString *vipEnd;       //VIP结束时间

@property (nonatomic, copy) NSString *money;        //口袋余额
@property (nonatomic, copy) NSString *headImg;      //个人头像

@property (nonatomic, copy) NSString *purview;      //权限位

@property (nonatomic, copy) NSMutableArray *expoArray;//曝光数据统计数组

+ (YKLUserSynchronizationModel *)defUserModel;
@end
