//
//  YKLShopInfoModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/10/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLShopInfoModel : YKLBaseModel

@property (nonatomic, copy) NSString *userID;       //商家ID
@property (nonatomic, copy) NSString *userName;     //用户名
@property (nonatomic, copy) NSString *mobile;       //手机号码
@property (nonatomic, copy) NSString *shopName;     //店铺名
@property (nonatomic, copy) NSString *address;      //地址(省市区)
@property (nonatomic, copy) NSString *street;       //街道
@property (nonatomic, copy) NSString *servicTel;    //服务电话
@property (nonatomic, copy) NSString *lianxiren;    //联系人
@property (nonatomic, copy) NSString *identityCard; //身份证
@property (nonatomic, copy) NSString *license;      //营业执照
@property (nonatomic, copy) NSString *shopQRCode;   //二维码
@property (nonatomic, copy) NSString *agentCode;    //代理标识码

@property (nonatomic, copy) NSString *agentName;   //服务商户名
@property (nonatomic, copy) NSString *agentMobile;//服务商电话

@property (nonatomic, copy) NSString *status;       //无效用户0，已授权1,未授权2
@property (nonatomic, copy) NSString *activityNum;  //活动个数

+ (YKLShopInfoModel *)defShopInfoModel;

@end
