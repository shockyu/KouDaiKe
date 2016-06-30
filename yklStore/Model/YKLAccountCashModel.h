//
//  YKLAccountCashModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/22.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLAccountCashModel : YKLBaseModel


@property (nonatomic, copy) NSString *money;                //可用金额
@property (nonatomic, copy) NSString *totalRevenue;         //总收益
@property (nonatomic, copy) NSString *txMoney;              //提现中金额

@property (nonatomic, copy) NSDictionary *tempDict;
@property (nonatomic, copy) NSString *accountHolder;        //持卡人姓名
@property (nonatomic, copy) NSString *bankAccount;          //银行账号
@property (nonatomic, copy) NSString *bankName;             //银行名称
@property (nonatomic, copy) NSString *bankID;               //提现账户ID
@property (nonatomic, copy) NSString *isDefault;            //1. 默认提现账户  2. 非默认账户
@property (nonatomic, copy) NSString *type;                 //1. alipay  2. 银行卡

+ (YKLAccountCashModel *)defAccountCashModel;

@end
