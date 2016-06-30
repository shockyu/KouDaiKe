//
//  YKLFanModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/10/6.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLFanModel : YKLBaseModel

@property (nonatomic, strong) NSString *userId;         //用户ID
@property (nonatomic, strong) NSString *nickName;       //昵称
@property (nonatomic, strong) NSString *mobile;         //手机号码
@property (nonatomic, strong) NSString *sex;            //性别
@property (nonatomic, strong) NSString *province;       //身份
@property (nonatomic, strong) NSString *city;           //城市
@property (nonatomic, strong) NSString *headImgUrl;     //头像
@property (nonatomic, strong) NSString *orderAmount;    //交易金额
@property (nonatomic, strong) NSString *paymentTime;    //支付时间
@property (nonatomic, strong) NSString *finnshedTime;   //兑换时间

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *privilege;


@end
