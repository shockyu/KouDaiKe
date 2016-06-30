//
//  YKLUserModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/21.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"
typedef NS_ENUM(NSInteger, USERStatus) {
    USERStatusNormal    = 1,
    USERStatusNone     = 0,
};


@interface YKLUserModel : YKLBaseModel

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
@property (nonatomic, copy) NSString *agentCode;    //代理标识码
@property (nonatomic, copy) NSString *alipayName;   //支付宝账户名
@property (nonatomic, copy) NSString *alipayAccount;//支付宝账号
@property (nonatomic, copy) NSString *status;       //无效用户0，已授权1,未授权2
@property (nonatomic, copy) NSString *activityNum;  //活动个数

@property (nonatomic, copy) NSString *createTime;   //创建时间
@property (nonatomic, copy) NSString *authorization;//



+ (YKLUserModel *)defUserModel;

@end
